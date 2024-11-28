import SwiftUI
import SwiftData

struct EditTransactionView: View {
    
    @Environment(\.dismiss) var dismiss
    private var modelContext: ModelContext
    
    @State var viewModel: ViewModel
    
    
    var transactionEdited: Transaction?
    
    init(transactionEdited: Transaction? = nil, modelContext: ModelContext) {
        self.transactionEdited = transactionEdited
        self.modelContext = modelContext
        let viewModel = ViewModel(modelContext: modelContext, editedTransaction: transactionEdited)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Transaction")) {
                VStack {
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("Required", text: viewModel.amountStringBinding)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    }
                    (!viewModel.amountValid && !viewModel.amountPristine) ? Text("Amount is required and must be numeric.")
                        .foregroundColor(.red)
                        .font(.system(size: 11))
                        .frame(maxWidth: .infinity, alignment: .trailing) : nil
                }
                DatePicker(selection: $viewModel.date, displayedComponents: .date) {
                    Text("Date")
                }
                TextField("Description", text: $viewModel.description).foregroundColor(.secondary)
            }
            
            Section(header: Text("Category")) {
                
                Picker(selection: $viewModel.category) {
                    ForEach(viewModel.categories) { category in
                        Text("\(category.name) - \(category.type.rawValue)").tag(category)
                    }
                } label: {
                    Text("Category")
                }

            }
            
            
            Section(header: Text("Account")) {
                Picker(selection: $viewModel.account) {
                    ForEach(viewModel.accounts) { account in
                        Text(account.name).tag(account)
                    }
                } label: {
                    Text("Account")
                }
            }
            
            Section(header: Text("Repeated transaction")) {
                Picker(selection: $viewModel.recurringType) {
                    ForEach(RecurringType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                } label: {
                    Text("Repeat transaction")
                }
                
                if viewModel.recurringType != .once {
                    VStack {
                        HStack {
                            Text("Every")
                            TextField("Frequency", text: $viewModel.recurringFrequencyString)
                                .multilineTextAlignment(.trailing)
                            Text("\(viewModel.recurringType.unit)")
                        }
                        !viewModel.recurringFrequencyValid ? Text("Frequency is required and must be numeric.")
                            .foregroundColor(.red)
                            .font(.system(size: 11))
                            .frame(maxWidth: .infinity, alignment: .trailing) : nil
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
                    viewModel.saveTransaction()
                    dismiss()
                }
                .disabled(
                    !viewModel.isFormValid
                )
                .fontWeight(.semibold)
            }
        }
        .onAppear {
            viewModel.category = viewModel.category ?? viewModel.categories.randomElement()
            viewModel.account = viewModel.account ?? viewModel.accounts.randomElement()
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
        EditTransactionView(transactionEdited: Transaction(amount: 24.0, date: .now, description: "Dinner", category: category, account: account), modelContext: container.mainContext)
            .modelContainer(container)
    }
}

#Preview("Create Transaction") {
    let container = PreviewContentData.generateContainer()
    
    return NavigationView {
        EditTransactionView(modelContext: container.mainContext)
            .modelContainer(container)
    }
}
