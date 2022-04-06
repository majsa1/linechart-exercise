//
//  String.swift
//  LineChart
//
//  Created by Marjo Salo on 04/04/2022.
//

import Foundation

extension Double {
    func toDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: Date(timeIntervalSince1970: self)) 
    }
}
