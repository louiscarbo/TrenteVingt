import SwiftUI

struct MonthRowView: View {
    @State var monthBudget: MonthBudget
    @State var remaining: Double
    @State var monthDesignation: String
    
    var body: some View {
        HStack {
            Image(systemName: remaining >= 0 ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                .foregroundStyle(remaining >= 0 ? .green : .red)
                .frame(height: 10)
            VStack(alignment: .leading) {
                Text(monthDesignation)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Text(remaining >= 0 ? "Within Budget" : "Overspent")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            PieChartView(showRemaining: .constant(true), monthBudget: monthBudget, showText: false)
                .frame(width: 50, height: 50)
        }
    }
}

/*
#Preview {
    MonthRowView()
}
*/
