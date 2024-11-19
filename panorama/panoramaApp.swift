//
//  panoramaApp.swift
//  panorama
//
//  Created by Noel Dupuis on 18/11/2024.
//

import SwiftUI
import SwiftData

@main
struct panoramaApp: App {
    
    let container : ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Transaction.self, migrationPlan: nil)
        } catch {
            fatalError("Faile to initialize model container.")
        }
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TransactionListView()
            }
                
        }
        .modelContainer(container)
    }
}
