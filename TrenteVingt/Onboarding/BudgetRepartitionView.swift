import SwiftUI
import SwiftData

struct BudgetRepartitionView: View {
    var newMonthBudget : MonthBudget
    
    @Environment(\.modelContext) var modelContext
    @Binding var selectedTab: Int

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("And now, your budget")
                    .font(.system(.largeTitle, design: .serif, weight: .bold))
                Text("Adjust the handles to set the allocation of your monthly disposable income. You can change this at any time.")
                    .font(.system(.callout, design: .serif))
                    .italic()
                Divider()
                Spacer()
                BudgetRepartitionSlider(monthBudget: newMonthBudget, showIndications: true, maxHeight: 400)
                Spacer()
            }
            .padding()
            Spacer()
            HStack {
                Button {
                    withAnimation {
                        selectedTab -= 1
                    }
                } label: {
                    Text("Previous")
                        .font(.system(.title3, design: .serif))
                        .foregroundStyle(.white)
                }
                .tint(.black)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                
                Spacer()
                
                Button {
                    withAnimation {
                        selectedTab += 1
                    }
                    
                    let currentMonthNumber = Calendar.current.component(.month, from: Date())
                    newMonthBudget.monthNumber = currentMonthNumber
                    
                    modelContext.insert(newMonthBudget)
                    newMonthBudget.update()
                } label: {
                    Text("Next")
                        .font(.system(.title3, design: .serif))
                        .foregroundStyle(.white)
                }
                .tint(.black)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
            }
            .padding([.leading, .trailing])
        }
    }
}

/*
#Preview {
    BudgetRepartitionView()
}*/
