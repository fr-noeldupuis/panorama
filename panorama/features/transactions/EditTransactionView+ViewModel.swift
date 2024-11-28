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
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchAccounts()
        }
        
        func fetchAccounts() {
            do {
                accounts = try modelContext.fetch(FetchDescriptor<Account>())
            } catch {
                print("Error fetching Accounts: \(error.localizedDescription)")
            }
        }
    }
}
