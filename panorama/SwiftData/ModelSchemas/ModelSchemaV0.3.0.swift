//
//  File.swift
//  panorama
//
//  Created by Noel Dupuis on 18/11/2024.
//

import SwiftData
import SwiftUI

enum ModelSchemaV0_3_0: VersionedSchema {
    // In this model, there is only the transaction object. This object only has the amount field.
    
    static var versionIdentifier = Schema.Version(0, 3, 0)
    
    static var models: [any PersistentModel.Type] {
        
        [
            Transaction.self
        ]
    }
    
    @Model
    class Transaction: Identifiable {
        
        var id: UUID
        var amount: Double
        var date: Date
        var transactionDescription: String
        @Relationship(deleteRule: .nullify, inverse: \Category.transactions)
        var category: Category?
        
        @Relationship(deleteRule: .nullify, inverse: \Account.transactions)
        var account: Account?
        
        init(amount: Double = 0, date: Date, description: String = "", category: Category?, account: Account?) {
            self.id = .init()
            self.amount = amount
            self.date = date
            self.transactionDescription = description
            self.category = category
            self.account = account
        }
        
    }
    
    @Model
    class Category: Identifiable {
        
        var id: UUID
        var name: String
        var iconName: String
        var type: String
        var transactions: [Transaction]
        
        init(name: String, iconName: String, type: String, transactions: [Transaction]) {
            self.id = .init()
            self.name = name
            self.iconName = iconName
            self.type = type
            self.transactions = transactions
        }
    }
    
    @Model
    class Account: Identifiable {
        
        var id: UUID
        var name: String
        var iconName: String
        var transactions: [Transaction]
        
        init(name: String, iconName: String, transactions: [Transaction]) {
            self.id = .init()
            self.name = name
            self.iconName = iconName
            self.transactions = transactions
        }
    }
}

enum ModelSchemaV0_3_1: VersionedSchema {
    // In this model, there is only the transaction object. This object only has the amount field.
    
    static var versionIdentifier = Schema.Version(0, 3, 1)
    
    static var models: [any PersistentModel.Type] {
        
        [
            Transaction.self
        ]
    }
    
    @Model
    class Transaction: Identifiable {
        
        var id: UUID
        var amount: Double
        var date: Date
        var transactionDescription: String
        @Relationship(deleteRule: .nullify, inverse: \Category.transactions)
        var category: Category?
        
        @Relationship(deleteRule: .nullify, inverse: \Account.transactions)
        var account: Account?
        
        init(amount: Double = 0, date: Date, description: String = "", category: Category?, account: Account?) {
            self.id = .init()
            self.amount = amount
            self.date = date
            self.transactionDescription = description
            self.category = category
            self.account = account
        }
        
    }
    
    @Model
    class Category: Identifiable {
        
        var id: UUID
        var name: String
        var iconName: String
        var type: String
        var categoryType: CategoryType
        var transactions: [Transaction]
        
        init(name: String, iconName: String, type: String, categoryType: CategoryType = .income, transactions: [Transaction]) {
            self.id = .init()
            self.name = name
            self.iconName = iconName
            self.type = type
            self.categoryType = categoryType
            self.transactions = transactions
        }
    }
    
    enum CategoryType: String, Codable {
        case income = "Income"
        case expense = "Expense"
    }
    
    @Model
    class Account: Identifiable {
        
        var id: UUID
        var name: String
        var iconName: String
        var transactions: [Transaction]
        
        init(name: String, iconName: String, transactions: [Transaction]) {
            self.id = .init()
            self.name = name
            self.iconName = iconName
            self.transactions = transactions
        }
    }
}

enum ModelSchemaV0_3_2: VersionedSchema {
    // In this model, there is only the transaction object. This object only has the amount field.
    
    static var versionIdentifier = Schema.Version(0, 3, 2)
    
    static var models: [any PersistentModel.Type] {
        
        [
            Transaction.self
        ]
    }
    
    @Model
    class Transaction: Identifiable {
        
        var id: UUID
        var amount: Double
        var date: Date
        var transactionDescription: String
        @Relationship(deleteRule: .nullify, inverse: \Category.transactions)
        var category: Category?
        
        @Relationship(deleteRule: .nullify, inverse: \Account.transactions)
        var account: Account?
        
        init(amount: Double = 0, date: Date, description: String = "", category: Category?, account: Account?) {
            self.id = .init()
            self.amount = amount
            self.date = date
            self.transactionDescription = description
            self.category = category
            self.account = account
        }
        
    }
    
    @Model
    class Category: Identifiable {
        
        var id: UUID
        var name: String
        var iconName: String
        
        @Attribute(originalName: "categoryType") var type: CategoryType
        var transactions: [Transaction]
        
        init(name: String, iconName: String, type: CategoryType, transactions: [Transaction]) {
            self.id = .init()
            self.name = name
            self.iconName = iconName
            self.type = type
            self.transactions = transactions
        }
    }
    
    enum CategoryType: String, Codable {
        case income = "Income"
        case expense = "Expense"
    }
    
    @Model
    class Account: Identifiable {
        
        var id: UUID
        var name: String
        var iconName: String
        var transactions: [Transaction]
        
        init(name: String, iconName: String, transactions: [Transaction]) {
            self.id = .init()
            self.name = name
            self.iconName = iconName
            self.transactions = transactions
        }
    }
}

