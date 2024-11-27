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
                AccountListRowView(account: account)
            }
        }
        .navigationTitle("Accounts")
        .toolbar {
            ToolbarItem {
                NavigationLink(destination: EditAccountView()) {
                    Image(systemName: "plus")
                }
            }
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
