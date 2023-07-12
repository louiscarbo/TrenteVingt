import SwiftUI

struct VerticalSlider: View {
    @State var heightSlider1: Int = 200
    @State var heightSlider2: Int = 320
    @State var maxHeight: CGFloat = 400
    @State var cornerRadius: CGFloat = 20
    
    var monthBudget: MonthBudget
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundStyle(.blue)
                    .frame(maxWidth: 90, maxHeight: geometry.size.height)
                
                VStack(spacing: 0) {
                    Rectangle()
                        .foregroundStyle(.green)
                        .frame(height: CGFloat(heightSlider2))
                    Spacer()
                }
                .frame(maxWidth: 90, maxHeight: geometry.size.height)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: 100, height: 10)
                    .offset(y: CGFloat(heightSlider2))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.location.y <= geometry.size.height && value.location.y >= 0 && value.location.y >= CGFloat(heightSlider1){
                                    heightSlider2 = Int(value.location.y)
                                    
                                    monthBudget.needsBudgetRepartition = Int(heightSlider1*100/Int(geometry.size.height))
                                    monthBudget.wantsBudgetRepartition = Int((heightSlider2 - heightSlider1)*100/Int(geometry.size.height))
                                    monthBudget.savingsDebtsBudgetRepartition = 100 - monthBudget.needsBudgetRepartition - monthBudget.wantsBudgetRepartition
                                }
                            }
                    )
                
                VStack(spacing: 0) {
                    Rectangle()
                        .foregroundStyle(.gray)
                        .frame(height: CGFloat(heightSlider1))
                    Spacer()
                }
                .frame(maxWidth: 90, maxHeight: geometry.size.height)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: 100, height: 10)
                    .offset(y: CGFloat(heightSlider1))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.location.y <= maxHeight && value.location.y >= 0 && value.location.y <= CGFloat(heightSlider2) {
                                    heightSlider1 = Int(value.location.y)
                                    
                                    monthBudget.needsBudgetRepartition = Int(heightSlider1*100/Int(geometry.size.height))
                                    monthBudget.wantsBudgetRepartition = Int((heightSlider2 - heightSlider1)*100/Int(geometry.size.height))
                                    monthBudget.savingsDebtsBudgetRepartition = 100 - monthBudget.needsBudgetRepartition - monthBudget.wantsBudgetRepartition
                                }
                            }
                    )
            }
        }
        .frame(width: 100)
    }
}
