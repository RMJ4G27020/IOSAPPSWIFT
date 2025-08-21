//
//  TodoViewModel.swift
//  CopilotGuideApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 CopilotGuide. All rights reserved.
//

import SwiftUI
import Combine

@MainActor
class TodoViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingError = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadSampleTasks()
    }
    
    // MARK: - Public Methods
    func addTask(_ task: Task) {
        withAnimation(.easeInOut) {
            tasks.append(task)
            sortTasksByPriority()
        }
    }
    
    func deleteTasks(at indexSet: IndexSet) {
        withAnimation(.easeInOut) {
            tasks.remove(atOffsets: indexSet)
        }
    }
    
    func toggleTaskCompletion(_ task: Task) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        
        withAnimation(.easeInOut) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func updateTask(_ updatedTask: Task) {
        guard let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) else { return }
        
        withAnimation(.easeInOut) {
            tasks[index] = updatedTask
            sortTasksByPriority()
        }
    }
    
    func loadTasks() async {
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        tasks = Task.sampleTasks
        sortTasksByPriority()
        
        isLoading = false
    }
    
    // MARK: - Computed Properties
    var completedTasksCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var pendingTasksCount: Int {
        tasks.filter { !$0.isCompleted }.count
    }
    
    var overdueTasks: [Task] {
        tasks.filter { $0.isOverdue }
    }
    
    var highPriorityTasks: [Task] {
        tasks.filter { $0.priority == .high && !$0.isCompleted }
    }
    
    // MARK: - Private Methods
    private func loadSampleTasks() {
        tasks = Task.sampleTasks
        sortTasksByPriority()
    }
    
    private func sortTasksByPriority() {
        tasks.sort { task1, task2 in
            // First sort by completion status (incomplete first)
            if task1.isCompleted != task2.isCompleted {
                return !task1.isCompleted
            }
            
            // Then by priority (high first)
            if task1.priority.sortOrder != task2.priority.sortOrder {
                return task1.priority.sortOrder > task2.priority.sortOrder
            }
            
            // Finally by due date (earliest first)
            switch (task1.dueDate, task2.dueDate) {
            case (let date1?, let date2?):
                return date1 < date2
            case (nil, _?):
                return false
            case (_?, nil):
                return true
            case (nil, nil):
                return task1.createdAt < task2.createdAt
            }
        }
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showingError = true
    }
}

// MARK: - Task Statistics Extension
extension TodoViewModel {
    var taskStatistics: TaskStatistics {
        TaskStatistics(
            total: tasks.count,
            completed: completedTasksCount,
            pending: pendingTasksCount,
            overdue: overdueTasks.count,
            highPriority: highPriorityTasks.count
        )
    }
    
    struct TaskStatistics {
        let total: Int
        let completed: Int
        let pending: Int
        let overdue: Int
        let highPriority: Int
        
        var completionPercentage: Double {
            guard total > 0 else { return 0 }
            return Double(completed) / Double(total) * 100
        }
    }
}
