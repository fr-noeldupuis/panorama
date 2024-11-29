//
//  PanoramaMigrationPlan+v0.3.2tov0.4.0.swift
//  panorama
//
//  Created by Noel Dupuis on 29/11/2024.
//

import XCTest
import SwiftData
@testable import panorama

@MainActor
final class PanoramaMigrationPlan_v0_3_2tov0_4_0Tests: XCTestCase {
    
    typealias OriginalModel = panorama.ModelSchemaV0_3_2
    typealias UpdatedModel = panorama.ModelSchemaV0_4_0
    
    var url: URL!
    var container: ModelContainer!
    var modelContext: ModelContext!
    
    override func setUp() {
        self.url = FileManager.default.temporaryDirectory.appending(component: "default.store")
        print(url!.path(percentEncoded: false))
    }
    
    override func tearDownWithError() throws {
        container = nil
        
        try FileManager.default.removeItem(at: self.url)
        try? FileManager.default.removeItem(at: self.url.deletingPathExtension().appendingPathExtension("store-shm"))
        try? FileManager.default.removeItem(at: self.url.deletingPathExtension().appendingPathExtension("store-wal"))
    }
    
    
    func testExampleTest() throws {
        container = try ModelContainerHelper.setupModelContainer(for: OriginalModel.self, url: self.url)
        modelContext = ModelContext(container)
        
        let testCategory = OriginalModel.Category(name: "Test Category", iconName: "questionmark", type: .income, transactions: [])
        let testAccount = OriginalModel.Account(name: "Test Account", iconName: "questionmark", transactions: [])
        
        modelContext.insert(testCategory)
        modelContext.insert(testAccount)
        
        let transaction = OriginalModel.Transaction(
            amount: 100,
            date: Calendar.current.startOfDay(for: .now),
            description: "Test Description",
            category: testCategory,
            account: testAccount
        )
        
        modelContext.insert(transaction)
        
        try modelContext.save()
        
        let transactionsOriginal = try modelContext.fetch(FetchDescriptor<OriginalModel.Transaction>())

        container = try ModelContainerHelper.setupModelContainer(for: UpdatedModel.self, url: self.url)
        modelContext = ModelContext(container)
        
        let transactionUpdated = try modelContext.fetch(FetchDescriptor<UpdatedModel.Transaction>())
        
        XCTAssertEqual(transactionUpdated.count, transactionsOriginal.count)
        XCTAssertTrue(transactionUpdated.allSatisfy {$0.recurringType == .once})
        XCTAssertTrue(transactionUpdated.allSatisfy {$0.recurringFrequency == nil})
    }
    
}
