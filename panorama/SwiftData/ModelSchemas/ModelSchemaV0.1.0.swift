//
//  File.swift
//  panorama
//
//  Created by Noel Dupuis on 18/11/2024.
//

import SwiftData
import SwiftUI

enum ModelSchemaV0_1_0: VersionedSchema {
    // In this model, there is only the transaction object. This object only has the amount field.
    
    static var versionIdentifier = Schema.Version(0, 1, 0)
    
    static var models: [any PersistentModel.Type] {
        
        [
            Transaction.self
        ]
    }
    
    @Model
    class Transaction {
        var amount: Double
        
        init(amount: Double = 0) {
            self.amount = amount
        }
        
    }
}
