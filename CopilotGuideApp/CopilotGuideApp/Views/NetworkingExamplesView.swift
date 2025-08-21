//
//  NetworkingExamplesView.swift
//  CopilotGuideApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 CopilotGuide. All rights reserved.
//

import SwiftUI

struct NetworkingExamplesView: View {
    var body: some View {
        NavigationView {
            List {
                Section("API Examples") {
                    NavigationLink("Posts Feed", destination: PostsFeedView())
                    NavigationLink("User Profiles", destination: UserProfilesView())
                    NavigationLink("Image Gallery", destination: ImageGalleryView())
                }
                
                Section("Advanced Networking") {
                    NavigationLink("Real-time Data", destination: RealTimeDataView())
                    NavigationLink("File Upload", destination: FileUploadView())
                    NavigationLink("Offline Support", destination: OfflineSupportView())
                }
            }
            .navigationTitle("Networking")
        }
    }
}

// MARK: - Posts Feed
struct PostsFeedView: View {
    @StateObject private var viewModel = PostsFeedViewModel()
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            if viewModel.isLoading && viewModel.posts.isEmpty {
                ProgressView("Cargando posts...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(filteredPosts) { post in
                    PostRowView(
                        post: post,
                        userName: viewModel.getUserName(for: post.userId)
                    ) {
                        // Navigate to post detail
                    }
                }
                .refreshable {
                    await viewModel.refreshData()
                }
            }
        }
        .navigationTitle("Posts")
        .searchable(text: $searchText, prompt: "Buscar posts...")
        .task {
            if viewModel.posts.isEmpty {
                await viewModel.loadData()
            }
        }
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK") { }
            Button("Reintentar") {
                Task {
                    await viewModel.loadData()
                }
            }
        } message: {
            Text(viewModel.errorMessage ?? "Error desconocido")
        }
    }
    
    private var filteredPosts: [Post] {
        if searchText.isEmpty {
            return viewModel.posts
        } else {
            return viewModel.posts.filter { post in
                post.title.localizedCaseInsensitiveContains(searchText) ||
                post.body.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

struct PostRowView: View {
    let post: Post
    let userName: String
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Post title
            Text(post.title)
                .font(.headline)
                .lineLimit(2)
            
            // Post excerpt
            Text(post.body)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            // User info
            HStack {
                Image(systemName: "person.circle")
                    .foregroundColor(.blue)
                
                Text(userName)
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Text("ID: \(post.id)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

// MARK: - User Profiles
struct UserProfilesView: View {
    @StateObject private var viewModel = UserProfilesViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Cargando usuarios...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(viewModel.users) { user in
                        UserProfileCardView(user: user)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Perfiles")
        .task {
            if viewModel.users.isEmpty {
                await viewModel.loadUsers()
            }
        }
        .refreshable {
            await viewModel.refreshUsers()
        }
    }
}

struct UserProfileCardView: View {
    let user: APIUser
    
    var body: some View {
        VStack(spacing: 12) {
            // Avatar placeholder
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 60, height: 60)
                .overlay {
                    Text(String(user.name.prefix(1)))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            
            // User info
            VStack(spacing: 4) {
                Text(user.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text("@\(user.username)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(user.email)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            // Website link
            if !user.website.isEmpty {
                Link(destination: URL(string: "https://\(user.website)") ?? URL(string: "https://example.com")!) {
                    Label("Sitio web", systemImage: "link")
                        .font(.caption)
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 2)
        }
    }
}

// MARK: - Image Gallery
struct ImageGalleryView: View {
    @StateObject private var viewModel = ImageGalleryViewModel()
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.images) { image in
                    AsyncImageView(url: image.url, title: image.title)
                }
            }
            .padding()
        }
        .navigationTitle("Galería")
        .task {
            if viewModel.images.isEmpty {
                await viewModel.loadImages()
            }
        }
    }
}

struct AsyncImageView: View {
    let url: String
    let title: String
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay {
                        ProgressView()
                    }
            }
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(title)
                .font(.caption2)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Placeholder Views
struct RealTimeDataView: View {
    var body: some View {
        Text("Real-time Data - En desarrollo")
            .navigationTitle("Tiempo Real")
    }
}

struct FileUploadView: View {
    var body: some View {
        Text("File Upload - En desarrollo")
            .navigationTitle("Subir Archivos")
    }
}

struct OfflineSupportView: View {
    var body: some View {
        Text("Offline Support - En desarrollo")
            .navigationTitle("Soporte Offline")
    }
}

#Preview("Networking Examples") {
    NetworkingExamplesView()
}

#Preview("Posts Feed") {
    PostsFeedView()
}

#Preview("User Profiles") {
    UserProfilesView()
}
