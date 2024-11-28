//
//  File.swift
//  panorama
//
//  Created by Noel Dupuis on 18/11/2024.
//

import SwiftData
import SwiftUI

enum ModelSchemaV0_4_0: VersionedSchema {
    
    static var versionIdentifier = Schema.Version(0, 4, 0)
    
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
        
        var recurringType: RecurringType
        var recurringFrequency: Int?
        
        init(amount: Double = 0, date: Date, description: String = "", category: Category?, account: Account?, recurringType: RecurringType = .once, recurringFrequency: Int? = nil) {
            self.id = .init()
            self.amount = amount
            self.date = date
            self.transactionDescription = description
            self.category = category
            self.account = account
            self.recurringType = recurringType
            self.recurringFrequency = recurringFrequency
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
    
    enum CategoryType: String, Codable {
        case income = "Income"
        case expense = "Expense"
    }
    
    enum RecurringType: String, Codable, CaseIterable, Identifiable {
        case once = "Once"
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
        case yearly = "Yearly"
        
        var id: Self {self}
    }
}

