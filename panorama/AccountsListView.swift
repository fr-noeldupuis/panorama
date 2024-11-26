//
//  AccountsListView.swift
//  panorama
//
//  Created by Noel Dupuis on 26/11/2024.
//

import SwiftUI

struct AccountsListView: View {
    
    @ObservedObject var coordinator: TabCoordinator
    
    var body: some View {
        Text("Hello, Accounts!")
    }
}

#Preview {
    let mockCoordinator = TabCoordinator()
    
    NavigationStack(path: .constant(mockCoordinator.accountsNavigationPath)) {
        AccountsListView(coordinator: mockCoordinator)
    }
}
