//
//  ActionButtonStyle.swift
//  Trente
//
//  Created by Louis Carbo Estaque on 17/04/2025.
//

import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .background(
                Capsule()
                    .fill(Color.accentColor)
                    .opacity(configuration.isPressed ? 0.5 : 1)
            )
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

#Preview {
    Button("New Month") {
        // Action for creating a new month
    }
    .buttonStyle(ActionButtonStyle())
    
    Button {
        
    } label: {
        Label("New Month", systemImage: "plus")
    }
    .buttonStyle(ActionButtonStyle())
}
