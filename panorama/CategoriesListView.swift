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
            ForEach(Dictionary(grouping: categories, by: \.type).sorted(by: { $0.key < $1.key }), id: \.key) { type, categoriesByType in
                Section(header: Text(type.uppercased())) {
                    ForEach(categoriesByType) { category in
                        let amount = abs(category.transactions.reduce(0) {
                            $0 + $1.amount
                        })
                        HStack {
                            VStack(alignment: .leading) {
                                Text(category.name)
                            }
                            Spacer()
                            Text("\(formatAmountToString(amount: amount)) €")
                                .foregroundColor(category.type == "expense" ? .red : .green)
                        }
                    }
                }
            }
        }
        .navigationTitle("Categories")
        .toolbar {
            ToolbarItem {
                Image(systemName: "plus")
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
    
    NavigationStack(path: .constant(mockCoordinator.categoriesNavigationPath)) {
        CategoriesListView(coordinator: mockCoordinator)
    }
    .modelContainer(PreviewContentData.generateContainer())
}
