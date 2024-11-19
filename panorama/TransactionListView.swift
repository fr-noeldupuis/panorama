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
                        Text("Transaction \(transaction.amount, specifier: "%.2f")")
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
    
    container.mainContext.insert(Transaction(amount: 17))
    container.mainContext.insert(Transaction(amount: -20))
    container.mainContext.insert(Transaction(amount: 17.54))
    
    
    return NavigationStack {
        TransactionListView()
            .modelContainer(container)
    }
}
