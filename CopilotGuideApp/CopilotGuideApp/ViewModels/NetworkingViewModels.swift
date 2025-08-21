//
//  NetworkingViewModels.swift
//  CopilotGuideApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 CopilotGuide. All rights reserved.
//

import SwiftUI
import Combine

// MARK: - Posts Feed ViewModel
@MainActor
class PostsFeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var users: [APIUser] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingError = false
    
    private let networkService = NetworkService.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Methods
    func loadData() async {
        isLoading = true
        errorMessage = nil
        showingError = false
        
        do {
            async let postsTask = networkService.fetchPosts()
            async let usersTask = networkService.fetchUsers()
            
            posts = try await postsTask
            users = try await usersTask
            
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    func refreshData() async {
        await loadData()
    }
    
    func getUserName(for userId: Int) -> String {
        users.first { $0.id == userId }?.name ?? "Usuario desconocido"
    }
    
    // MARK: - Private Methods
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showingError = true
    }
}

// MARK: - User Profiles ViewModel
@MainActor
class UserProfilesViewModel: ObservableObject {
    @Published var users: [APIUser] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingError = false
    
    private let networkService = NetworkService.shared
    
    // MARK: - Public Methods
    func loadUsers() async {
        isLoading = true
        errorMessage = nil
        showingError = false
        
        do {
            users = try await networkService.fetchUsers()
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    func refreshUsers() async {
        await loadUsers()
    }
    
    // MARK: - Private Methods
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showingError = true
    }
}

// MARK: - Image Gallery ViewModel
@MainActor
class ImageGalleryViewModel: ObservableObject {
    @Published var images: [Photo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingError = false
    
    private let networkService = NetworkService.shared
    
    // MARK: - Public Methods
    func loadImages() async {
        isLoading = true
        errorMessage = nil
        showingError = false
        
        do {
            images = try await networkService.fetchPhotos()
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    func refreshImages() async {
        await loadImages()
    }
    
    // MARK: - Private Methods
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showingError = true
    }
}
