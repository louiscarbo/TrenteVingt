//
//  TrenteVingtApp.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 08/07/2023.
//

import SwiftUI
import SwiftData

@main
struct TrenteVingtApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
