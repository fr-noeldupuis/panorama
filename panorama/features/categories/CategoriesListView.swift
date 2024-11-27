//
//  CategoriesListView.swift
//  panorama
//
//  Created by Noel Dupuis on 26/11/2024.
//

import SwiftUI
import SwiftData

struct CategoriesListView: View {
    @ObservedObject var coordinator: TabCoordinator
    
    @Query private var categories: [Category]
    
    var body: some View {
        List {
            ForEach(Dictionary(grouping: categories, by: \.type).sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { type, categoriesByType in
                Section(header: Text(type.rawValue.uppercased())) {
                    ForEach(categoriesByType) { category in
                        CategoriesListRowView(category: category)
                        
                    }
                }
            }
        }
        .navigationTitle("Categories")
        .toolbar {
            ToolbarItem {
                NavigationLink(destination: EditCategoryView()) {
                    Image(systemName: "plus")
                }
            }
        }
    }

}

#Preview {
    let mockCoordinator = TabCoordinator()
    
    NavigationStack(path: .constant(mockCoordinator.categoriesNavigationPath)) {
        CategoriesListView(coordinator: mockCoordinator)
    }
    .modelContainer(PreviewContentData.generateContainer())
}


