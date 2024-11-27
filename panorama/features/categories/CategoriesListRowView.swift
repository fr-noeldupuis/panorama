//
//  CategoriesListRowView.swift
//  panorama
//
//  Created by Noel Dupuis on 27/11/2024.
//

import SwiftUI

struct CategoriesListRowView: View {
    
    var category: Category
    
    var body: some View {
        
        let amount = abs(category.transactions.reduce(0) {
            $0 + $1.amount
        })
        ZStack {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(category.type == "expense" ? .red : .green)
                    Image(systemName: category.iconName)
                        .font(.system(size: 24))
                }
                .frame(width: 56, height: 48)
                VStack(alignment: .leading) {
                    Text(category.name)
                }
                Spacer()
                Text("\(formatAmountToString(amount: amount)) €")
                    .foregroundColor(category.type == "expense" ? .red : .green)
                    .font(.headline)
            }
            NavigationLink(destination: EditCategoryView(editedCategory: category)) {
                EmptyView()
            }.opacity(0)
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
    List {
        ForEach (PreviewContentData.categoriesExample) { category in
            CategoriesListRowView(category: category)
        }
    }
}
