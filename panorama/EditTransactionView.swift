import SwiftUI
import SwiftData

struct EditTransactionView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext

    @State private var amount: Double?
    @State private var amountPristine: Bool = true
    @State private var amountValid: Bool = false
    
    @State private var transactionDate: Date
    
    var transactionEdited: Transaction?
    
    init(transactionEdited: Transaction? = nil) {
        self.transactionEdited = transactionEdited
        _amount = State(initialValue: transactionEdited?.amount)
        _amountValid = State(initialValue: transactionEdited?.amount != nil)
        _transactionDate = State(initialValue: transactionEdited?.date ?? Calendar.current.startOfDay(for: .now))
    }
    
    var body: some View {
        Form {
            Section {
                VStack {
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("Required", text: Binding(
                            get: { amount != nil ? String(amount!) : "" },
                            set: { newValue in
                                amount = Double(newValue)
                                if !newValue.isEmpty  {
                                    amountPristine = false
                                }
                                amountValid = amount != nil

                            }
                        ))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    }
                    !amountPristine && !amountValid ? Text("Amount is required and must be numeric.")
                        .foregroundColor(.red)
                        .font(.system(size: 11))
                        .frame(maxWidth: .infinity, alignment: .trailing) : nil
                }
                DatePicker(selection: $transactionDate, displayedComponents: .date) {
                    Text("Date")
                }
            }
        }
        .navigationTitle(transactionEdited == nil ? "Create Transaction" : "Edit Transaction")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button(transactionEdited == nil ? "Save" : "Update") {
                    saveTransaction()
                    dismiss()
                }
                .disabled(!amountValid)
                .fontWeight(.semibold)
            }
        }
    }
    
    private func saveTransaction() {
            guard let amount = amount else { return }
            
            if let transaction = transactionEdited {
                // Update existing transaction
                transaction.amount = amount
                transaction.date = transactionDate
                print("Updating transaction with amount: \(amount)")
            } else {
                // Insert new transaction
                let newTransaction = Transaction(amount: amount, date: transactionDate)
                modelContext.insert(newTransaction)
                print("Creating new transaction with amount: \(amount)")
            }
            
            // Attempt to save changes to the model context
            do {
                try modelContext.save()
                print("Transaction saved successfully")
            } catch {
                print("Failed to save transaction: \(error.localizedDescription)")
            }
        }
}

#Preview("Edit Transaction") {
    NavigationView {
        EditTransactionView(transactionEdited: Transaction(amount: 24.0, date: .now))
            .modelContainer(for: Transaction.self, inMemory: true)
    }
}

#Preview("Create Transaction") {
    NavigationView {
        EditTransactionView()
            .modelContainer(for: Transaction.self, inMemory: true)
    }
}
