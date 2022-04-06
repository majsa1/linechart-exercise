//
//  CustomDatePicker.swift
//  LineChart
//
//  Created by Marjo Salo on 05/04/2022.
//

import SwiftUI

struct CustomDatePicker: UIViewRepresentable {

    @Binding var selection: Date
    let range: ClosedRange<Date>?
    let minuteInterval: Int
    let displayedComponents: DatePickerComponents

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<CustomDatePicker>) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged), for: .valueChanged)
        return picker
    }

    func updateUIView(_ picker: UIDatePicker, context: UIViewRepresentableContext<CustomDatePicker>) {
        picker.date = selection
        picker.minuteInterval = minuteInterval
        picker.minimumDate = range?.lowerBound
        picker.maximumDate = range?.upperBound

        switch displayedComponents {
        case .hourAndMinute:
            picker.datePickerMode = .time
        case .date:
            picker.datePickerMode = .date
        case [.hourAndMinute, .date]:
            picker.datePickerMode = .dateAndTime
        default:
            break
        }
    }

    class Coordinator {
        let datePicker: CustomDatePicker
        init(_ datePicker: CustomDatePicker) {
            self.datePicker = datePicker
        }

        @objc func dateChanged(_ sender: UIDatePicker) {
            datePicker.selection = sender.date
        }
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    
    static var previews: some View {
        let time: Date = Date()

        CustomDatePicker(selection: .constant(time), range: nil, minuteInterval: 10, displayedComponents: .hourAndMinute)
    }
}
