//
//  EditCategoryView+ViewModelTest.swift
//  panoramaTests
//
//  Created by Noel Dupuis on 28/11/2024.
//

import XCTest
import SwiftData
@testable import panorama

@MainActor
final class EditCategoryViewModelTest: XCTestCase {
    
    typealias ViewModel = EditTransactionView.ViewModel

    var container: ModelContainer!
    var modelContext: ModelContext {
        container.mainContext
    }
    var testAccount: Account!
    var testCategory: ModelSchemaV0_4_0.Category!
    var viewModel: EditTransactionView.ViewModel!

    override func setUp() {
        super.setUp()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: ModelSchemaV0_4_0.Transaction.self, configurations: config)

        // Add mock data
        testAccount = Account(name: "Test Account", iconName: "questionmark", transactions: [])
        modelContext.insert(testAccount)
        
        testCategory = Category(name: "Test Category", iconName: "questionmark", type: .income, transactions: [])
        modelContext.insert(testCategory)

        try? modelContext.save()
    }

    override func tearDown() {
        container = nil
        testAccount = nil
        testCategory = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testViewModelInitializationWithTransaction() {
        let existingTransaction = Transaction(
            amount: 100.0,
            date: Date(),
            description: "Test Transaction",
            category: testCategory,
            account: testAccount
        )
        modelContext.insert(existingTransaction)

        viewModel = ViewModel(modelContext: modelContext, editedTransaction: existingTransaction)

        XCTAssertEqual(viewModel.amountString, "100")
        XCTAssertEqual(viewModel.date, existingTransaction.date)
        XCTAssertEqual(viewModel.description, "Test Transaction")
        XCTAssertEqual(viewModel.category, testCategory)
        XCTAssertEqual(viewModel.account, testAccount)
        XCTAssertEqual(viewModel.recurringType, .once)
        XCTAssertNil(viewModel.recurringFrequency)
    }
    
    func testViewModelInitializationWithoutTransaction() {
        viewModel = ViewModel(modelContext: modelContext, editedTransaction: nil)

        XCTAssertEqual(viewModel.amountString, "")
        XCTAssertEqual(viewModel.date, Calendar.current.startOfDay(for: .now))
        XCTAssertEqual(viewModel.description, "")
        XCTAssertNil(viewModel.category)
        XCTAssertNil(viewModel.account)
        XCTAssertEqual(viewModel.recurringType, .once)
        XCTAssertNil(viewModel.recurringFrequency)
    }
    
    func testAmountValidation() {
        viewModel = ViewModel(modelContext: modelContext, editedTransaction: nil)

        viewModel.amountString = "100.0"
        XCTAssertTrue(viewModel.amountValid)

        viewModel.amountString = "invalid"
        XCTAssertFalse(viewModel.amountValid)

        viewModel.amountString = ""
        XCTAssertFalse(viewModel.amountValid)
    }


    func testSaveNewTransaction() {
        viewModel = ViewModel(modelContext: modelContext, editedTransaction: nil)
        viewModel.amountString = "150.0"
        viewModel.date = Date()
        viewModel.description = "New Test Transaction"
        viewModel.category = testCategory
        viewModel.account = testAccount
        viewModel.recurringType = .once

        viewModel.saveTransaction()

        let fetchDescriptor = FetchDescriptor<Transaction>()
        let transactions = try! modelContext.fetch(fetchDescriptor)
        XCTAssertEqual(transactions.count, 1)

        let savedTransaction = transactions.first!
        XCTAssertEqual(savedTransaction.amount, 150.0)
        XCTAssertEqual(savedTransaction.transactionDescription, "New Test Transaction")
        XCTAssertEqual(savedTransaction.category, testCategory)
        XCTAssertEqual(savedTransaction.account, testAccount)
        XCTAssertEqual(savedTransaction.recurringType, .once)
        XCTAssertNil(savedTransaction.recurringFrequency)
    }
    
    func testUpdateExistingTransaction() {
        let existingTransaction = Transaction(
            amount: 100.0,
            date: Date(),
            description: "Old Transaction",
            category: testCategory,
            account: testAccount
        )
        modelContext.insert(existingTransaction)

        viewModel = ViewModel(modelContext: modelContext, editedTransaction: existingTransaction)
        viewModel.amountString = "200.0"
        viewModel.description = "Updated Transaction"
        viewModel.saveTransaction()

        XCTAssertEqual(existingTransaction.amount, 200.0)
        XCTAssertEqual(existingTransaction.transactionDescription, "Updated Transaction")
    }
    
    func testFormValidation() {
        viewModel = ViewModel(modelContext: modelContext, editedTransaction: nil)

        // Invalid state
        viewModel.amountString = ""
        viewModel.recurringFrequencyString = "invalid"
        XCTAssertFalse(viewModel.isFormValid)

        // Valid state
        viewModel.amountString = "100.0"
        viewModel.recurringFrequencyString = "1"
        viewModel.recurringType = .weekly
        XCTAssertTrue(viewModel.isFormValid)
    }
}
