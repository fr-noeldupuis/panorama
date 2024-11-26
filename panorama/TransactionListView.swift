//
//  TransactionListView.swift
//  panorama
//
//  Created by Noel Dupuis on 18/11/2024.
//

import OrderedCollections
import SwiftData
import SwiftUI

struct TransactionListView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Transaction.date, order: .reverse) var transactions:
        [Transaction]
    
    @Query var accounts: [Account]

    // Custom date formatter for the "DD mmmm yyyy" format
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()

    var body: some View {
        List {
            ForEach(
                OrderedDictionary(grouping: transactions, by: \.date).elements,
                id: \.key
            ) { element in
                let dailyTransactions = element.value
                let date = element.key

                let dailyTotal = dailyTransactions.reduce(0) { $0 + $1.amount }

                Section(
                    header: HStack {
                        Text(dateFormatter.string(from: date))
                        Spacer()
                        Text("\(dailyTotal, specifier: "%.2f") €")
                    }
                ) {
                    ForEach(dailyTransactions) { transaction in
                        TransactionListRowView(transaction: transaction)
                            .swipeActions(
                                edge: .trailing, allowsFullSwipe: false
                            ) {
                                Button(role: .destructive) {
                                    modelContext.delete(transaction)
                                } label: {
                                    Label("delete", systemImage: "trash.fill")
                                }
                            }
                    }
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
    NavigationStack {
        TransactionListView()
            .modelContainer(PreviewContentData.generateContainer(incomeCategoriesCount: 5, expenseCategoryCount:7, accountsCount: 10, transactionCount: 1500))
    }
}
