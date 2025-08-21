//
//  ExpenseTrackerViewModel.swift
//  ExpenseTrackerApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 ExpenseTracker. All rights reserved.
//

import SwiftUI
import Combine
import PhotosUI

@MainActor
class ExpenseTrackerViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var expenses: [Expense] = []
    @Published var budgets: [Budget] = []
    @Published var userProfile: UserProfile?
    @Published var selectedMonth = Date()
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingError = false
    
    // UI State
    @Published var showingAddExpense = false
    @Published var selectedExpense: Expense?
    @Published var selectedImageItem: PhotosPickerItem?
    @Published var capturedImage: UIImage?
    
    // Filtering
    @Published var selectedCategory: ExpenseCategory?
    @Published var searchText = ""
    
    // MARK: - Computed Properties
    var filteredExpenses: [Expense] {
        let calendar = Calendar.current
        var filtered = expenses.filter { expense in
            calendar.isDate(expense.date, equalTo: selectedMonth, toGranularity: .month)
        }
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { expense in
                expense.description.localizedCaseInsensitiveContains(searchText) ||
                expense.category.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted { $0.date > $1.date }
    }
    
    var totalExpensesThisMonth: Double {
        filteredExpenses.reduce(0) { $0 + $1.amount }
    }
    
    var expensesByCategory: [ExpenseCategory: Double] {
        var categoryTotals: [ExpenseCategory: Double] = [:]
        
        for expense in filteredExpenses {
            categoryTotals[expense.category, default: 0] += expense.amount
        }
        
        return categoryTotals
    }
    
    var budgetStatus: [Budget] {
        return budgets.map { budget in
            var updatedBudget = budget
            updatedBudget.currentSpent = expensesByCategory[budget.category] ?? 0
            return updatedBudget
        }
    }
    
    // MARK: - Initialization
    init() {
        loadData()
        setupMockData()
    }
    
    // MARK: - Expense Management
    func addExpense(_ expense: Expense) {
        withAnimation(.easeInOut) {
            expenses.append(expense)
        }
        updateBudgets()
        saveData()
        awardPointsForExpense()
    }
    
    func updateExpense(_ expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            withAnimation(.easeInOut) {
                expenses[index] = expense
            }
            updateBudgets()
            saveData()
        }
    }
    
    func deleteExpense(_ expense: Expense) {
        withAnimation(.easeInOut) {
            expenses.removeAll { $0.id == expense.id }
        }
        updateBudgets()
        saveData()
    }
    
    func deleteExpense(at indexSet: IndexSet) {
        withAnimation(.easeInOut) {
            for index in indexSet {
                let expense = filteredExpenses[index]
                expenses.removeAll { $0.id == expense.id }
            }
        }
        updateBudgets()
        saveData()
    }
    
    // MARK: - Budget Management
    func addBudget(_ budget: Budget) {
        budgets.append(budget)
        saveData()
    }
    
    func updateBudget(_ budget: Budget) {
        if let index = budgets.firstIndex(where: { $0.id == budget.id }) {
            budgets[index] = budget
            saveData()
        }
    }
    
    func deleteBudget(_ budget: Budget) {
        budgets.removeAll { $0.id == budget.id }
        saveData()
    }
    
    private func updateBudgets() {
        let calendar = Calendar.current
        for i in budgets.indices {
            let categoryExpenses = expenses.filter { expense in
                expense.category == budgets[i].category &&
                calendar.isDate(expense.date, equalTo: selectedMonth, toGranularity: .month)
            }
            budgets[i].currentSpent = categoryExpenses.reduce(0) { $0 + $1.amount }
        }
    }
    
    // MARK: - Photo Receipt Processing
    func processPhotoReceipt(_ image: UIImage) async {
        isLoading = true
        
        // Simular procesamiento de imagen con Vision/OCR
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000) // 2 segundos
            
            // Mock de extracción de datos
            let mockAmount = Double.random(in: 5.0...100.0)
            let mockMerchant = ["Walmart", "Target", "Starbucks", "McDonald's"].randomElement() ?? "Tienda"
            let mockCategory = ExpenseCategory.allCases.randomElement() ?? .other
            
            let newExpense = Expense(
                amount: mockAmount,
                category: mockCategory,
                description: "Compra en \(mockMerchant)",
                location: mockMerchant
            )
            
            // TODO: Guardar imagen y asociarla al gasto
            addExpense(newExpense)
            awardPointsForPhotoReceipt()
            
        } catch {
            errorMessage = "Error al procesar la imagen: \(error.localizedDescription)"
            showingError = true
        }
        
        isLoading = false
    }
    
    // MARK: - Data Persistence
    private func saveData() {
        // TODO: Implementar CoreData o UserDefaults
        print("💾 Datos guardados")
    }
    
    private func loadData() {
        // TODO: Cargar datos persistidos
        print("📖 Datos cargados")
    }
    
    // MARK: - Gamification
    private func awardPointsForExpense() {
        guard var profile = userProfile else { return }
        
        let points = 10
        profile.totalPoints += points
        profile.gamificationLevel = GamificationSystem.calculateLevel(from: profile.totalPoints)
        
        userProfile = profile
        
        // Verificar logros
        checkAchievements()
    }
    
    private func awardPointsForPhotoReceipt() {
        guard var profile = userProfile else { return }
        
        let points = 25 // Más puntos por usar foto
        profile.totalPoints += points
        profile.gamificationLevel = GamificationSystem.calculateLevel(from: profile.totalPoints)
        
        userProfile = profile
        checkAchievements()
    }
    
    private func checkAchievements() {
        guard var profile = userProfile else { return }
        
        // Verificar logro de primer gasto
        if expenses.count == 1 && !profile.achievements.contains(where: { $0.title == "Primer Gasto" }) {
            let achievement = Achievement(
                title: "Primer Gasto",
                description: "Has registrado tu primer gasto",
                icon: "star.fill",
                pointsReward: 50,
                category: .consistency
            )
            profile.achievements.append(achievement)
            profile.totalPoints += achievement.pointsReward
        }
        
        userProfile = profile
    }
    
    // MARK: - Mock Data
    private func setupMockData() {
        // Usuario de ejemplo
        userProfile = UserProfile(
            name: "Usuario Demo",
            email: "demo@example.com",
            monthlyBudget: 2000.0
        )
        
        // Presupuestos de ejemplo
        budgets = [
            Budget(category: .food, monthlyLimit: 500.0),
            Budget(category: .transport, monthlyLimit: 300.0),
            Budget(category: .entertainment, monthlyLimit: 200.0),
            Budget(category: .shopping, monthlyLimit: 400.0)
        ]
        
        // Gastos de ejemplo
        let sampleExpenses = [
            Expense(amount: 45.50, category: .food, description: "Supermercado", location: "Walmart"),
            Expense(amount: 12.00, category: .transport, description: "Uber", location: "Centro"),
            Expense(amount: 25.99, category: .entertainment, description: "Cine", location: "Cineplex"),
            Expense(amount: 89.00, category: .shopping, description: "Ropa", location: "Zara")
        ]
        
        expenses = sampleExpenses
        updateBudgets()
    }
    
    // MARK: - Utility Methods
    func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = userProfile?.currency.rawValue ?? "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: date)
    }
}
