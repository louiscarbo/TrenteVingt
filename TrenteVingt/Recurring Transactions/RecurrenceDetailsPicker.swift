import SwiftUI

struct RecurrenceDetailsPicker: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var recurrenceType: RecurrenceType
    @Binding var interval: Int
    @Binding var day: Int
    @Binding var startingDate: Date
    
    var body: some View {
        switch(recurrenceType) {
        case RecurrenceType.weekly:
            VStack {
                Text("This transaction will happen every week, on :")
                VStack(spacing: 0) {
                    ForEach(1..<8) { dayNumber in
                        HStack {
                            Button {
                                day = dayNumber
                            } label: {
                                Text(getDayOfWeek(from:dayNumber))
                                    .foregroundStyle(colorScheme == .light ? .black : .white)
                                    .padding(4)
                                Spacer()
                                if dayNumber == day {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .buttonBorderShape(.roundedRectangle(radius: 0))
                            .buttonStyle(.bordered)
                        }
                        Divider()
                    }
                }
                .onAppear {
                    day = 1
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        case RecurrenceType.monthly:
            VStack {
                Text("This transaction will happen on day ")
                TextField("", value: $day, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 70)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .onChange(of: day) {
                        checkDayNumber()
                    }
                    .keyboardType(.numberPad)
                Text("of each month.")
            }
            .onAppear {
                day = 1
            }
        case RecurrenceType.yearly:
            VStack {
                Text("This transaction will happen every year, starting on:")
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
                DatePicker("", selection: $startingDate, in: Date()..., displayedComponents: .date)
                    .datePickerStyle(.automatic)
                    .frame(width: 1)
            }
        }
    }
    
    func checkDayNumber() -> Void {
        if day > 31 {
            day = 31
        } else if day < 1 {
            day = 1
        }
    }
    
    func checkString(string: String) -> Bool {
        let digits = CharacterSet.decimalDigits
        let stringSet = CharacterSet(charactersIn: string)

        return digits.isSuperset(of: stringSet)
    }
}

#Preview {
    RecurrenceDetailsPicker(recurrenceType: .constant(.monthly), interval: .constant(1), day: .constant(1), startingDate: .constant(Date()))
}
