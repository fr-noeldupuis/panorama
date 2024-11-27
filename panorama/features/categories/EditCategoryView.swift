//
//  EditCategoryView.swift
//  panorama
//
//  Created by Noel Dupuis on 26/11/2024.
//

import SwiftUI

struct EditCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    private var editedCategory: Category?
    
    @State private var name: String
    
    @State private var type: CategoryType
    
    @State private var iconName: String
    
    
    init(editedCategory: Category? = nil) {
        _name = State(initialValue: editedCategory?.name ?? "")
        _type = State(initialValue: editedCategory?.type ?? .income)
        _iconName = State(initialValue: editedCategory?.iconName ?? sfSymbolsList.prefix(10).randomElement()!)
        self.editedCategory = editedCategory
    }
    
    private let gridRows = [
            GridItem(.adaptive(minimum: 150)),
            GridItem(.adaptive(minimum: 150)),
            GridItem(.adaptive(minimum: 150)),
            GridItem(.adaptive(minimum: 150))
        ]
    
    var body: some View {
        Form{
            Section(header: Text("Information")) {
                HStack {
                    Text("Name")
                    TextField("Enter category name", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                Picker(selection: $type) {
                    Text("Income").tag(CategoryType.income)
                    Text("Expense").tag(CategoryType.expense)
                } label: {
                    Text("Category type")
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Icon")) {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: gridRows) {
                        ForEach(sfSymbolsList, id: \.self) { symbol in
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(.secondary.opacity(symbol == iconName ? 0.2 : 0))
                                Image(systemName: symbol)
                                    .font(.system(size: 28))
                                    .foregroundColor(symbol == iconName ? .primary : .primary.opacity(0.6))
                            }
                            .frame(width: 50, height: 50, alignment: .center)
                            .onTapGesture {
                                iconName = symbol
                            }
                            
                        }
                    }
                }
            }
            
        }
        .navigationTitle("\(editedCategory == nil ? "Create" : "Edit") category")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    saveCategory()
                    dismiss()
                } label: {
                    Text("Done")
                }
                .disabled(name.isEmpty || iconName.isEmpty)
                .fontWeight(.semibold)
            }
            
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func saveCategory() {
        if let category = editedCategory {
            category.iconName = iconName
            category.name = name
            category.type = type
        }
        else {
            let category = Category(name: name, iconName: iconName, type: type, transactions: [])
            modelContext.insert(category)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save transaction: \(error.localizedDescription)")
        }
    }
}

#Preview("Create category") {
    NavigationStack {
        EditCategoryView()
    }
}

#Preview("Edit category (income)") {
    NavigationStack {
        EditCategoryView(editedCategory: Category(name: "Test Category", iconName: sfSymbolsList.prefix(10).randomElement()!, type: .income, transactions: []))
    }
}

#Preview("Edit category (expense)") {
    NavigationStack {
        EditCategoryView(editedCategory: Category(name: "Test Category", iconName: sfSymbolsList.prefix(10).randomElement()!, type: .expense, transactions: []))
    }
}

