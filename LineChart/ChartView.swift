//
//  ChartView.swift
//  LineChart
//
//  Created by Marjo Salo on 03/12/2021.
//

import SwiftUI

struct ChartView: View {
    
    @ObservedObject var viewModel: ViewModel
    let pointSize: CGFloat
    let pointColor: Color
    let lineWidth: CGFloat
    let lineColor: Color
    let textColor: Color
    let backgroundColor: Color
    
    @State private var showingLabel = false
    @State private var lineAnimation: CGFloat = 1.0
    @State private var xAnimation: CGFloat = 0.0
    @State private var yAnimation: CGFloat = 0.0
    @State private var duration = 0.8

    var body: some View {
        
        ZStack {
            ZStack {
                GeometryReader { geo in
                    Path { path in
                        
                        for (index, dataPoint) in viewModel.dataPoints.enumerated() {
                            
                            let x = viewModel.makePoints(width: geo.size.width, height: geo.size.height, dataPoint: dataPoint).x
                            let y = viewModel.makePoints(width: geo.size.width, height: geo.size.height, dataPoint: dataPoint).y

                                                
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .trim(from: 0.0, to: lineAnimation)
                    .stroke(lineColor, lineWidth: lineWidth)
                    .onChange(of: viewModel.dataPoints) { _ in
                        lineAnimation = 0.0
                        withAnimation(.easeOut(duration: 1)) {
                            lineAnimation = 1.0
                        }
                    }
                    
                    ForEach(viewModel.dataPoints, id: \.id) { dataPoint in // points
                
                        Path { path in
                            
                            let x = viewModel.makePoints(width: geo.size.width, height: geo.size.height, dataPoint: dataPoint).x
                            let y = viewModel.makePoints(width: geo.size.width, height: geo.size.height, dataPoint: dataPoint).y
                            
                            let pointX = x - (pointSize / 2) // setting up center position based on pointSize
                            let pointY = y - (pointSize / 2)
                                            
                            path.addEllipse(in: CGRect(x: pointX, y: pointY, width: pointSize, height: pointSize))
                            
                        }
                        .fill(pointColor)
                        .onTapGesture {
                            showingLabel.toggle()
                        }
                    }
                    
                    
                    ForEach(Array(stride(from: 0, through: viewModel.xRange, by: viewModel.xMultiplier)), id: \.self) { i in // xLabels
                        let value = viewModel.minXValue + i

                        Text(value.toDateString())
                            .font(.footnote)
                            .foregroundColor(textColor)
                            .position(x: xAnimation * i, y: geo.size.height + 15)
                    }
                    .onAppear {
                        withAnimation(.easeOut(duration: duration)) {
                            xAnimation = viewModel.makeOffset(width: geo.size.width, height: geo.size.height).xOffset
                        }
                    }
                    .onChange(of: viewModel.xRange) { newValue in
                        withAnimation(.easeOut(duration: duration)) {
                            xAnimation = makeLabelAnimation(distance: geo.size.width, range: newValue)
                        }
                    }
                    .onChange(of: viewModel.minXValue) { _ in
                        if viewModel.xRange == viewModel.defaultXRange {
                            xAnimation = 0.0
                            withAnimation(.easeOut(duration: duration)) {
                                xAnimation = viewModel.makeOffset(width: geo.size.width, height: geo.size.height).xOffset
                            }
                        }
                    }
                    
                    ForEach(Array(stride(from: 0, through: viewModel.yRange, by: viewModel.yMultiplier)), id: \.self) { i in // yLabels
                        Text("\(viewModel.yLabelValue - i, specifier: "%.2f")")
                            .font(.footnote)
                            .foregroundColor(textColor)
                            .position(x: -15, y: yAnimation * i)
                    }
                    .onAppear {
                        withAnimation(.easeOut(duration: duration)) {
                            yAnimation = viewModel.makeOffset(width: geo.size.width, height: geo.size.height).yOffset
                        }
                    }
                    .onChange(of: viewModel.minYValue) { _ in
                        if viewModel.yRange == viewModel.defaultYRange {
                            yAnimation = 0.0
                            withAnimation(.easeOut(duration: duration)) {
                                yAnimation = viewModel.makeOffset(width: geo.size.width, height: geo.size.height).yOffset
                            }
                        }
                    }
                    .onChange(of: viewModel.yRange) { newValue in
                        withAnimation(.easeOut(duration: duration)) {
                            yAnimation = makeLabelAnimation(distance: geo.size.height, range: newValue)
                        }
                    }
                    
//                    if showingLabel {
//                        ForEach(viewModel.dataPoints.indices, id: \.self) { i in
//                            let x = viewModel.makePositions(width: geo.size.width, height: geo.size.height, index: i).x
//                            let y = viewModel.makePositions(width: geo.size.width, height: geo.size.height, index: i).y
//                            Text("\(viewModel.dataPoints[i].formattedTime)")
//                                .font(.footnote)
//                                .foregroundColor(viewModel.textColor)
//                                .position(x: x, y: y)
//                        }
//                    }
                }
            }
        }
        .padding(30)
        .background(RoundedRectangle(cornerRadius: 10).fill(backgroundColor))
    }
    
    func makeLabelAnimation(distance: Double, range: Double) -> Double {
        var offset: Double = 0
        withAnimation {
            offset = distance / range
        }
        return offset
    }
}

struct ChartView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        VStack(spacing: 25) {
            ChartView(viewModel: ChartView.ViewModel(dataPoints: DataPoint.pHexample), pointSize: 12, pointColor: .yellow, lineWidth: 2, lineColor: .white, textColor: .white, backgroundColor: .teal)
                .frame(width: 250, height: 200)
            
//            ChartView(viewModel: ChartView.ViewModel(dataPoints: DataPoint.tdsExample), pointSize: 12, pointColor: .yellow, lineWidth: 2, lineColor: .white, textColor: .white, backgroundColor: .pink)
//                .frame(width: 250, height: 200)
            
            ChartView(viewModel: ChartView.ViewModel(dataPoints: []), pointSize: 12, pointColor: .gray, lineWidth: 2, lineColor: .white, textColor: .white, backgroundColor: .yellow)
                .frame(width: 250, height: 200)
        }
    }
}
