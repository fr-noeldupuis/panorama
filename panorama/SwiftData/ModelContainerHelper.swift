//
//  ModelContainerHelper.swift
//  panorama
//
//  Created by Noel Dupuis on 29/11/2024.
//
import SwiftData
import Foundation

class ModelContainerHelper {
    
    static func setupModelContainer(for versionedSchema: VersionedSchema.Type = LatestSchema.self, url: URL? = nil, rollback: Bool = false) throws -> ModelContainer {
        do {
            print("setup - versionedSchema: \(String(describing: versionedSchema))")
            
            // schema
            let schema = Schema(versionedSchema: versionedSchema)
            print("setup - schema: \(String(describing: schema))")
            
            // config
            var config: ModelConfiguration
            if let url = url {
                config = ModelConfiguration(schema: schema, url: url)
            } else {
                config = ModelConfiguration(schema: schema)
            }
            print("setup - config: \(String(describing: config))")
            
            // container
            let container = try ModelContainer(
                for: schema,
                migrationPlan: PanoramaMigrationPlan.self,
                configurations: [config]
            )
            print("setup -> \(String(describing: container))")
            
            return container
        } catch {
            print("setup - \(error)")
            throw ModelError.setup(error: error)
        }
    }

    enum ModelError: LocalizedError {
        case setup(error: Error)
    }
}
