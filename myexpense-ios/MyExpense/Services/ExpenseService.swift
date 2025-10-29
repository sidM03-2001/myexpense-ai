//
//  ExpenseService.swift
//  MyExpense
//
//  Service layer for managing expenses
//

import Foundation
import Combine

class ExpenseService: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var isLoading = false
    
    private let storageKey = "saved_expenses"
    
    init() {
        loadExpenses()
    }
    
    // MARK: - CRUD Operations
    
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
        saveExpenses()
    }
    
    func updateExpense(_ expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
            saveExpenses()
        }
    }
    
    func deleteExpense(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
        saveExpenses()
    }
    
    func deleteExpense(atOffsets offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
        saveExpenses()
    }
    
    // MARK: - Analytics
    
    func getTotalExpenses(period: ExpenseReport.DateRange = .month) -> Double {
        let filteredExpenses = filterExpenses(by: period)
        return filteredExpenses.reduce(0) { $0 + $1.amount }
    }
    
    func getCategoryBreakdown(period: ExpenseReport.DateRange = .month) -> [ExpenseReport.CategorySummary] {
        let filteredExpenses = filterExpenses(by: period)
        let total = getTotalExpenses(period: period)
        
        let grouped = Dictionary(grouping: filteredExpenses) { $0.category }
        
        return grouped.map { (category, expenses) in
            let categoryTotal = expenses.reduce(0) { $0 + $1.amount }
            let percentage = total > 0 ? (categoryTotal / total) * 100 : 0
            return ExpenseReport.CategorySummary(
                category: category,
                total: categoryTotal,
                percentage: percentage,
                count: expenses.count
            )
        }.sorted { $0.total > $1.total }
    }
    
    // MARK: - Helper Methods
    
    private func filterExpenses(by period: ExpenseReport.DateRange) -> [Expense] {
        let calendar = Calendar.current
        let now = Date()
        
        let startDate: Date
        switch period {
        case .today:
            startDate = calendar.startOfDay(for: now)
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        case .custom(let start, _):
            startDate = start
        }
        
        return expenses.filter { $0.date >= startDate }
    }
    
    // MARK: - Persistence
    
    private func saveExpenses() {
        if let encoded = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadExpenses() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Expense].self, from: data) {
            expenses = decoded
        }
    }
}

