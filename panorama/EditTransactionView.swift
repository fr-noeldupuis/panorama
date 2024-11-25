import SwiftUI
import SwiftData

struct EditTransactionView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext

    @State private var amount: Double?
    @State private var amountPristine: Bool = true
    @State private var amountValid: Bool = false
    
    @State private var transactionDate: Date
    
    @State private var transactionDescription: String = ""
    
    @State private var category: String
    
    @State private var categoryIconName: String
    
    @State private var categoryType: String
    
    @State private var accountName: String
    @State private var accountIconString: String
    
    
    var transactionEdited: Transaction?
    
    init(transactionEdited: Transaction? = nil) {
        self.transactionEdited = transactionEdited
        _amount = State(initialValue: abs(transactionEdited?.amount ?? 0))
        _amountValid = State(initialValue: transactionEdited?.amount != nil)
        _transactionDate = State(initialValue: transactionEdited?.date ?? Calendar.current.startOfDay(for: .now))
        _transactionDescription = State(initialValue: transactionEdited?.transactionDescription ?? "")
        _category = State(initialValue: transactionEdited?.category?.name ?? "No category")
        _categoryIconName = State(initialValue: transactionEdited?.category?.iconName ?? "questionmark")
        _categoryType = State(initialValue: transactionEdited?.category?.type ?? "income")
        _accountName = State(initialValue: transactionEdited?.account?.name ?? "No account")
        _accountIconString = State(initialValue: transactionEdited?.account?.iconName ?? "questionmark")
    }
    
    var body: some View {
        Form {
            Section(header: Text("Transaction")) {
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
                TextField("Description", text: $transactionDescription).foregroundColor(.secondary)
            }
            
            Section(header: Text("Category")) {
                HStack {
                    Text("Name")
                    Spacer()
                    TextField("Enter category name", text: $category)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Icon name")
                    Spacer()
                    TextField("Enter icon name", text: $categoryIconName)
                        .multilineTextAlignment(.trailing)
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                        .textInputAutocapitalization(.never)
                        
                }
                Picker(selection: $categoryType) {
                    Text("Income").tag("income")
                    Text("Expense").tag("expense")
                } label: {
                    Text("Category type")
                }

            }
            
            
            Section(header: Text("Account")) {
                HStack {
                    Text("Name")
                    Spacer()
                    TextField("Enter account name", text: $accountName)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Icon name")
                    Spacer()
                    TextField("Enter icon name", text: $accountIconString)
                        .multilineTextAlignment(.trailing)
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                        .textInputAutocapitalization(.never)
                        
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
                transaction.amount = categoryType == "income" ? amount : -amount
                transaction.date = transactionDate
                transaction.transactionDescription = transactionDescription
                transaction.category?.name = category.isEmpty ? "No category" : category
                transaction.category?.iconName = categoryIconName.isEmpty ? "questionmark" : categoryIconName
                transaction.category?.type = categoryType
                transaction.account?.name = accountName.isEmpty ? "No Account" : accountName
                transaction.account?.iconName = accountIconString.isEmpty ? "questionmark" : accountIconString
            } else {
                // Insert new transaction
                let newTransaction = Transaction(amount: categoryType == "income" ? amount : -amount, date: transactionDate, description: transactionDescription, category: Category(name: category.isEmpty ? "No category" : category, iconName: categoryIconName.isEmpty ? "questionmark" : categoryIconName, type: categoryType, transactions: []), account: Account(name: accountName.isEmpty ? "No Account" : accountName, iconName:accountIconString.isEmpty ? "questionmark" : accountIconString, transactions: []))
                modelContext.insert(newTransaction)
            }
            
            // Attempt to save changes to the model context
            do {
                try modelContext.save()
            } catch {
                print("Failed to save transaction: \(error.localizedDescription)")
            }
        }
}

#Preview("Edit Transaction") {
    NavigationView {
        EditTransactionView(transactionEdited: Transaction(amount: 24.0, date: .now, description: "Dinner", category: Category(name: "Food", iconName: "questionmark", type: "income", transactions: []), account: Account(name: "Bank", iconName: "dollarsign.bank.building.fill", transactions: [])))
            .modelContainer(for: Transaction.self, inMemory: true)
    }
}

#Preview("Create Transaction") {
    NavigationView {
        EditTransactionView()
            .modelContainer(for: Transaction.self, inMemory: true)
    }
}
