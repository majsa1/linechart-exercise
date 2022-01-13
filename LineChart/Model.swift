//
//  Model.swift
//  LineChart
//
//  Created by Marjo Salo on 03/12/2021.
//

import Foundation
import SwiftUI

struct DataPoint: Identifiable, Comparable {
    let id = UUID()
    let xValue: Double
    let yValue: Double
    
    static func < (lhs: DataPoint, rhs: DataPoint) -> Bool { // sort by x-values
        return lhs.xValue < rhs.xValue
    }
}

struct TestData {
    static let example: [DataPoint] = [
        DataPoint(xValue: 10.4, yValue: 10),
        DataPoint(xValue: 10.5, yValue: 5),
        DataPoint(xValue: 50.0, yValue: 20),
        DataPoint(xValue: 40.0, yValue: 25),
        DataPoint(xValue: 30.0, yValue: 25),
        DataPoint(xValue: 50.5, yValue: 35),
        DataPoint(xValue: 60.0, yValue: 25),
//        DataPoint(xValue: 80.0, yValue: 45),
//        DataPoint(xValue: 90.5, yValue: 25),
//        DataPoint(xValue: 100.0, yValue: 25),
//        DataPoint(xValue: 85.0, yValue: 55),
//        DataPoint(xValue: 120.0, yValue: 25),
    ]
}
