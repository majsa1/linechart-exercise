//
//  ContentView.swift
//  LineChart
//
//  Created by Marjo Salo on 03/12/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ChartView(dataPoints: TestData.example, pointSize: 15, pointColor: .yellow, lineWidth: 2, lineColor: .white, textColor: .white, backgroundColor: .teal)
                .frame(width: 300, height: 200)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
