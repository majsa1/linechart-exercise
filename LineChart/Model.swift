//
//  Model.swift
//  LineChart
//
//  Created by Marjo Salo on 03/12/2021.
//

import SwiftUI

struct DataPoint: Identifiable, Comparable {
    let id = UUID()
    let xValue: Date
    let yValue: Double
    
    static func < (lhs: DataPoint, rhs: DataPoint) -> Bool { // sorts by x-values 
        return lhs.xValue < rhs.xValue
    }
    
    var time: Double {
        return xValue.timeIntervalSince1970
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: xValue)
    }
    
    static let pHexample = [
        DataPoint(xValue: Date.now, yValue: 8.0),
        DataPoint(xValue: Date.now.addingTimeInterval(2000), yValue: 7.5),
        DataPoint(xValue: Date.now.addingTimeInterval(6000), yValue: 7.25),
        DataPoint(xValue: Date.now.addingTimeInterval(8000), yValue: 6.9)
    ]
    
    static let tdsExample = [
        DataPoint(xValue: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), yValue: 620),
        DataPoint(xValue: Calendar.current.date(byAdding: .hour, value: 12, to: Date()) ?? Date(), yValue: 520),
        DataPoint(xValue: Date(), yValue: 450),
        DataPoint(xValue: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(), yValue: 500),
    ]
}

