//
//  MainTabView.swift
//  MyExpense
//
//  Main tab bar view for the app
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ExpenseListView()
                .tabItem {
                    Label("Expenses", systemImage: "list.bullet")
                }
            
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct DashboardView: View {
    @StateObject private var expenseService = ExpenseService()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Summary Cards
                    HStack(spacing: 16) {
                        SummaryCard(
                            title: "This Month",
                            amount: expenseService.getTotalExpenses(period: .month),
                            icon: "calendar",
                            color: .blue
                        )
                        
                        SummaryCard(
                            title: "This Week",
                            amount: expenseService.getTotalExpenses(period: .week),
                            icon: "clock",
                            color: .green
                        )
                    }
                    .padding(.horizontal)
                    
                    // Category Breakdown
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Category Breakdown")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ForEach(expenseService.getCategoryBreakdown(period: .month)) { summary in
                            CategoryRow(summary: summary)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct SummaryCard: View {
    let title: String
    let amount: Double
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(formatCurrency(amount))
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

struct CategoryRow: View {
    let summary: ExpenseReport.CategorySummary
    
    var body: some View {
        HStack {
            Image(systemName: summary.category.icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            Text(summary.category.rawValue)
                .font(.body)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(formatCurrency(summary.total))
                    .font(.headline)
                
                Text("\(summary.count) expenses")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section("General") {
                    Label("Categories", systemImage: "folder")
                    Label("Payment Methods", systemImage: "creditcard")
                }
                
                Section("Data") {
                    Label("Export Data", systemImage: "square.and.arrow.up")
                    Label("Backup", systemImage: "icloud.and.arrow.up")
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

