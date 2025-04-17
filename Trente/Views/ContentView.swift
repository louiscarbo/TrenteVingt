//
//  ContentView.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 16/04/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MonthListView()
            .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
