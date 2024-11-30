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
    var testCategory: panorama.Category!
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
        // This test ensures that the fields in the ViewModel are initiated the right way when injecting a transaction to be edited.
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
    
    func testViewModelInitializationWithRecurringTransaction() {
        // This test ensures that the fields in the ViewModel are inititalized the right way when injecting a recurring transaction to be edited.
        let existingTransaction = Transaction(
            amount: 100.0,
            date: Date(),
            description: "Test Transaction",
            category: testCategory,
            account: testAccount,
            recurringType: .monthly,
            recurringFrequency: 5
        )
        modelContext.insert(existingTransaction)

        viewModel = ViewModel(modelContext: modelContext, editedTransaction: existingTransaction)

        XCTAssertEqual(viewModel.amountString, "100")
        XCTAssertEqual(viewModel.date, existingTransaction.date)
        XCTAssertEqual(viewModel.description, "Test Transaction")
        XCTAssertEqual(viewModel.category, testCategory)
        XCTAssertEqual(viewModel.account, testAccount)
        XCTAssertEqual(viewModel.recurringType, .monthly)
        XCTAssertEqual(viewModel.recurringFrequency, 5)
    }
    
    func testViewModelInitializationWithoutTransaction() {
        // This test ensures that the fields in the ViewModel are inititalized with the right default values when no transaction is injected.
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
    
    func testCreateFutureDatedRecurringTransaction() {
        // In the case of a future dated recurring transaction, you should have the transaction published as-is.
        let date = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 5, to: .now)!)
        viewModel = ViewModel(modelContext: modelContext, editedTransaction: nil)
        viewModel.amountString = "100.0"
        viewModel.date = date
        viewModel.description = "Initial Transaction"
        viewModel.category = testCategory
        viewModel.account = testAccount
        viewModel.recurringType = .monthly
        viewModel.recurringFrequencyString = "1"
        
        viewModel.saveTransaction()
        
        let transactions = (try? modelContext.fetch(FetchDescriptor<Transaction>())) ?? []
        
        XCTAssertEqual(transactions.count, 1)
        XCTAssertEqual(transactions.first!.recurringType, .monthly)
        XCTAssertEqual(transactions.first!.recurringFrequency, 1)
        XCTAssertEqual(transactions.first!.date, date)
    }
    
    func testCreateSameDateRecurringTransactionRecurringTypeRecurringFrequencyControlInitialTransaction() {
        
        // In the case of a transaction created on the same day, you should have:
        //     - The existing transaction published on the same day, with a .once recurrence. This is the purpose of the current Test.
        //     - The next occurence of the transaction, a new transaction copying everything, with a date based on the frequency and type of recurrence.
        
        let date = Calendar.current.startOfDay(for: .now)
        
        viewModel = ViewModel(modelContext: modelContext, editedTransaction: nil)
        viewModel.amountString = "100.0"
        viewModel.date = date
        viewModel.description = "Initial Transaction"
        viewModel.category = testCategory
        viewModel.account = testAccount
        viewModel.recurringType = .monthly
        viewModel.recurringFrequencyString = "1"
        
        viewModel.saveTransaction()
        
        let transactions = (try? modelContext.fetch(FetchDescriptor<Transaction>())) ?? []
        
        XCTAssertEqual(transactions.count, 2)
        
        let soonestTransaction = transactions.sorted {$0.date < $1.date}.first!
        
        XCTAssertEqual(soonestTransaction.recurringType, .once)
        XCTAssertNil(soonestTransaction.recurringFrequency)
        XCTAssertEqual(soonestTransaction.date, date)
    }
    
    func testCreateSameDateRecurringTransactionRecurringTypeRecurringFrequencyControlRecurringTransaction() {
        
        // In the case of a transaction created on the same day, you should have:
        //     - The existing transaction published on the same day, with a .once recurrence.
        //     - The next occurence of the transaction, a new transaction copying everything, with a date based on the frequency and type of recurrence. This is the purpose of the current Test.
        
        let date = Calendar.current.startOfDay(for: .now)
        
        viewModel = ViewModel(modelContext: modelContext, editedTransaction: nil)
        viewModel.amountString = "100.0"
        viewModel.date = date
        viewModel.description = "Initial Transaction"
        viewModel.category = testCategory
        viewModel.account = testAccount
        viewModel.recurringType = .monthly
        viewModel.recurringFrequencyString = "1"
        
        viewModel.saveTransaction()
        
        let transactions = (try? modelContext.fetch(FetchDescriptor<Transaction>())) ?? []
        
        XCTAssertEqual(transactions.count, 2)
        
        let latestTransaction = transactions.sorted {$0.date < $1.date}.last!
        
        XCTAssertEqual(latestTransaction.recurringType, .monthly)
        XCTAssertEqual(latestTransaction.recurringFrequency, 1)
        XCTAssertEqual(latestTransaction.date, RecurringType.monthly.nextOccurenceFrom(startDate: date, frequency: 1))
    }
    
    func testCreatePassedDateRecurringTransactionRecurringTypeRecurringFrequencyControlPassedTransaction() {
        
        // In the case of a transaction created on a passed date, you should have:
        //     - as many as needed transacitons created for the passed occurences with a .once recurrence. This is the purpose of the current Test.
        //     - The next occurence of the transaction, a new transaction copying everything, with a date based on the frequency and type of recurrence.
        
        let date = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: .now))!
        
        viewModel = ViewModel(modelContext: modelContext, editedTransaction: nil)
        viewModel.amountString = "100.0"
        viewModel.date = date
        viewModel.description = "Initial Transaction"
        viewModel.category = testCategory
        viewModel.account = testAccount
        viewModel.recurringType = .daily
        viewModel.recurringFrequencyString = "1"
        
        viewModel.saveTransaction()
        
        let transactions = (try? modelContext.fetch(FetchDescriptor<Transaction>())) ?? []
        
        XCTAssertEqual(transactions.count, 3)
        XCTAssertEqual(transactions.filter {$0.date == Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: .now))!}.count, 1)
        XCTAssertEqual(transactions.filter {$0.date == Calendar.current.startOfDay(for: .now)}.count, 1)
        XCTAssertEqual(transactions.filter {$0.transactionDescription == "Initial Transaction"}.count, 3)
        XCTAssertEqual(transactions.filter {$0.amount == 100}.count, 3)
        XCTAssertEqual(transactions.filter {$0.category == testCategory}.count, 3)
        XCTAssertEqual(transactions.filter {$0.account == testAccount}.count, 3)
        XCTAssertEqual(transactions.filter {$0.recurringType == .once}.count, 2)
        XCTAssertEqual(transactions.filter {$0.recurringFrequency == nil}.count, 2)
    }
    
    func testCreatePassedDateRecurringTransactionRecurringTypeRecurringFrequencyControlRecurringTransaction() {
        
        // In the case of a transaction created on a passed date, you should have:
        //     - as many as needed transacitons created for the passed occurences with a .once recurrence.
        //     - The next occurence of the transaction, a new transaction copying everything, with a date based on the frequency and type of recurrence. This is the purpose of the current Test.
        
        let date = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: .now))!
        
        viewModel = ViewModel(modelContext: modelContext, editedTransaction: nil)
        viewModel.amountString = "100.0"
        viewModel.date = date
        viewModel.description = "Initial Transaction"
        viewModel.category = testCategory
        viewModel.account = testAccount
        viewModel.recurringType = .daily
        viewModel.recurringFrequencyString = "1"
        
        viewModel.saveTransaction()
        
        let transactions = (try? modelContext.fetch(FetchDescriptor<Transaction>())) ?? []
        
        XCTAssertEqual(transactions.count, 3)
        XCTAssertEqual(transactions.filter {$0.date == Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: .now))!}.count, 1)
        XCTAssertEqual(transactions.filter {$0.date == Calendar.current.startOfDay(for: .now)}.count, 1)
        XCTAssertEqual(transactions.filter {$0.date == Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: .now))!}.count, 1)
        XCTAssertEqual(transactions.filter {$0.transactionDescription == "Initial Transaction"}.count, 3)
        XCTAssertEqual(transactions.filter {$0.amount == 100}.count, 3)
        XCTAssertEqual(transactions.filter {$0.category == testCategory}.count, 3)
        XCTAssertEqual(transactions.filter {$0.account == testAccount}.count, 3)
        XCTAssertEqual(transactions.filter {$0.recurringType == .once}.count, 2)
        XCTAssertEqual(transactions.filter {$0.recurringFrequency == nil}.count, 2)
        XCTAssertEqual(transactions.filter {$0.date == Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: .now))!}.count, 1)
        XCTAssertEqual(transactions.filter {$0.date == Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: .now))!}.first!.recurringType, .daily)
        XCTAssertEqual(transactions.filter {$0.date == Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: .now))!}.first!.recurringFrequency, 1)
    }
    
    func testUpdateNonRecurringTransactionToRecurringTransaction() {
        
        // Expected behavior:
        //     - a transaction for the upcoming occurence is created, it has the same information as the original with the recurrence.
        //     - passed transactions (if relevant) are created
        //
        // Let's test behavior 1
        let dateComponents = DateComponents(year: 2024, month: 11, day: 1)
        let date = Calendar.current.date(from: dateComponents)!
        
        let transaction = Transaction(
            amount: 100,
            date: date,
            description: "Test transaction",
            category: testCategory,
            account: testAccount,
            recurringType: .once,
            recurringFrequency: nil
        )
        
        modelContext.insert(transaction)
        
        viewModel = ViewModel(modelContext: modelContext, editedTransaction: transaction)
        
        viewModel.recurringType = .daily
        viewModel.recurringFrequencyString = "1"
        
        viewModel.saveTransaction()
        
        let transactions = (try? modelContext.fetch(FetchDescriptor<Transaction>())) ?? []
        
        let expectedNextOccurence = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: .now))!
        
        XCTAssertEqual(transactions.filter {$0.date == expectedNextOccurence}.count, 1)
        XCTAssertEqual(transactions.filter {$0.date == expectedNextOccurence}.first!.amount, transaction.amount)
        XCTAssertEqual(transactions.filter {$0.date == expectedNextOccurence}.first!.transactionDescription, transaction.transactionDescription)
        XCTAssertEqual(transactions.filter {$0.date == expectedNextOccurence}.first!.category, transaction.category)
        XCTAssertEqual(transactions.filter {$0.date == expectedNextOccurence}.first!.account, transaction.account)
        XCTAssertEqual(transactions.filter {$0.date == expectedNextOccurence}.first!.recurringType, .daily)
        XCTAssertEqual(transactions.filter {$0.date == expectedNextOccurence}.first!.recurringFrequency, 1)
    }
    
    func testUpdateNonRecurringTransactionToRecurringTransactionPastTransactions() {
        
        // Expected behavior:
        //     - a transaction for the upcoming occurence is created, it has the same information as the original with the recurrence.
        //     - passed transactions (if relevant) are created
        //
        // Let's test behavior 2
        let dateComponents = DateComponents(year: 2024, month: 11, day: 1)
        let date = Calendar.current.date(from: dateComponents)!
        
        let transaction = Transaction(
            amount: 100,
            date: date,
            description: "Test transaction",
            category: testCategory,
            account: testAccount,
            recurringType: .once,
            recurringFrequency: nil
        )
        
        modelContext.insert(transaction)
        
        viewModel = ViewModel(modelContext: modelContext, editedTransaction: transaction)
        
        viewModel.recurringType = .daily
        viewModel.recurringFrequencyString = "1"
        
        viewModel.saveTransaction()
        
        let transactions = (try? modelContext.fetch(FetchDescriptor<Transaction>())) ?? []
        
        let expectedNextOccurence = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: .now))!
        
        let expectedNbDays = Calendar.current.dateComponents([.day], from: date, to: expectedNextOccurence).day!
        
        XCTAssertEqual(transactions.count, expectedNbDays + 1)
        XCTAssertTrue(transactions.allSatisfy {$0.amount == transaction.amount})
        XCTAssertTrue(transactions.allSatisfy {$0.transactionDescription == transaction.transactionDescription})
        XCTAssertTrue(transactions.allSatisfy {$0.category == transaction.category})
        XCTAssertTrue(transactions.allSatisfy {$0.account == transaction.account})
        XCTAssertTrue(transactions.filter {$0.date != expectedNextOccurence}.allSatisfy {$0.recurringType == .once})
        XCTAssertTrue(transactions.filter {$0.date != expectedNextOccurence}.allSatisfy {$0.recurringFrequency == nil})
    }
    
    func testUpdateNonRecurringTransactionToRecurringTransactionSameDayPastTransactions() {
        
        // Expected behavior:
        //     - a transaction for the upcoming occurence is created, it has the same information as the original with the recurrence.
        //     - passed transactions (if relevant) are created
        //
        // Let's test behavior 2
        let dateComponents = DateComponents(year: 2024, month: 11, day: 1)
        let date = Calendar.current.date(from: dateComponents)!
        
        let transaction = Transaction(
            amount: 100,
            date: date,
            description: "Test transaction",
            category: testCategory,
            account: testAccount,
            recurringType: .once,
            recurringFrequency: nil
        )
        
        modelContext.insert(transaction)
        
        viewModel = ViewModel(modelContext: modelContext, editedTransaction: transaction)
        
        viewModel.date = Calendar.current.startOfDay(for: .now)
        viewModel.recurringType = .daily
        viewModel.recurringFrequencyString = "1"
        
        viewModel.saveTransaction()
        
        let transactions = (try? modelContext.fetch(FetchDescriptor<Transaction>())) ?? []
        
        let expectedNextOccurence = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: .now))!
        
        XCTAssertEqual(transactions.count, 2)
        XCTAssertTrue(transactions.allSatisfy {$0.amount == transaction.amount})
        XCTAssertTrue(transactions.allSatisfy {$0.transactionDescription == transaction.transactionDescription})
        XCTAssertTrue(transactions.allSatisfy {$0.category == transaction.category})
        XCTAssertTrue(transactions.allSatisfy {$0.account == transaction.account})
        XCTAssertTrue(transactions.filter {$0.date != expectedNextOccurence}.allSatisfy {$0.recurringType == .once})
        XCTAssertTrue(transactions.filter {$0.date != expectedNextOccurence}.allSatisfy {$0.recurringFrequency == nil})
    }
    
    
    func testUpdateFutureRecurringTransaction() {
        
        let date = Calendar.current.date(byAdding: .day, value: 30, to: Calendar.current.startOfDay(for: .now))!
        
        let transaction = Transaction(
            amount: 100,
            date: date,
            description: "Test transaction",
            category: testCategory,
            account: testAccount,
            recurringType: .daily,
            recurringFrequency: 1
        )
        
        modelContext.insert(transaction)
        
        viewModel = ViewModel(modelContext: modelContext, editedTransaction: transaction)
        
        viewModel.amountString = "100"
        viewModel.saveTransaction()
        
        let transactions = (try? modelContext.fetch(FetchDescriptor<Transaction>())) ?? []
        
        XCTAssertTrue(transactions.count == 1)
        XCTAssertTrue(transactions.first!.date == date)
        XCTAssertTrue(transactions.first!.amount == 100)
    }
    
    func testPastDateRecurringTransaction() {
        
        let oldDate = Calendar.current.date(byAdding: .day, value: 4, to: Calendar.current.startOfDay(for: .now))!
        
        let newDate = Calendar.current.date(byAdding: .day, value: -4, to: Calendar.current.startOfDay(for: .now))!
        
        let transaction = Transaction(
            amount: 100,
            date: oldDate,
            description: "Test transaction",
            category: testCategory,
            account: testAccount,
            recurringType: .daily,
            recurringFrequency: 1
        )
        
        modelContext.insert(transaction)
        
        viewModel = ViewModel(modelContext: modelContext, editedTransaction: transaction)
        
        viewModel.date = newDate
        viewModel.saveTransaction()
        
        let transactions = (try? modelContext.fetch(FetchDescriptor<Transaction>())) ?? []
        
        XCTAssertTrue(transactions.count == 6)
    }
}
