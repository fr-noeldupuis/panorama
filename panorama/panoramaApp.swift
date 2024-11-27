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
            container = try ModelContainer(for: Transaction.self, Category.self, migrationPlan: PanoramaMigrationPlan.self)
        } catch {
            fatalError("Faile to initialize model container.")
        }
    }
    var body: some Scene {
        WindowGroup {
            MainTabView()
                
        }
        .modelContainer(container)
    }
}
