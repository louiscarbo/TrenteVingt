//
//  EmptyButtonStyle.swift
//  Trente
//
//  Created by Louis Carbo Estaque on 17/04/2025.
//

import SwiftUI

struct EmptyButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

#Preview {
    Button("New Month") {
        // Action for creating a new month
    }
    .buttonStyle(EmptyButtonStyle())
    
    Button {
        
    } label: {
        Label("New Month", systemImage: "plus")
    }
    .buttonStyle(EmptyButtonStyle())
}
