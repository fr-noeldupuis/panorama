//
//  EditTransactionView.swift
//  panorama
//
//  Created by Noel Dupuis on 18/11/2024.
//

import SwiftUI
import SwiftData

struct EditTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext

    @State private var amount : Double?
    
    var transactionEdited: Transaction?
    
    init(transactionEdited: Transaction? = nil) {
        self.transactionEdited = transactionEdited
        _amount = State(initialValue: transactionEdited?.amount)
    }
    
    var body: some View {
        Form {
            LabeledContent {
                TextField("Required", text: Binding(
                    get: {amount != nil ? String(amount!) : ""},
                    set: {newValue in amount = Double(newValue)}
                ))
                .keyboardType(.decimalPad)
            } label: {
                Text("Amount")
            }
            .multilineTextAlignment(.trailing)
                
        }
        .navigationTitle(transactionEdited == nil ? "Create transaction" : "Edit Transaction")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                })
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    do {
                        try modelContext.save()
                    } catch {
                        fatalError("Error saving: \(error)")
                    }
                }, label: {
                    Text( transactionEdited == nil ? "Save" : "Update")
                }
                )
                .disabled(amount == nil)
            }
        }
    }
}

#Preview("Edit Transaction") {
    NavigationView {
        EditTransactionView(transactionEdited: Transaction(amount: 24.0))
            .modelContainer(for: Transaction.self, inMemory: true)
    }
}

#Preview("Create Transaction") {
    NavigationView {
        EditTransactionView()
            .modelContainer(for: Transaction.self, inMemory: true)
    }
}
