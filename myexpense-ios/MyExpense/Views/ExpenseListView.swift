//
//  ExpenseListView.swift
//  MyExpense
//
//  Main view displaying list of expenses
//

import SwiftUI

struct ExpenseListView: View {
    @StateObject private var expenseService = ExpenseService()
    @State private var showingAddExpense = false
    @State private var selectedExpense: Expense?
    
    var body: some View {
        NavigationView {
            VStack {
                if expenseService.expenses.isEmpty {
                    emptyStateView
                } else {
                    expenseList
                }
            }
            .navigationTitle("My Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddExpense = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView(expenseService: expenseService)
            }
            .sheet(item: $selectedExpense) { expense in
                ExpenseDetailView(expense: expense, expenseService: expenseService)
            }
        }
    }
    
    // MARK: - Subviews
    
    private var expenseList: some View {
        List {
            ForEach(expenseService.expenses.sorted(by: { $0.date > $1.date })) { expense in
                ExpenseRowView(expense: expense)
                    .onTapGesture {
                        selectedExpense = expense
                    }
            }
            .onDelete(perform: expenseService.deleteExpense)
        }
        .listStyle(.plain)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Expenses Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap the + button to add your first expense")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - Expense Row View

struct ExpenseRowView: View {
    let expense: Expense
    
    var body: some View {
        HStack(spacing: 12) {
            // Category Icon
            Image(systemName: expense.category.icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Color.blue.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Expense Details
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.title)
                    .font(.headline)
                
                HStack {
                    Text(expense.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(expense.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Amount
            Text(formatCurrency(expense.amount))
                .font(.headline)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 8)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

