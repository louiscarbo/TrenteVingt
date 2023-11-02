import SwiftUI
import SwiftData
import Charts

struct ChartData: Identifiable {
    let id = UUID()
    var value: Double
    var secondValue: Double?
    let color: AnyGradient
    let designation: String
    var type = "Regular Spending"
}

struct ChartView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Bindable var monthBudget: MonthBudget
    
    @Binding var showRemaining : Bool
    
    @State var showAsPieChart = true
    @State var inWidget = false
    @State var presentsSpentMoney = true
        
    var body: some View {
        VStack {
            ChartTypePicker(showAsPieChart: $showAsPieChart, showRemaining: $showRemaining)
            if showAsPieChart {
                ZStack(alignment: .bottom) {
                    PieChartView(showRemaining: $showRemaining, monthBudget: monthBudget)
                        .frame(height: 300)
                        .transition(.move(edge: .trailing))
                }
            } else {
                BarChartView(monthBudget: monthBudget)
                    .frame(height: 300)
            }
        }
    }
}

struct ChartTypePicker: View {
    @Binding var showAsPieChart: Bool
    @Binding var showRemaining: Bool
    
    @State private var lastShowRemainingValue = false
    @State private var pickerShowAsPieChart = true
    
    var body: some View {
        Picker("Chart type", selection: $pickerShowAsPieChart) {
            Image(systemName: "chart.pie.fill").tag(true)
                .font(.title3)
            Image(systemName: "chart.bar.fill").tag(false)
                .font(.title3)
        }
        .pickerStyle(.segmented)
        .buttonBorderShape(.capsule)
        .frame(width: 100)
        .onChange(of: pickerShowAsPieChart) {
            withAnimation {
                showAsPieChart = pickerShowAsPieChart
                if !showAsPieChart {
                    lastShowRemainingValue = showRemaining
                    showRemaining = false
                } else {
                    showRemaining = lastShowRemainingValue
                }
            }
        }
        .onAppear {
            lastShowRemainingValue = showRemaining
            pickerShowAsPieChart = showAsPieChart
        }
    }
}

/*
 #Preview {
 ChartView()
 }
*/
