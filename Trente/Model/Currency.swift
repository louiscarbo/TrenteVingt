//
//  Currency.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 16/04/2025.
//

import Foundation

struct Currency: Codable {
    let isoCode: String // ISO currency code ("EUR", "USD")
    var symbol: String
    var sfSymbolName: String?
    var localizedName: String
}

extension Currency {
    var sfSymbolGaugeName: String {
        return sfSymbolName.map { "\($0).gauge.chart.lefthalf.righthalf" } ?? ""
    }
}

struct Currencies {
    static let availableCurrencies: [Currency] = [
        Currency(isoCode: "USD", symbol: "$", sfSymbolName: "dollarsign", localizedName: "US Dollar"),
        Currency(isoCode: "EUR", symbol: "€", sfSymbolName: "eurosign", localizedName: "Euro"),
        Currency(isoCode: "JPY", symbol: "¥", sfSymbolName: "yensign", localizedName: "Japanese Yen")
    ]
    
    static func currency(for isoCode: String) -> Currency? {
        return availableCurrencies.first { $0.isoCode == isoCode }
    }
}
