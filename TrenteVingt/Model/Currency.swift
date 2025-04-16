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
