//
//  ContentView.swift
//  LineChart
//
//  Created by Marjo Salo on 03/12/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var x = Date(timeIntervalSinceReferenceDate: (Date.now.timeIntervalSinceReferenceDate / 600.0).rounded(.toNearestOrEven) * 600.0)
    @State private var y = 7.5
    @State private var dataPoints = [DataPoint]()
    
    var body: some View {
        VStack(spacing: 20) {
            ChartView(viewModel: ChartView.ViewModel(dataPoints: dataPoints), pointSize: 12, pointColor: .yellow, lineWidth: 2, lineColor: .white, textColor: .white, backgroundColor: .teal)
                .frame(width: 300, height: 200)
            
            VStack(alignment: .trailing, spacing: 20) {
                HStack {
                    Text("Time:")
                    Spacer()
                    CustomDatePicker(selection: $x, range: thirtyHours, minuteInterval: 10, displayedComponents: [.date, .hourAndMinute])
                }
                HStack {
                    Text("pH:")
                    Text("\(y, specifier: "%.1f")")
                    Spacer()
                    Stepper("y", value: $y, in: 4.0...9.0, step: 0.1)
                }
                
                Button(action: {
                    let entry = DataPoint(xValue: x, yValue: y)
                    dataPoints.append(entry)
                }) {
                    Text("Add")
                    Image(systemName: "plus")
                }
            }
            .frame(width: 300, height: 150)
            .labelsHidden()
            
            List {
                ForEach(dataPoints.sorted(), id: \.id) { data in
                    HStack {
                        Text("Time: \(data.formattedTime)")
                        Spacer()
                        Text("pH: \(data.yValue, specifier: "%.2f")")
                    }
                }
                .onDelete { offsets in
                    delete(at: offsets) 
                }
            }
        }
    }
    
    var thirtyHours: ClosedRange<Date> {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date()) // -> change to selected date
        let end = Calendar.current.date(byAdding: .hour, value: 30, to: start) ?? Date()
        return start...end
    }
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            // search correct index of sorted list:
            if let index = dataPoints.firstIndex(of: dataPoints.sorted()[offset]) {
                dataPoints.remove(at: index)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
