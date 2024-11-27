//
//  EditAccountView.swift
//  panorama
//
//  Created by Noel Dupuis on 27/11/2024.
//

import SwiftUI

struct EditAccountView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    private var editedAccount: Account?
    
    @State var name: String
    
    @State var iconName: String
    
    private let gridRows = [
            GridItem(.adaptive(minimum: 150)),
            GridItem(.adaptive(minimum: 150)),
            GridItem(.adaptive(minimum: 150)),
            GridItem(.adaptive(minimum: 150))
        ]
    
    
    init(editedAccount: Account? = nil) {
        self.editedAccount = editedAccount
        _name = State(initialValue: editedAccount?.name ?? "")
        _iconName = State(initialValue: editedAccount?.iconName ?? sfSymbolsList.prefix(10).randomElement()!)
    }
    var body: some View {
        Form {
            Section("Information") {
                HStack {
                    Text("Name")
                    TextField("Enter name", text: $name)
                        .multilineTextAlignment(.trailing)
                }
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
        .navigationTitle("\(editedAccount == nil ? "Create" : "Edit") account")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    saveAccount()
                    dismiss()
                }
                .disabled(name.isEmpty)
                .fontWeight(.semibold)
            }
        }
    }
    
    func saveAccount() {
        if let account = editedAccount {
            account.name = name
            account.iconName = iconName
        } else {
            let accountToSave = Account(name: name, iconName: iconName, transactions: [])
            modelContext.insert(accountToSave)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save transaction: \(error.localizedDescription)")
        }
        
    }
}

#Preview {
    NavigationStack {
        EditAccountView()
    }
}
