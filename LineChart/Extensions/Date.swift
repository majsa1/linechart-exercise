//
//  Date.swift
//  LineChart
//
//  Created by Marjo Salo on 04/04/2022.
//

import Foundation

extension Date {
    static func nowToDouble() -> Double {
        return (Date.now.timeIntervalSince1970 / 600).rounded(.toNearestOrEven) * 600 // rounded to nearest 10 minutes, check
    }
}
