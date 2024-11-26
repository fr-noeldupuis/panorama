//
//  AccountsListView.swift
//  panorama
//
//  Created by Noel Dupuis on 26/11/2024.
//

import SwiftUI
import SwiftData

struct AccountsListView: View {
    
    @ObservedObject var coordinator: TabCoordinator
    
    @Query private var accounts: [Account]
    
    var body: some View {
        List {
            ForEach(accounts) { account in
                let amount = account.transactions.reduce(0) {
                    $0 + $1.amount
                }

                HStack {
                    VStack(alignment: .leading) {
                        Text(account.name)
                    }
                    Spacer()
                    Text("\(formatAmountToString(amount: amount)) €")
                        .foregroundColor(amount < 0 ? .red : .green)
                        .font(.headline)
                }
            }
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
    let mockCoordinator = TabCoordinator()
    
    NavigationStack(path: .constant(mockCoordinator.accountsNavigationPath)) {
        AccountsListView(coordinator: mockCoordinator)
    }
    .modelContainer(PreviewContentData.generateContainer(transactionCount: 150))
}
