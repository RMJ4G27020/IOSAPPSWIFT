//
//  ExpenseListView.swift
//  ExpenseTrackerApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 ExpenseTracker. All rights reserved.
//

import SwiftUI

struct ExpenseListView: View {
    @EnvironmentObject var viewModel: ExpenseTrackerViewModel
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header con resumen del mes
                monthSummaryCard
                
                // Lista de gastos
                expensesList
            }
            .navigationTitle("Mis Gastos")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddExpense = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.copilotBlue)
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView()
                    .environmentObject(viewModel)
            }
        }
    }
    
    // MARK: - Month Summary Card
    private var monthSummaryCard: some View {
        VStack(spacing: 12) {
            // Mes actual
            Text(viewModel.monthYearString(from: viewModel.selectedMonth))
                .font(.headline)
                .foregroundColor(.primaryText)
            
            // Total gastado
            Text(viewModel.formatCurrency(viewModel.totalExpensesThisMonth))
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.copilotBlue)
            
            // Presupuesto restante
            if let budget = viewModel.userProfile?.monthlyBudget {
                let remaining = budget - viewModel.totalExpensesThisMonth
                Text("Restante: \(viewModel.formatCurrency(remaining))")
                    .font(.caption)
                    .foregroundColor(remaining >= 0 ? .green : .red)
            }
        }
        .padding()
        .modernCardStyle()
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    // MARK: - Expenses List
    private var expensesList: some View {
        List {
            // Filtros
            filterSection
            
            // Gastos
            ForEach(viewModel.filteredExpenses) { expense in
                ExpenseRowView(expense: expense)
                    .environmentObject(viewModel)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowSeparator(.hidden)
            }
            .onDelete(perform: viewModel.deleteExpense)
        }
        .listStyle(PlainListStyle())
        .refreshable {
            // Refresh data
        }
    }
    
    // MARK: - Filter Section
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                // Botón "Todas"
                FilterChip(
                    title: "Todas",
                    isSelected: viewModel.selectedCategory == nil
                ) {
                    viewModel.selectedCategory = nil
                }
                
                // Chips de categorías
                ForEach(ExpenseCategory.allCases, id: \.self) { category in
                    FilterChip(
                        title: category.displayName,
                        isSelected: viewModel.selectedCategory == category,
                        color: category.color
                    ) {
                        viewModel.selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
}

// MARK: - Expense Row View
struct ExpenseRowView: View {
    let expense: Expense
    @EnvironmentObject var viewModel: ExpenseTrackerViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            // Icono de categoría
            Image(systemName: expense.category.icon)
                .font(.title2)
                .foregroundColor(expense.category.color)
                .frame(width: 40, height: 40)
                .background(expense.category.color.opacity(0.1))
                .clipShape(Circle())
            
            // Información del gasto
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(expense.description)
                        .font(.headline)
                        .foregroundColor(.primaryText)
                    
                    Spacer()
                    
                    Text(viewModel.formatCurrency(expense.amount))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryText)
                }
                
                HStack {
                    Text(expense.category.displayName)
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                    
                    Spacer()
                    
                    Text(expense.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                }
                
                // Tags y ubicación
                if !expense.tags.isEmpty || expense.location != nil {
                    HStack {
                        if let location = expense.location {
                            Label(location, systemImage: "location")
                                .font(.caption2)
                                .foregroundColor(.secondaryText)
                        }
                        
                        ForEach(expense.tags.prefix(2), id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            
            // Indicador de foto
            if expense.receiptImage != nil {
                Image(systemName: "camera.fill")
                    .font(.caption)
                    .foregroundColor(.copilotBlue)
            }
        }
        .padding()
        .modernCardStyle()
        .accessibleCard(
            label: "\(expense.description), \(viewModel.formatCurrency(expense.amount))",
            hint: "Gasto en \(expense.category.displayName)"
        )
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    var color: Color = .copilotBlue
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .medium)
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isSelected ? color : color.opacity(0.1))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationView {
        ExpenseListView()
            .environmentObject(ExpenseTrackerViewModel())
    }
}
