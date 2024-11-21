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

    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Transaction.self, configurations: configuration)

    var comps1 = DateComponents()
    comps1.day = 21
    comps1.month = 10
    comps1.year = 2020

    container.mainContext.insert(
        Transaction(
            amount: 17, date: Calendar.current.date(from: comps1)!,
            description: "Test 00"))

    var comps2 = DateComponents()
    comps2.day = 21
    comps2.month = 3
    comps2.year = 2022

    container.mainContext.insert(
        Transaction(
            amount: -20, date: Calendar.current.date(from: comps2)!,
            description: "Test 1"))
    container.mainContext.insert(
        Transaction(amount: -250, date: Calendar.current.date(from: comps2)!))
    container.mainContext.insert(
        Transaction(
            amount: 220, date: Calendar.current.date(from: comps2)!,
            description: "Test 3"))

    container.mainContext.insert(
        Transaction(amount: 17.54, date: Calendar.current.startOfDay(for: .now))
    )

    return NavigationStack {
        TransactionListView()
            .modelContainer(container)
    }
}
