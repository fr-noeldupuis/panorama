//
//  AccountListRowView.swift
//  panorama
//
//  Created by Noel Dupuis on 27/11/2024.
//
import SwiftUI

struct AccountListRowView: View {
    
    var account: Account
    
    var body: some View {
        let amount = account.transactions.reduce(0) {
            $0 + $1.amount
        }

        ZStack {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 56, height: 48)
                        .foregroundColor(.blue)
                        .opacity(0.5)
                    Image(systemName: account.iconName)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading) {
                    Text(account.name)
                }
                Spacer()
                Text("\(formatAmountToString(amount: amount)) €")
                    .foregroundColor(amount < 0 ? .red : .green)
                    .font(.headline)
            }
            NavigationLink(destination: EditAccountView(editedAccount: account)) {
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
        ForEach(PreviewContentData.accountsExample) {account in
            AccountListRowView(account: account)
        }
    }
    
}
