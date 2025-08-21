//
//  Gamification.swift
//  ExpenseTrackerApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 ExpenseTracker. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - Gamification System
struct GamificationSystem {
    
    // MARK: - Level Calculation
    static func calculateLevel(from points: Int) -> Int {
        // Cada nivel requiere más puntos: 100, 250, 450, 700, 1000...
        let basePoints = 100
        var level = 1
        var requiredPoints = basePoints
        var totalRequired = 0
        
        while totalRequired + requiredPoints <= points {
            totalRequired += requiredPoints
            level += 1
            requiredPoints += 50 * level
        }
        
        return level
    }
    
    static func pointsRequiredForNextLevel(currentPoints: Int) -> Int {
        let currentLevel = calculateLevel(from: currentPoints)
        let nextLevelPoints = pointsRequiredForLevel(currentLevel + 1)
        return nextLevelPoints - currentPoints
    }
    
    static func pointsRequiredForLevel(_ level: Int) -> Int {
        var totalPoints = 0
        for i in 1..<level {
            totalPoints += 100 + (50 * i)
        }
        return totalPoints
    }
}

// MARK: - Achievement Types
struct AchievementTemplate {
    let id: String
    let title: String
    let description: String
    let icon: String
    let pointsReward: Int
    let category: AchievementCategory
    let requirement: AchievementRequirement
}

// MARK: - Achievement Requirements
enum AchievementRequirement {
    case expenseCount(Int)
    case photoReceiptsCount(Int)
    case categoriesUsed(Int)
    case budgetNotExceeded(months: Int)
    case savingsGoal(amount: Double)
    case consecutiveDays(Int)
    case totalSpent(amount: Double)
    case levelReached(Int)
}

// MARK: - Predefined Achievements
extension AchievementTemplate {
    static let allAchievements: [AchievementTemplate] = [
        // Principiante
        AchievementTemplate(
            id: "first_expense",
            title: "Primer Gasto",
            description: "Registra tu primer gasto",
            icon: "star.fill",
            pointsReward: 50,
            category: .consistency,
            requirement: .expenseCount(1)
        ),
        
        AchievementTemplate(
            id: "photo_master",
            title: "Maestro de Fotos",
            description: "Toma 10 fotos de recibos",
            icon: "camera.fill",
            pointsReward: 200,
            category: .photoReceipts,
            requirement: .photoReceiptsCount(10)
        ),
        
        AchievementTemplate(
            id: "category_explorer",
            title: "Explorador de Categorías",
            description: "Usa 5 categorías diferentes",
            icon: "list.bullet",
            pointsReward: 150,
            category: .categories,
            requirement: .categoriesUsed(5)
        ),
        
        // Intermedio
        AchievementTemplate(
            id: "budget_keeper",
            title: "Guardián del Presupuesto",
            description: "No excedas tu presupuesto por 3 meses",
            icon: "shield.fill",
            pointsReward: 500,
            category: .budgetGoal,
            requirement: .budgetNotExceeded(months: 3)
        ),
        
        AchievementTemplate(
            id: "consistent_tracker",
            title: "Rastreador Consistente",
            description: "Registra gastos por 30 días consecutivos",
            icon: "calendar",
            pointsReward: 300,
            category: .consistency,
            requirement: .consecutiveDays(30)
        ),
        
        // Avanzado
        AchievementTemplate(
            id: "savings_hero",
            title: "Héroe del Ahorro",
            description: "Ahorra $1000 en un mes",
            icon: "dollarsign.circle.fill",
            pointsReward: 1000,
            category: .savings,
            requirement: .savingsGoal(amount: 1000)
        ),
        
        AchievementTemplate(
            id: "expense_master",
            title: "Maestro de Gastos",
            description: "Registra 100 gastos",
            icon: "crown.fill",
            pointsReward: 750,
            category: .consistency,
            requirement: .expenseCount(100)
        )
    ]
}

// MARK: - Streak System
struct StreakSystem {
    static func calculateStreak(expenses: [Expense]) -> Int {
        guard !expenses.isEmpty else { return 0 }
        
        let sortedExpenses = expenses.sorted { $0.date > $1.date }
        let calendar = Calendar.current
        let today = Date()
        
        var streak = 0
        var currentDate = today
        
        for expense in sortedExpenses {
            if calendar.isDate(expense.date, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
}

// MARK: - Reward System
struct Reward: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let cost: Int // Puntos necesarios
    let icon: String
    let category: RewardCategory
    let isUnlocked: Bool
    let dateUnlocked: Date?
    
    init(title: String, description: String, cost: Int, icon: String, category: RewardCategory) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.cost = cost
        self.icon = icon
        self.category = category
        self.isUnlocked = false
        self.dateUnlocked = nil
    }
}

// MARK: - Reward Categories
enum RewardCategory: String, CaseIterable, Codable {
    case themes = "themes"
    case features = "features"
    case badges = "badges"
    
    var displayName: String {
        switch self {
        case .themes: return "Temas"
        case .features: return "Características"
        case .badges: return "Insignias"
        }
    }
}

// MARK: - Challenge System
struct Challenge: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let goal: ChallengeGoal
    let reward: Int
    let duration: Int // Días
    let startDate: Date
    let endDate: Date
    var isCompleted: Bool
    var progress: Double // 0.0 - 1.0
    
    init(title: String, description: String, goal: ChallengeGoal, reward: Int, duration: Int) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.goal = goal
        self.reward = reward
        self.duration = duration
        self.startDate = Date()
        self.endDate = Calendar.current.date(byAdding: .day, value: duration, to: Date()) ?? Date()
        self.isCompleted = false
        self.progress = 0.0
    }
    
    var isActive: Bool {
        let now = Date()
        return now >= startDate && now <= endDate && !isCompleted
    }
    
    var daysRemaining: Int {
        let calendar = Calendar.current
        return max(0, calendar.dateComponents([.day], from: Date(), to: endDate).day ?? 0)
    }
}

// MARK: - Challenge Goals
enum ChallengeGoal: Codable {
    case spendLessThan(amount: Double)
    case saveAmount(amount: Double)
    case usePhotoReceipts(count: Int)
    case stayWithinBudget
    case trackConsecutiveDays(days: Int)
}
