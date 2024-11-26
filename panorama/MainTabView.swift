//
//  MainView.swift
//  panorama
//
//  Created by Noel Dupuis on 26/11/2024.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var coordinator = TabCoordinator()

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            // Home Tab
            NavigationStack(path: $coordinator.accountsNavigationPath) {
                AccountsListView(coordinator: coordinator)
            }
            .tabItem {
                Label("Accounts", systemImage: "questionmark")
            }
            .tag(TabCoordinator.Tab.accounts)

            // Search Tab
            NavigationStack(path: $coordinator.categoriesNavigationPath) {
                CategoriesListView(coordinator: coordinator)
            }
            .tabItem {
                Label("Categories", systemImage: "magnifyingglass")
            }
            .tag(TabCoordinator.Tab.categories)

            // Profile Tab
            NavigationStack(path: $coordinator.transactionsNavigationPath) {
                TransactionListView(coordinator: coordinator)
            }
            .tabItem {
                Label("transactions", systemImage: "person")
            }
            .tag(TabCoordinator.Tab.transactions)
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(PreviewContentData.generateContainer())
}
