//
//  Item.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 08/07/2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
