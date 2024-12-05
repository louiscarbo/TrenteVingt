//
//  RecurrenceTypePicker.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 24/01/2024.
//

import SwiftUI

struct RecurrenceTypePicker: View {
    @Binding var selectedRecurrenceType : RecurrenceType
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("RECURRENCE TYPE :")
                .font(.caption)
                .padding(.leading)
                .foregroundStyle(.gray)
            VStack(spacing: 0) {
                ForEach(RecurrenceType.allCases) { recurrenceType in
                    let isSelected = recurrenceType == selectedRecurrenceType
                    HStack {
                        Button {
                            selectedRecurrenceType = recurrenceType
                        } label: {
                            Text(recurrenceType.designation)
                                .foregroundStyle(colorScheme == .light ? .black : .white)
                                .padding(4)
                            Spacer()
                            if isSelected {
                                Image(systemName: "checkmark")
                            }
                        }
                        .buttonBorderShape(.roundedRectangle(radius: 0))
                        .buttonStyle(.bordered)
                    }
                    Divider()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

//#Preview {
//    RecurrenceTypePicker()
//}
