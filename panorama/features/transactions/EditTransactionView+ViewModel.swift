//
//  EditTransactionView+ViewModel.swift
//  panorama
//
//  Created by Noel Dupuis on 28/11/2024.
//
import SwiftUI
import SwiftData

extension EditTransactionView {
    
    @Observable
    class ViewModel {
        
        private var modelContext: ModelContext
        
        var accounts: [Account] = [Account]()
        var categories: [Category] = [Category]()
        
        var transaction: Transaction?
        
        // Variables to handle amount field
        var amountString: String
        var amountPristine: Bool = true
        
        var amountStringBinding: Binding<String> {
            Binding(
                get: {self.amountString},
                set: { newValue in
                    self.amountString = newValue
                    if (!newValue.isEmpty) {
                        self.amountPristine = false
                    }
                }
            )
        }
        var amountValid: Bool {
            // amount is valid as long it's value is not nil
            amount != nil
        }
        
        var amount: Double? {
            Double(amountString)
        }
        
        // Transaction date
        var date: Date
        
        // Transaction description
        var description: String
        
        // Transaction category
        var category: Category?
        
        // Transaction account
        var account: Account?
        
        // Transaction recurring setup:
        var recurringType: RecurringType
        var recurringFrequencyString: String
        var recurringFrequency: Int? {
            Int(recurringFrequencyString)
        }
        
        var recurringFrequencyValid: Bool {
            recurringType == .once ||
            (
                recurringType != .once &&
                recurringFrequency != nil
            )
        }
        
        var isFormValid: Bool {
            amountValid &&
            recurringFrequencyValid
        }
        
        init(modelContext: ModelContext, editedTransaction: Transaction?) {
            self.modelContext = modelContext
            
            self.transaction = editedTransaction
            
            self.amountString = editedTransaction?.amount.toAbsoluteAmountString() ?? ""
            
            self.date = editedTransaction?.date ?? Calendar.current.startOfDay(for: .now)
            
            self.description = editedTransaction?.transactionDescription ?? ""
            
            self.category = editedTransaction?.category
            
            self.account = editedTransaction?.account
            
            self.recurringType = editedTransaction?.recurringType ?? .once
            
            self.recurringFrequencyString = editedTransaction?.recurringFrequency != nil ? "\(editedTransaction?.recurringFrequency ?? 0)" : ""
            
            fetchAll()
        }
        
        func fetchAccounts() {
            do {
                accounts = try modelContext.fetch(FetchDescriptor<Account>())
            } catch {
                print("Error fetching Accounts: \(error.localizedDescription)")
            }
        }
        
        func fetchCategories() {
            do {
                categories = try modelContext.fetch(FetchDescriptor<Category>())
            } catch {
                print("Error fetching Categories: \(error.localizedDescription)")
            }
        }
        
        func fetchAll() {
            fetchAccounts()
            fetchCategories()
        }
        
        func saveTransaction() {
            if (transaction != nil) {
                // Update existing transaction
                updateTransaction(transaction: &transaction!)
            } else {
                if (recurringType == .once) {
                    let transactionToInsert = Transaction(
                        amount: category!.type == .expense ? -amount! : amount!,
                        date: date,
                        description: description,
                        category: category,
                        account: account,
                        recurringType: .once,
                        recurringFrequency: nil)
                    modelContext.insert(transactionToInsert)
                } else {
                    if (date > .now) {
                        let transactionToInsert = Transaction(
                            amount: category!.type == .expense ? -amount! : amount!,
                            date: date,
                            description: description,
                            category: category,
                            account: account,
                            recurringType: recurringType,
                            recurringFrequency: recurringFrequency)
                        modelContext.insert(transactionToInsert)
                    } else if (date == Calendar.current.startOfDay(for: .now)) {
                        let transactionToInsert = Transaction(
                            amount: category!.type == .expense ? -amount! : amount!,
                            date: date,
                            description: description,
                            category: category,
                            account: account,
                            recurringType: .once,
                            recurringFrequency: nil)
                        modelContext.insert(transactionToInsert)
                        let recurringTransactionToInsert = Transaction(
                            amount: category!.type == .expense ? -amount! : amount!,
                            date: recurringType.nextOccurenceFrom(startDate: date, frequency: recurringFrequency!),
                            description: description,
                            category: category,
                            account: account,
                            recurringType: recurringType,
                            recurringFrequency: recurringFrequency)
                        modelContext.insert(recurringTransactionToInsert)
                    } else {
                        var passedOccurencesToCreate: [Date] = []
                        var dateToCheck = date
                        while (dateToCheck <= Calendar.current.startOfDay(for: .now)) {
                            passedOccurencesToCreate.append(dateToCheck)
                            dateToCheck = recurringType.nextOccurenceFrom(startDate: dateToCheck, frequency: recurringFrequency!)
                        }
                        for passedOccurence in passedOccurencesToCreate {
                            let transactionToInsert = Transaction(
                                amount: category!.type == .expense ? -amount! : amount!,
                                date: passedOccurence,
                                description: description,
                                category: category,
                                account: account,
                                recurringType: .once,
                                recurringFrequency: nil)
                            modelContext.insert(transactionToInsert)
                        }
                        let recurringTransactionToInsert = Transaction(
                            amount: category!.type == .expense ? -amount! : amount!,
                            date: recurringType.nextOccurenceFrom(startDate: passedOccurencesToCreate.last!, frequency: recurringFrequency!),
                            description: description,
                            category: category,
                            account: account,
                            recurringType: recurringType,
                            recurringFrequency: recurringFrequency)
                        modelContext.insert(recurringTransactionToInsert)
                    }
                }
                
            }
            
            do {
                try modelContext.save()
                fetchAll()
            } catch {
                print("Error saving model: \(error.localizedDescription)")
            }
        }
        
        func updateTransaction(transaction: inout Transaction) {
            transaction.amount = category!.type == .expense ? -amount! : amount!
            transaction.date = date
            transaction.transactionDescription = description
            transaction.category = category
            transaction.account = account
            transaction.recurringType = recurringType
            transaction.recurringFrequency = recurringType != .once ? recurringFrequency : nil
        }
        
        
    }
}
