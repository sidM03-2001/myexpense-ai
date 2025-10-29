//
//  ExpenseReport.swift
//  MyExpense
//
//  Model for expense reports and analytics
//

import Foundation

struct ExpenseReport {
    let period: DateRange
    let totalExpenses: Double
    let categoryBreakdown: [CategorySummary]
    let dailyExpenses: [DailyExpense]
    
    struct CategorySummary: Identifiable {
        let id = UUID()
        let category: ExpenseCategory
        let total: Double
        let percentage: Double
        let count: Int
    }
    
    struct DailyExpense: Identifiable {
        let id = UUID()
        let date: Date
        let total: Double
    }
    
    enum DateRange {
        case today
        case week
        case month
        case year
        case custom(start: Date, end: Date)
    }
}

