//
//  PanoramaMigrationPlan.swift
//  panorama
//
//  Created by Noel Dupuis on 27/11/2024.
//
import SwiftData

enum PanoramaMigrationPlan: SchemaMigrationPlan {
    
    static var schemas: [any VersionedSchema.Type] {
        [ModelSchemaV0_3_2.self, ModelSchemaV0_4_0.self]
    }
    
    static var stages: [MigrationStage] {
        [migratev0_3_2tov0_4_0]
    }
    
    static let migratev0_3_2tov0_4_0 = MigrationStage.custom(
        fromVersion: ModelSchemaV0_3_2.self,
        toVersion: ModelSchemaV0_4_0.self,
        willMigrate: nil,
        didMigrate: { context in
            let transactions = (try? context.fetch(FetchDescriptor<ModelSchemaV0_4_0.Transaction>())) ?? []
            
            for transaction in transactions {
                transaction.recurringFrequency = nil
                transaction.recurringType = .once
            }
            
            try? context.save()
    })
        
}
