//
//  ChartViewModel.swift
//  LineChart
//
//  Created by Marjo Salo on 05/04/2022.
//

import Foundation

extension ChartView {
    final class ViewModel: ObservableObject {
        @Published var dataPoints: [DataPoint]
        
        let maxYValue: Double
        let minYValue: Double
        let maxXValue: Double
        let minXValue: Double
        let xRange: Double
        let yRange: Double
        let xMultiplier: Double // calculates the amount of labels
        let yMultiplier: Double
        let defaultXRange: Double = 4.0 * 3600 // default value for offset/range to be able to render an empty chart or a single point; amount of hours in seconds
        let defaultYRange: Double = 0.8

        // init to prevent updating issues when using computed properties
        init(dataPoints: [DataPoint]) {
            self.dataPoints = dataPoints.sorted()
                
            let highestPoint = dataPoints.max { $0.yValue < $1.yValue }
            self.maxYValue = highestPoint?.yValue ?? 8.0
            let lowestPoint = dataPoints.max { $0.yValue > $1.yValue }
            self.minYValue = lowestPoint?.yValue ?? 7.0
            self.yRange = maxYValue - minYValue < defaultYRange ? defaultYRange : maxYValue - minYValue
            
            self.maxXValue = dataPoints.max()?.time ?? defaultXRange // max() sufficient due to Comparable on x
            self.minXValue = dataPoints.min()?.time ?? Date.nowToDouble()
            self.xRange = maxXValue - minXValue < defaultXRange ? defaultXRange : maxXValue - minXValue // consider when to use full chart for line
            
            let amountOfXLabels: Double = 4
            let amountOfYLabels: Double = 4
            self.xMultiplier = xRange / amountOfXLabels
            self.yMultiplier = yRange / amountOfYLabels
        }
        
        var yLabelValue: Double { 
            return minYValue + yRange
        }
        
        func makeOffset(width: Double, height: Double) -> (xOffset: Double, yOffset: Double) {
            let xOffset = width / xRange // range, as smallest value may not be 0
            let yOffset = height / yRange
            
            return (xOffset, yOffset)
        }
        
        func makePoints(width: Double, height: Double, dataPoint: DataPoint) -> (x: Double, y: Double) {
            
            let xOffset = makeOffset(width: width, height: height).xOffset
            let yOffset = makeOffset(width: width, height: height).yOffset
            
            let x = xOffset * (dataPoint.time - minXValue) // make sure line starts from first value, not necessarily from 0
            var y = yOffset * (dataPoint.yValue - minYValue)
            
            y = height - y
                    
            return (x, y)
        }
        
        func makePositions(width: Double, height: Double, index: Int) -> (x: Double, y: Double) {
            let xOffset = makeOffset(width: width, height: height).xOffset
            let yOffset = makeOffset(width: width, height: height).yOffset
            
            let x = xOffset * ((dataPoints[index].time) - minXValue)
            let y = height - yOffset * (dataPoints[index].yValue - minYValue)

            return (x, y)
        }
    }
}
