//
//  SampleData.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 16/04/2025.
//

import Foundation
import SwiftData

@MainActor
class SampleDataProvider {
    static let shared = SampleDataProvider()
    
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    private init() {
        let schema = Schema([
            Month.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            insertSampleData()
            
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    private func insertSampleData() {
        for month in Month.sampleData {
            context.insert(month)
        }
        
        for transaction in TransactionGroup.sampleData(month1: Month.month1, month2: Month.month2) {
            context.insert(transaction)
        }
    }
}
