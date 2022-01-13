//
//  ViewModel.swift
//  LineChart
//
//  Created by Marjo Salo on 03/12/2021.
//

import SwiftUI

struct ChartView: View {
    
    var dataPoints: [DataPoint]
    let pointSize: CGFloat
    var pointColor: Color
    var lineWidth: CGFloat
    var lineColor: Color
    var textColor: Color
    var backgroundColor: Color
    
    let maxYValue: Double
    let minYValue: Double
    let maxXValue: Double
    let minXValue: Double
    let xRange: Int
    let yRange: Int
    let xMultiplier: Int // calculates the amount of x-labels
    let yMultiplier: Int
    let xDefault: Double = 5 // default value for offset/range to be able to render just one point
    let yDefault: Double = 4

    
    // init to prevent updating issues when using computed properties
    init(dataPoints: [DataPoint], pointSize: CGFloat, pointColor: Color, lineWidth: CGFloat, lineColor: Color, textColor: Color, backgroundColor: Color) {
        self.pointSize = pointSize
        self.pointColor = pointColor
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        
        self.dataPoints = dataPoints.sorted()
        
        let highestPoint = dataPoints.max { $0.yValue < $1.yValue }
        self.maxYValue = highestPoint?.yValue ?? yDefault // default if no dataPoints available
        let lowestPoint = dataPoints.max { $0.yValue > $1.yValue }
        self.minYValue = lowestPoint?.yValue ?? 1
        self.yRange = Int(maxYValue - minYValue < 1 ? yDefault : maxYValue - minYValue)  // prevent division by 0 & crash when range less than 1
        
        self.maxXValue = dataPoints.max()?.xValue ?? xDefault // max() sufficient due to Comparable
        self.minXValue = dataPoints.min()?.xValue ?? 1
        self.xRange = Int(maxXValue - minXValue < 1 ? xDefault : maxXValue - minXValue)
        
        self.xMultiplier = xRange <= Int(xDefault) ? 1 : xRange / Int(xDefault)
        self.yMultiplier = yRange <= Int(yDefault) ? 1 : yRange / Int(yDefault) // can be other values dan defaults; takes only a small range into account, almost always range/default
    }
    
    @State private var showingLabel = false
    @State private var lineAnimation: CGFloat = .zero

    var body: some View {
        
        ZStack {
            ZStack {
                GeometryReader { geo in
                    Path { path in
                        
                        for (index, dataPoint) in dataPoints.enumerated() {
                            
                            let x = makePoints(width: geo.size.width, height: geo.size.height, dataPoint: dataPoint).x
                            let y = makePoints(width: geo.size.width, height: geo.size.height, dataPoint: dataPoint).y
                                                
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .trim(from: 0, to: lineAnimation)
                    .stroke(lineColor, lineWidth: lineWidth)
                    .onAppear { // now only on appear, how about change?
                        // need to move and addLine separately when building, since var body is always being rebuilt - how to animate only the new line?
                        // different view when profile is done?
                        withAnimation(.easeOut(duration: 1.0)) {
                            lineAnimation = 1.0
                        }
                    }
                    
                    ForEach(dataPoints, id: \.id) { dataPoint in
                
                        Path { path in
                            
                            let x = makePoints(width: geo.size.width, height: geo.size.height, dataPoint: dataPoint).x
                            let y = makePoints(width: geo.size.width, height: geo.size.height, dataPoint: dataPoint).y
                            
                            let pointX = x - (pointSize / 2) // setting up position based on pointSize - position on the circle edge
                            let pointY = y - (pointSize / 2)
                                            
                            path.addEllipse(in: CGRect(x: pointX, y: pointY, width: pointSize, height: pointSize))
                            
                        }
                        .fill(pointColor)
                        .onTapGesture {
//                            showingLabel.toggle()
                        }
                    }
                    
                    
                    ForEach(Array(stride(from: 0, through: xRange, by: self.xMultiplier)), id: \.self) { i in
                        let xOffset = makeOffset(width: geo.size.width, height: geo.size.height).xOffset
                        
                        Text("\(minXValue + Double(i), specifier: "%.1f")")
                            .font(.footnote)
                            .foregroundColor(textColor)
                            .position(x: xOffset * CGFloat(i), y: geo.size.height + 15)
                    }
                    
                    // check if correct with just one point
                    ForEach(Array(stride(from: 0, through: yRange, by: self.yMultiplier)), id: \.self) { i in
                        let yOffset = makeOffset(width: geo.size.width, height: geo.size.height).yOffset
                        
                        Text("\(minYValue + Double(yRange) - Double(i), specifier: "%.1f")")
                            .font(.footnote)
                            .foregroundColor(textColor)
                            .position(x: -15, y: yOffset * CGFloat(i))
                    }
                    
                    if showingLabel {
                        ForEach(dataPoints.indices, id: \.self) { i in
                            let x = makePositions(width: geo.size.width, height: geo.size.height, index: i).x
                            let y = makePositions(width: geo.size.width, height: geo.size.height, index: i).y
                            Text("\(dataPoints[i].yValue, specifier: "%.1f")")
                                .font(.footnote)
                                .foregroundColor(textColor)
                                .position(x: x, y: y)
                        }
                    }
                }
            }
        }
        .padding(30)
        .background(RoundedRectangle(cornerRadius: 10).fill(backgroundColor))
    }
    
    func makeOffset(width: CGFloat, height: CGFloat) -> (xOffset: CGFloat, yOffset: CGFloat) {
        let xOffset = width / CGFloat(xRange) // range, as smallest value may not be 0
        let yOffset = height / CGFloat(yRange)
        
        return (xOffset, yOffset)
    }
    
    func makePoints(width: CGFloat, height: CGFloat, dataPoint: DataPoint) -> (x: CGFloat, y: CGFloat) {
        
        let xOffset = makeOffset(width: width, height: height).xOffset
        let yOffset = makeOffset(width: width, height: height).yOffset
        
        let x = xOffset * (CGFloat(dataPoint.xValue - minXValue)) // make sure line starts from first value, not necessarily from 0
        var y = yOffset * CGFloat(dataPoint.yValue - minYValue)
        
        y = height - y // flip values, ok?
        
        return (x, y)
    }
    
    func makePositions(width: CGFloat, height: CGFloat, index: Int) -> (x: CGFloat, y: CGFloat) {
        let xOffset = makeOffset(width: width, height: height).xOffset
        let yOffset = makeOffset(width: width, height: height).yOffset
        
        let x = xOffset * (CGFloat(dataPoints[index].xValue) - minXValue)
        let y = height - yOffset * CGFloat(dataPoints[index].yValue - minYValue)
        
        return (x, y)
    }
}

struct ChartView_Previews: PreviewProvider {
    
    static var previews: some View {

        ChartView(dataPoints: TestData.example, pointSize: 15, pointColor: .yellow, lineWidth: 2, lineColor: .white, textColor: .white, backgroundColor: .teal)
            .frame(width: 250, height: 200)
        
    }
}
