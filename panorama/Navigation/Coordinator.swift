//
//  Coordinator.swift
//  panorama
//
//  Created by Noel Dupuis on 26/11/2024.
//

import SwiftUI

class TabCoordinator: ObservableObject {
    enum Tab {
        case accounts
        case categories
        case transactions
    }

    // Current selected tab
    @Published var selectedTab: Tab = .transactions

    // Navigation stack state for each tab
    @Published var accountsNavigationPath: NavigationPath = NavigationPath()
    @Published var categoriesNavigationPath: NavigationPath = NavigationPath()
    @Published var transactionsNavigationPath: NavigationPath = NavigationPath()

    // Reset all navigation paths if needed
    func resetNavigation() {
        accountsNavigationPath = NavigationPath()
        categoriesNavigationPath = NavigationPath()
        transactionsNavigationPath = NavigationPath()
    }
}

