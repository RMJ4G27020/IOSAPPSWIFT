//
//  UserManagementViewModel.swift
//  CopilotGuideApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 CopilotGuide. All rights reserved.
//

import SwiftUI
import Combine

@MainActor
class UserManagementViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingError = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadMockUsers()
    }
    
    // MARK: - Public Methods
    func loadUsers() async {
        isLoading = true
        errorMessage = nil
        
        // Simulate API call delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // In a real app, this would be an API call
        users = User.sampleUsers
        
        isLoading = false
    }
    
    func addUser(_ user: User) async {
        // Simulate API call
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        withAnimation(.easeInOut) {
            users.append(user)
        }
    }
    
    func deleteUsers(at indexSet: IndexSet) {
        withAnimation(.easeInOut) {
            users.remove(atOffsets: indexSet)
        }
    }
    
    func toggleUserStatus(at index: Int) {
        guard index < users.count else { return }
        
        withAnimation(.easeInOut) {
            users[index].isActive.toggle()
        }
    }
    
    func refreshUsers() async {
        await loadUsers()
    }
    
    // MARK: - Private Methods
    private func loadMockUsers() {
        users = User.sampleUsers
    }
}

// MARK: - User Sample Data Extension
extension User {
    static var sampleUsers: [User] {
        [
            User(name: "Ana García", email: "ana.garcia@example.com", isActive: true),
            User(name: "Carlos López", email: "carlos.lopez@example.com", isActive: true),
            User(name: "María Rodríguez", email: "maria.rodriguez@example.com", isActive: false),
            User(name: "David Martín", email: "david.martin@example.com", isActive: true),
            User(name: "Laura Fernández", email: "laura.fernandez@example.com", isActive: true),
            User(name: "Miguel Santos", email: "miguel.santos@example.com", isActive: false)
        ]
    }
}
