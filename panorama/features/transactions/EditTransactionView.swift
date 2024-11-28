import SwiftUI
import SwiftData

struct EditTransactionView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query private var categories: [Category]
    @Query private var accounts: [Account]

    @State private var amount: Double?
    @State private var amountPristine: Bool = true
    @State private var amountValid: Bool = false
    
    @State private var transactionDate: Date
    
    @State private var transactionDescription: String = ""
    
    @State private var selectedCategory: Category?
    
    @State private var selectedAccount: Account?
    
    @State private var recurringType: RecurringType
    @State private var recurringFrequencyText: String
    
    
    var transactionEdited: Transaction?
    
    init(transactionEdited: Transaction? = nil) {
        self.transactionEdited = transactionEdited
        _amount = State(initialValue: abs(transactionEdited?.amount ?? 0))
        _amountValid = State(initialValue: transactionEdited?.amount != nil)
        _transactionDate = State(initialValue: transactionEdited?.date ?? Calendar.current.startOfDay(for: .now))
        _transactionDescription = State(initialValue: transactionEdited?.transactionDescription ?? "")
        _selectedCategory = State(initialValue: transactionEdited?.category)
        _selectedAccount = State(initialValue: transactionEdited?.account)
        _recurringType = State(initialValue: transactionEdited?.recurringType ?? .once)
        _recurringFrequencyText = State(initialValue: "\(transactionEdited?.recurringFrequency ?? 1)")
        
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
                
                Picker(selection: $selectedCategory) {
                    ForEach(categories) { category in
                        Text("\(category.name) - \(category.type.rawValue)").tag(category)
                    }
                } label: {
                    Text("Category")
                }

            }
            
            
            Section(header: Text("Account")) {
                Picker(selection: $selectedAccount) {
                    ForEach(accounts) { account in
                        Text(account.name).tag(account)
                    }
                } label: {
                    Text("Account")
                }
            }
            
            Section(header: Text("Repeated transaction")) {
                Picker(selection: $recurringType) {
                    ForEach(RecurringType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                } label: {
                    Text("Repeat transaction")
                }
                
                if recurringType != .once {
                    HStack {
                        Text("Every")
                        TextField("Frequency", text: $recurringFrequencyText)
                            .multilineTextAlignment(.trailing)
                    }
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
                .disabled(
                    !amountValid &&
                    (
                        ( recurringType != .once && Int(recurringFrequencyText) != nil) ||
                        (recurringType == .once)
                    )
                )
                .fontWeight(.semibold)
            }
        }
        .onAppear {
            selectedCategory = selectedCategory ?? categories.randomElement()
            selectedAccount = selectedAccount ?? accounts.randomElement()
        }
    }
    
    private func saveTransaction() {
            guard let amount = amount else { return }
            
            if let transaction = transactionEdited {
                // Update existing transaction
                transaction.amount = selectedCategory?.type == .income ? amount : -amount
                transaction.date = transactionDate
                transaction.transactionDescription = transactionDescription
                transaction.category = selectedCategory
                transaction.account = selectedAccount
                transaction.recurringType = recurringType
                transaction.recurringFrequency = recurringType == .once ? nil : Int(recurringFrequencyText)!
            } else {
                // Insert new transaction
                let newTransaction = Transaction(amount: selectedCategory?.type == .income ? amount : -amount, date: transactionDate, description: transactionDescription, category: selectedCategory, account: selectedAccount, recurringType: recurringType, recurringFrequency: recurringType == .once ? nil : Int(recurringFrequencyText)!)
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
    let container = PreviewContentData.generateContainer()
    
    let account = Account(name: "Bank", iconName: "dollarsign.bank.building.fill", transactions: [])
    container.mainContext.insert(account)
    
    let category = Category(name: "Salary", iconName: "dollarsign.bank.building.fill", type: .income, transactions: [])
    container.mainContext.insert(category)

    return NavigationView {
        EditTransactionView(transactionEdited: Transaction(amount: 24.0, date: .now, description: "Dinner", category: category, account: account))
            .modelContainer(container)
    }
}

#Preview("Create Transaction") {
    NavigationView {
        EditTransactionView()
            .modelContainer(PreviewContentData.generateContainer())
    }
}
