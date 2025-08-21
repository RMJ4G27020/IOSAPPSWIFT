//
//  Task.swift
//  CopilotGuideApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 CopilotGuide. All rights reserved.
//

import SwiftUI
import Foundation

// MARK: - Task Model
struct Task: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var description: String
    var isCompleted: Bool
    var priority: Priority
    var dueDate: Date?
    var createdAt: Date
    var assignedUserId: UUID?
    
    init(title: String, description: String, priority: Priority = .medium, dueDate: Date? = nil, assignedUserId: UUID? = nil) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.isCompleted = false
        self.priority = priority
        self.dueDate = dueDate
        self.createdAt = Date()
        self.assignedUserId = assignedUserId
    }
    
    // MARK: - Priority Enum
    enum Priority: String, CaseIterable, Codable {
        case low = "low"
        case medium = "medium"
        case high = "high"
        
        var displayName: String {
            switch self {
            case .low: return "Baja"
            case .medium: return "Media"
            case .high: return "Alta"
            }
        }
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .orange
            case .high: return .red
            }
        }
        
        var sortOrder: Int {
            switch self {
            case .high: return 3
            case .medium: return 2
            case .low: return 1
            }
        }
    }
}

// MARK: - Task Extensions
extension Task {
    var isOverdue: Bool {
        guard let dueDate = dueDate else { return false }
        return !isCompleted && dueDate < Date()
    }
    
    var formattedDueDate: String? {
        guard let dueDate = dueDate else { return nil }
        return DateFormatter.medium.string(from: dueDate)
    }
    
    static var sampleTasks: [Task] {
        [
            Task(
                title: "Diseñar interfaz de usuario",
                description: "Crear mockups y prototipos para la nueva pantalla de configuración",
                priority: .high,
                dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())
            ),
            Task(
                title: "Implementar API REST",
                description: "Desarrollar endpoints para el CRUD de usuarios",
                priority: .medium,
                dueDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())
            ),
            Task(
                title: "Escribir tests unitarios",
                description: "Crear tests para los ViewModels principales",
                priority: .low,
                dueDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())
            ),
            Task(
                title: "Actualizar documentación",
                description: "Revisar y actualizar el README del proyecto",
                priority: .medium
            )
        ]
    }
}
