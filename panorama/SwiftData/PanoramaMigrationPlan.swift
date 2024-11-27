//
//  PanoramaMigrationPlan.swift
//  panorama
//
//  Created by Noel Dupuis on 27/11/2024.
//
import SwiftData

enum PanoramaMigrationPlan: SchemaMigrationPlan {
    
    static var schemas: [any VersionedSchema.Type] {
        [ModelSchemaV0_3_2.self]
    }
    
    static var stages: [MigrationStage] {
        []
    }
        
}
