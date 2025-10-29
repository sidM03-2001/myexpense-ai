//
//  ExpenseDetailView.swift
//  MyExpense
//
//  View for displaying expense details
//

import SwiftUI

struct ExpenseDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let expense: Expense
    @ObservedObject var expenseService: ExpenseService
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        Image(systemName: expense.category.icon)
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(Color.blue.gradient)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(expense.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(expense.category.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(formatCurrency(expense.amount))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    Divider()
                    
                    // Details
                    VStack(alignment: .leading, spacing: 16) {
                        DetailRow(title: "Date", value: expense.date.formatted(date: .long, time: .omitted))
                        DetailRow(title: "Payment Method", value: expense.paymentMethod.rawValue)
                        
                        if !expense.notes.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Text(expense.notes)
                                    .font(.body)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationTitle("Expense Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}

