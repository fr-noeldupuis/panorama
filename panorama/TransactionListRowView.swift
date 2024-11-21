//
//  TransactionListRowView.swift
//  panorama
//
//  Created by Noel Dupuis on 19/11/2024.
//

import SwiftUI

struct TransactionListRowView: View {
    var transaction: Transaction
    
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    Text("Transaction")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(transaction.transactionDescription.isEmpty ? " " : transaction.transactionDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Text("\(formatAmountToString(amount: transaction.amount)) €")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(transaction.amount >= 0 ? .green : .red)
            }
            NavigationLink(destination: EditTransactionView(transactionEdited: transaction)) {
                EmptyView()
            }
            .opacity(0)
        }
    }
    
    func formatAmountToString(amount: Double) -> String {
        let workingAmount = round(amount * 100)/100
        
        if workingAmount.remainder(dividingBy: 1) == 0 {
            return String(format: "%0.0f", amount)
        }
        else if (10 * workingAmount).remainder(dividingBy: 1) == 0 {
            return String(format: "%0.1f", amount)
        }
        else {
            return String(format: "%0.2f", amount)
        }
    }
}

#Preview {
    NavigationStack {
        List {
            TransactionListRowView(transaction: Transaction(amount: 13.70005, date: .now, description: "Test transaction description"))
            TransactionListRowView(transaction: Transaction(amount: -13.75, date: .now, description: "Test transaction description"))
            TransactionListRowView(transaction: Transaction(amount: 13.7, date: .now, description: "Test transaction description"))
            TransactionListRowView(transaction: Transaction(amount: 13, date: .now, description: "Test transaction description"))
            TransactionListRowView(transaction: Transaction(amount: 13, date: .now, description: ""))
        }
    }
}
