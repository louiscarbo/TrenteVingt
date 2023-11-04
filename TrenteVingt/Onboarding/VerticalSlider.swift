import SwiftUI

struct VerticalSlider: View {
    @State var heightSlider1: Double = 200
    @State var heightSlider2: Double = 320
    @State var maxHeight: CGFloat
    @State var cornerRadius: CGFloat = 20
    
    var monthBudget: MonthBudget
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundStyle(.green)
                    .frame(maxWidth: 90, maxHeight: geometry.size.height)
                
                VStack(spacing: 0) {
                    Rectangle()
                        .foregroundStyle(.yellow)
                        .frame(height: CGFloat(heightSlider2))
                    Spacer()
                }
                .frame(maxWidth: 90, maxHeight: geometry.size.height)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: 100, height: 10)
                    .offset(y: CGFloat(heightSlider2)-5)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.location.y <= geometry.size.height && value.location.y >= 0 && value.location.y >= CGFloat(heightSlider1){
                                    heightSlider2 = Double(value.location.y)
                                    
                                    monthBudget.needsBudgetRepartition = Double(heightSlider1*100/Double(geometry.size.height))
                                    monthBudget.wantsBudgetRepartition = Double((heightSlider2 - heightSlider1)*100/Double(geometry.size.height))
                                    monthBudget.savingsDebtsBudgetRepartition = 100 - monthBudget.needsBudgetRepartition - monthBudget.wantsBudgetRepartition
                                }
                            }
                    )
                
                VStack(spacing: 0) {
                    Rectangle()
                        .foregroundStyle(.blue)
                        .frame(height: CGFloat(heightSlider1))
                    Spacer()
                }
                .frame(maxWidth: 90, maxHeight: geometry.size.height)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: 100, height: 10)
                    .offset(y: CGFloat(heightSlider1)-5)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.location.y <= maxHeight && value.location.y >= 0 && value.location.y <= CGFloat(heightSlider2) {
                                    heightSlider1 = Double(value.location.y)
                                    
                                    monthBudget.needsBudgetRepartition = Double(heightSlider1*100/Double(geometry.size.height))
                                    monthBudget.wantsBudgetRepartition = Double((heightSlider2 - heightSlider1)*100/Double(geometry.size.height))
                                    monthBudget.savingsDebtsBudgetRepartition = 100 - monthBudget.needsBudgetRepartition - monthBudget.wantsBudgetRepartition
                                }
                            }
                    )
            }
            .frame(height: maxHeight)
            .onAppear {
                updateHeights()
            }
            .onChange(of: monthBudget.needsBudgetRepartition) {
                updateHeights()
            }
            .onChange(of: monthBudget.wantsBudgetRepartition) {
                updateHeights()
            }
            .onChange(of: monthBudget.savingsDebtsBudgetRepartition) {
                updateHeights()
            }
        }
        .frame(width: 100)
    }
    
    func updateHeights() {
        heightSlider1 = monthBudget.needsPercentage * 400
        heightSlider2 = (monthBudget.wantsPercentage + monthBudget.needsPercentage) * 400
    }
}

