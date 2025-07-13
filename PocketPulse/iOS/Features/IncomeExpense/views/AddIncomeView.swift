//
//  IncomeExpense.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftUI
import SwiftData

struct AddIncomeView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = AddIncomeViewModel()
    @Query private var accounts: [AccountModel]

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Income Info")) {
                    TextField("Title", text: $viewModel.title)
                    TextField("Amount", text: $viewModel.amount)
                        .keyboardType(.decimalPad)

                    Picker("Category", selection: $viewModel.category) {
                        ForEach(TransactionCategory.allCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }

                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                }

                Section(header: Text("Select Account")) {
                    Picker("Account", selection: $viewModel.selectedAccount) {
                        ForEach(accounts, id: \.id) { account in
                            Text("\(account.name) • \(account.type.rawValue.capitalized)")
                                .tag(account as AccountModel?)
                        }
                    }
                }

                Section {
                    Button("Save") {
                        if !viewModel.validateAccountExistence(context: context) {
                            alertMessage = "Please add an account or card before adding income."
                            showAlert = true
                            return
                        }

                        if viewModel.addIncome(context: context) {
                            viewModel.reset()
                            dismiss()
                        } else {
                            alertMessage = "Please fill all fields correctly."
                            showAlert = true
                        }
                    }
                }
            }
            .navigationTitle("Add Income")
            .alert("Alert", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}
