//
//  CategoriesListView.swift
//  panorama
//
//  Created by Noel Dupuis on 26/11/2024.
//

import SwiftUI

struct CategoriesListView: View {
    @ObservedObject var coordinator: TabCoordinator
    
    var body: some View {
        Text("Hello, Categories!")
    }
}

#Preview {
    let mockCoordinator = TabCoordinator()
    
    NavigationStack(path: .constant(mockCoordinator.categoriesNavigationPath)) {
        CategoriesListView(coordinator: mockCoordinator)
    }
}
