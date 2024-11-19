//
//  TransactionListView.swift
//  panorama
//
//  Created by Noel Dupuis on 18/11/2024.
//

import SwiftUI
import SwiftData

struct TransactionListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query var transactions: [Transaction]
    
    var body: some View {
            List {
                ForEach(transactions) { transaction in
                    NavigationLink(destination: EditTransactionView(transactionEdited: transaction)) {
                        Text("Transaction \(transaction.id.uuidString) \(transaction.amount, specifier: "%.2f")")
                    }
                }
            }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: EditTransactionView()) {
                        Image(systemName: "plus")
                    }
                }
            }
    }
}

#Preview {
    
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Transaction.self, configurations: configuration)
    
    var comps1 = DateComponents()
    comps1.day = 21
    comps1.month = 10
    comps1.year = 2020

    container.mainContext.insert(Transaction(amount: 17, date: Calendar.current.date(from: comps1)!))
    
    var comps2 = DateComponents()
    comps2.day = 21
    comps2.month = 3
    comps2.year = 2022

    container.mainContext.insert(Transaction(amount: -20, date: Calendar.current.date(from: comps2)!))
    
    container.mainContext.insert(Transaction(amount: 17.54, date: Calendar.current.startOfDay(for: .now)))
    
    
    return NavigationStack {
        TransactionListView()
            .modelContainer(container)
    }
}
