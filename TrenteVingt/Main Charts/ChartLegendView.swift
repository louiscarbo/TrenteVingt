import SwiftUI

struct ChartLegendView: View {
    @State var monthBudget: MonthBudget
    
    @Binding var showRemaining : Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle()
                    .foregroundStyle(.blue)
                    .frame(height: 10)
                    .padding(.horizontal, 5)
                Text("Needs")
                Spacer()
                Circle()
                    .foregroundStyle(.green)
                    .frame(height: 10)
                    .padding(.horizontal, 5)
                Text("Savings & Debts")
                Spacer()
                Circle()
                    .foregroundStyle(.yellow)
                    .frame(height: 10)
                    .padding(.horizontal, 5)
                Text("Wants")
            }
            HStack {
                if showRemaining {
                    HStack {
                        Circle()
                            .foregroundStyle(monthBudget.remaining >= 0 ? .gray : .red)
                            .frame(height: 10)
                            .padding(.horizontal, 5)
                        Text(monthBudget.remaining >= 0 ? "Remaining" : "Overspent")
                    }
                }
            }
        }
        .font(.caption)
        .frame(height: 40)
    }
}

/*
 #Preview {
 ChartLegendView(showRemaining: .constant(true))
 }
 */
