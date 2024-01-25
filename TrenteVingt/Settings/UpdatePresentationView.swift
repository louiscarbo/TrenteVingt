//
//  UpdatePresentationView.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 25/01/2024.
//

import SwiftUI

struct UpdatePresentationView: View {
    @Environment(\.colorScheme) private var colorScheme
    private var isLightMode: Bool {
        colorScheme == .light
    }
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Image("update")
                    .resizable()
                    .scaledToFit()
                VStack(alignment: .leading) {
                    Text("What's new in TrenteVingt?")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom)
                    Text("Hi, it's Louis! Here are the new features that I've worked on! Any suggestion? Feel free to contact me at: TrenteVingt@carbo-estaque.fr")
                        .padding(.bottom)
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                            .foregroundStyle(.indigo)
                        Text("**Recurring Transactions:** They're here! You can now add recurring transactions to TrenteVingt, from the same place where you're already adding your daily transactions.")
                    }
                    .padding(.bottom)
                    HStack {
                        Text("**New Widget:** Want to quickly see which transactions you added to TrenteVingt? You can now add a big widget that displays your last 3 transactions.")
                        Spacer()
                            .frame(maxWidth: 20)
                        Image(systemName: "apps.iphone")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 70)
                            .foregroundStyle(.mint)
                    }
                    .padding(.bottom)
                    HStack {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                            .foregroundStyle(.yellow)
                        Text("**Current Month:** You can now manually choose the current month by swiping it towards the right.")
                    }
                    .padding(.bottom)
                }
                .padding()
                .offset(y: -100)
                .toolbar {
                    ToolbarItem {
                        Button("OK") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Text("Test")
    .sheet(isPresented: .constant(true), content: {
        UpdatePresentationView()
    })
}
