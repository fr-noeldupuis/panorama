//
//  TransactionListView.swift
//  panorama
//
//  Created by Noel Dupuis on 18/11/2024.
//

import SwiftUI
import SwiftData
import OrderedCollections

struct TransactionListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query var transactions: [Transaction]
    
    // Custom date formatter for the "DD mmmm yyyy" format
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        List {
                        // Group transactions by date
            ForEach(OrderedDictionary(grouping: transactions, by: \.date).elements, id: \.key) { element in
                let dailyTransactions = element.value
                let date = element.key
                
                // Calculate the sum of transaction amounts for the day
                let dailyTotal = dailyTransactions.reduce(0) { $0 + $1.amount }
                
                // Define each Section with transactions for that date
                Section(header: HStack {
                    Text(dateFormatter.string(from: date))
                    Spacer()
                    Text("\(dailyTotal, specifier: "%.2f") €")
                }
                ) {
                    ForEach(dailyTransactions) { transaction in
                        NavigationLink(destination: EditTransactionView(transactionEdited: transaction)) {
                            Text("Transaction \(transaction.id.uuidString) \(transaction.amount, specifier: "%.2f")")
                        }
                    }
                }
            }
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)) // Reduce row insets to adjust padding
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
    container.mainContext.insert(Transaction(amount: -250, date: Calendar.current.date(from: comps2)!))
    container.mainContext.insert(Transaction(amount: 220, date: Calendar.current.date(from: comps2)!))
    
    container.mainContext.insert(Transaction(amount: 17.54, date: Calendar.current.startOfDay(for: .now)))
    
    
    return NavigationStack {
        TransactionListView()
            .modelContainer(container)
    }
}
