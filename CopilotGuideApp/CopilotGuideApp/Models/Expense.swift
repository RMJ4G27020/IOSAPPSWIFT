//
//  Expense.swift
//  ExpenseTrackerApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 ExpenseTracker. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - Expense Model
struct Expense: Identifiable, Codable {
    let id: UUID
    var amount: Double
    var category: ExpenseCategory
    var description: String
    var date: Date
    var receiptImage: String? // URL o nombre del archivo
    var location: String?
    var tags: [String]
    var isRecurring: Bool
    var recurringFrequency: RecurringFrequency?
    
    init(amount: Double, category: ExpenseCategory, description: String, location: String? = nil) {
        self.id = UUID()
        self.amount = amount
        self.category = category
        self.description = description
        self.date = Date()
        self.receiptImage = nil
        self.location = location
        self.tags = []
        self.isRecurring = false
        self.recurringFrequency = nil
    }
}

// MARK: - Expense Categories
enum ExpenseCategory: String, CaseIterable, Codable {
    case food = "food"
    case transport = "transport"
    case shopping = "shopping"
    case entertainment = "entertainment"
    case health = "health"
    case utilities = "utilities"
    case education = "education"
    case travel = "travel"
    case home = "home"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .food: return "Comida"
        case .transport: return "Transporte"
        case .shopping: return "Compras"
        case .entertainment: return "Entretenimiento"
        case .health: return "Salud"
        case .utilities: return "Servicios"
        case .education: return "Educación"
        case .travel: return "Viajes"
        case .home: return "Hogar"
        case .other: return "Otros"
        }
    }
    
    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .shopping: return "bag.fill"
        case .entertainment: return "gamecontroller.fill"
        case .health: return "heart.fill"
        case .utilities: return "bolt.fill"
        case .education: return "book.fill"
        case .travel: return "airplane"
        case .home: return "house.fill"
        case .other: return "questionmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .food: return .orange
        case .transport: return .blue
        case .shopping: return .purple
        case .entertainment: return .pink
        case .health: return .red
        case .utilities: return .yellow
        case .education: return .green
        case .travel: return .teal
        case .home: return .brown
        case .other: return .gray
        }
    }
}

// MARK: - Budget Model
struct Budget: Identifiable, Codable {
    let id: UUID
    var category: ExpenseCategory
    var monthlyLimit: Double
    var currentSpent: Double
    var alertThreshold: Double // Porcentaje (0.0 - 1.0)
    var isActive: Bool
    var createdAt: Date
    
    init(category: ExpenseCategory, monthlyLimit: Double, alertThreshold: Double = 0.8) {
        self.id = UUID()
        self.category = category
        self.monthlyLimit = monthlyLimit
        self.currentSpent = 0.0
        self.alertThreshold = alertThreshold
        self.isActive = true
        self.createdAt = Date()
    }
    
    var remainingBudget: Double {
        return max(0, monthlyLimit - currentSpent)
    }
    
    var spentPercentage: Double {
        guard monthlyLimit > 0 else { return 0 }
        return min(1.0, currentSpent / monthlyLimit)
    }
    
    var isOverBudget: Bool {
        return currentSpent > monthlyLimit
    }
    
    var shouldAlert: Bool {
        return spentPercentage >= alertThreshold
    }
}

// MARK: - Recurring Frequency
enum RecurringFrequency: String, CaseIterable, Codable {
    case daily = "daily"
    case weekly = "weekly"
    case monthly = "monthly"
    case yearly = "yearly"
    
    var displayName: String {
        switch self {
        case .daily: return "Diario"
        case .weekly: return "Semanal"
        case .monthly: return "Mensual"
        case .yearly: return "Anual"
        }
    }
}

// MARK: - Receipt Model
struct Receipt: Identifiable, Codable {
    let id: UUID
    var imagePath: String
    var extractedText: String?
    var detectedAmount: Double?
    var detectedMerchant: String?
    var processingStatus: ReceiptProcessingStatus
    var createdAt: Date
    var linkedExpenseId: UUID?
    
    init(imagePath: String) {
        self.id = UUID()
        self.imagePath = imagePath
        self.extractedText = nil
        self.detectedAmount = nil
        self.detectedMerchant = nil
        self.processingStatus = .pending
        self.createdAt = Date()
        self.linkedExpenseId = nil
    }
}

// MARK: - Receipt Processing Status
enum ReceiptProcessingStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case processing = "processing"
    case completed = "completed"
    case failed = "failed"
    
    var displayName: String {
        switch self {
        case .pending: return "Pendiente"
        case .processing: return "Procesando"
        case .completed: return "Completado"
        case .failed: return "Falló"
        }
    }
}
