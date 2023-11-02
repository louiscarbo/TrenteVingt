import SwiftUI

struct MonthRowView: View {
    @State var monthBudget: MonthBudget
    
    var body: some View {
        HStack {
            Image(systemName: monthBudget.remaining >= 0 ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                .foregroundStyle(monthBudget.remaining >= 0 ? .green : .red)
                .frame(height: 10)
            VStack(alignment: .leading) {
                Text(monthBudget.monthDesignation)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Text(monthBudget.remaining >= 0 ? "Within Budget" : "Overspent")
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
