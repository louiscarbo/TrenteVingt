//
//  GraphCardView.swift
//  Trente
//
//  Created by Louis Carbo Estaque on 17/04/2025.
//

import SwiftUI

struct GraphCardView: View {
    @State var month: Month
    @State var category: BudgetCategory
    
    var body: some View {
        GroupBox(label:
            Label(
                category.shortName,
                systemImage: month.overSpending(in: category) ? "exclamationmark.triangle.fill" : month.currency.sfSymbolGaugeName
            )
            .foregroundColor(month.overSpending(in: category) ? .red : category.color)
        ) {
            CategoryRemainingGaugeView(month: month, category: category, size: 100)
                .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .aspectRatio(1, contentMode: .fit)
        .groupBoxStyle(.automatic)
    }
}

// MARK: CategoryRemainingGaugeView
struct CategoryRemainingGaugeView: View {
    @State var month: Month
    @State var category: BudgetCategory
    
    var size: CGFloat = 100
    
    var gaugeValue: Double {
        if month.overSpending(in: category) {
            month.overSpentAmount(for: category).truncatingRemainder(dividingBy: month.incomeAmount(for: category))

        } else {
            month.spentAmount(for: category)
        }
    }
    
    var body: some View {
        VStack {
            Gauge(value: gaugeValue, in: 0...month.incomeAmount(for: category)) {
                Text(category.name)
            } currentValueLabel: {
                Text("\(month.spentAmount(for: category), format: .currency(code: month.currency.isoCode).precision(.fractionLength(0)))")
                    .foregroundStyle(month.spentAmount(for: category) > month.incomeAmount(for: category) ? .red : .primary)
            } minimumValueLabel: {
                Text("")
            } maximumValueLabel: {
                Text("\(month.incomeAmount(for: category), format: .currency(code: month.currency.isoCode).precision(.fractionLength(0)))")
            }
            .gaugeStyle(CategoryRemainingGaugeSytyle(color: month.overSpending(in: category) ? .red : category.color, diameter: size))
        }
    }
}

// MARK: SpeedometerGaugeStyle
struct CategoryRemainingGaugeSytyle: GaugeStyle {
    var color: Color
    var diameter: CGFloat = 100

    var gradient: Gradient {
        Gradient(colors: [adjustHue(of: color, by: -20), color])
    }

    func makeBody(configuration: Configuration) -> some View {
        var strokeWidth: CGFloat {
            diameter / 6
        }
        
        ZStack {
                Circle()
                    .trim(from: 0, to: 0.75 * configuration.value)
                    .stroke(
                        gradient,
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(135))
                
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(
                        gradient.opacity(0.3),
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(135))
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 0.6*strokeWidth.rounded(), height: 0.6*strokeWidth.rounded())
                    .offset(y: -1 * diameter / 2)
                    .rotationEffect(.degrees(225 + 270 * configuration.value))
                
            VStack(spacing: 0) {
                configuration.currentValueLabel
                    .font(.headline)
                Divider()
                    .frame(width: diameter / 2, height: 1)
                    .padding(2)
                configuration.maximumValueLabel
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: diameter, height: diameter)
    }
    
    
    func adjustHue(of color: Color, by degrees: Double) -> Color {
        let uiColor = UIColor(color)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        hue = CGFloat((Double(hue) + degrees / 360).truncatingRemainder(dividingBy: 1))
        if hue < 0 { hue += 1 }

        return Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(brightness) - 0.1, opacity: Double(alpha))
    }
}

#Preview {
    let month = Month.month1
    
    Grid {
        GridRow {
            GraphCardView(month: month, category: .needs)
                .modelContainer(SampleDataProvider.shared.modelContainer)
            
            GraphCardView(month: month, category: .wants)
                .modelContainer(SampleDataProvider.shared.modelContainer)
        }
        GridRow {
            GraphCardView(month: month, category: .savingsAndDebts)
                .modelContainer(SampleDataProvider.shared.modelContainer)
        }
    }
}
