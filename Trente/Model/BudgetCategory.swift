//
//  BudgetCategory.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 16/04/2025.
//

import Foundation
import SwiftUI

enum BudgetCategory: String, Codable, CaseIterable {
    case needs
    case wants
    case savingsAndDebts
    
    var name: String {
        switch self {
        case .needs:
            return String(localized: "Needs")
        case .wants:
            return String(localized: "Wants")
        case .savingsAndDebts:
            return String(localized: "Savings and Debts")
        }
    }
    
    var color: Color {
        switch self {
        case .needs:
            return Color.blue
        case .wants:
            return Color.yellow
        case .savingsAndDebts:
            return Color.green
        }
    }
}
