//
//  PanoramaMigrationPlan.swift
//  panorama
//
//  Created by Noel Dupuis on 27/11/2024.
//
import SwiftData

enum PanoramaMigrationPlan: SchemaMigrationPlan {
    
    static var schemas: [any VersionedSchema.Type] {
        [ModelSchemaV0_3_2.self, ModelSchemaV0_4_0.self, ModelSchemaV0_4_1.self]
    }
    
    static var stages: [MigrationStage] {
        [migratev0_3_2tov0_4_0, migratev0_4_0tov0_4_1]
    }
    
    static let migratev0_3_2tov0_4_0 = MigrationStage.custom(
        
        // Steps to do
        // Before:
        //     - Nothing
        // After:
        //     - Set recurringType value to .once for all elements
        //     - Set reccuringFrequency value to nil for all elements
        
        fromVersion: ModelSchemaV0_3_2.self,
        toVersion: ModelSchemaV0_4_0.self,
        willMigrate: { context in
            
        },
        didMigrate: { context in
            let transactions = try? context.fetch(FetchDescriptor<ModelSchemaV0_4_0.Transaction>())
                                
            transactions?.forEach({ transaction in
                transaction.recurringType = .once
                transaction.recurringFrequency = nil
            })
            
            try? context.save()
        }
    )
    
    static let migratev0_4_0tov0_4_1 = MigrationStage.lightweight(
        fromVersion: ModelSchemaV0_4_0.self,
        toVersion: ModelSchemaV0_4_1.self
    )
        
}
