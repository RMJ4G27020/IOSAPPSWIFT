import SwiftUI
import Combine

// MARK: - Modelos de Datos
struct Post: Identifiable, Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

struct User: Identifiable, Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
}

// MARK: - Servicio de Red
protocol NetworkServiceProtocol {
    func fetchPosts() async throws -> [Post]
    func fetchUsers() async throws -> [User]
    func fetchPost(id: Int) async throws -> Post
}

class NetworkService: NetworkServiceProtocol, ObservableObject {
    private let baseURL = "https://jsonplaceholder.typicode.com"
    private let session = URLSession.shared
    
    // MARK: - Fetch Posts
    func fetchPosts() async throws -> [Post] {
        guard let url = URL(string: "\(baseURL)/posts") else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            
            let posts = try JSONDecoder().decode([Post].self, from: data)
            return posts
            
        } catch {
            if error is DecodingError {
                throw NetworkError.decodingError
            } else {
                throw NetworkError.networkError(error)
            }
        }
    }
    
    // MARK: - Fetch Users
    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: "\(baseURL)/users") else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            
            let users = try JSONDecoder().decode([User].self, from: data)
            return users
            
        } catch {
            if error is DecodingError {
                throw NetworkError.decodingError
            } else {
                throw NetworkError.networkError(error)
            }
        }
    }
    
    // MARK: - Fetch Single Post
    func fetchPost(id: Int) async throws -> Post {
        guard let url = URL(string: "\(baseURL)/posts/\(id)") else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            
            let post = try JSONDecoder().decode(Post.self, from: data)
            return post
            
        } catch {
            if error is DecodingError {
                throw NetworkError.decodingError
            } else {
                throw NetworkError.networkError(error)
            }
        }
    }
}

// MARK: - Errores de Red
enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case decodingError
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .invalidResponse:
            return "Respuesta inválida del servidor"
        case .decodingError:
            return "Error al procesar los datos"
        case .networkError(let error):
            return "Error de red: \(error.localizedDescription)"
        }
    }
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse),
             (.decodingError, .decodingError):
            return true
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

// MARK: - ViewModel para Posts
@MainActor
class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingError = false
    
    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Funciones públicas
    func loadPosts() {
        Task {
            await fetchPosts()
        }
    }
    
    func loadUsers() {
        Task {
            await fetchUsers()
        }
    }
    
    func refreshData() {
        Task {
            await fetchPosts()
            await fetchUsers()
        }
    }
    
    // MARK: - Funciones privadas
    private func fetchPosts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedPosts = try await networkService.fetchPosts()
            posts = fetchedPosts
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    private func fetchUsers() async {
        do {
            let fetchedUsers = try await networkService.fetchUsers()
            users = fetchedUsers
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            errorMessage = networkError.errorDescription
        } else {
            errorMessage = "Error inesperado: \(error.localizedDescription)"
        }
        showingError = true
    }
    
    // MARK: - Helper functions
    func getUserName(for userId: Int) -> String {
        users.first { $0.id == userId }?.name ?? "Usuario desconocido"
    }
}

// MARK: - Vista Principal de Posts
struct PostsListView: View {
    @StateObject private var viewModel = PostsViewModel()
    @State private var selectedPost: Post?
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading && viewModel.posts.isEmpty {
                    loadingView
                } else {
                    postsListContent
                }
            }
            .navigationTitle("Posts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Actualizar") {
                        viewModel.refreshData()
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .task {
                if viewModel.posts.isEmpty {
                    viewModel.loadPosts()
                    viewModel.loadUsers()
                }
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK") { }
                Button("Reintentar") {
                    viewModel.refreshData()
                }
            } message: {
                Text(viewModel.errorMessage ?? "Error desconocido")
            }
            .sheet(item: $selectedPost) { post in
                PostDetailView(post: post, userName: viewModel.getUserName(for: post.userId))
            }
        }
        .searchable(text: $searchText, prompt: "Buscar posts...")
    }
    
    // MARK: - Vistas auxiliares
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.5)
            
            Text("Cargando posts...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var postsListContent: some View {
        List(filteredPosts) { post in
            PostRowView(
                post: post,
                userName: viewModel.getUserName(for: post.userId)
            ) {
                selectedPost = post
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            viewModel.refreshData()
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

// MARK: - Vista de Fila de Post
struct PostRowView: View {
    let post: Post
    let userName: String
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Título del post
            Text(post.title)
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            // Extracto del cuerpo
            Text(post.body)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            // Información del usuario
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
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Vista de Detalle de Post
struct PostDetailView: View {
    let post: Post
    let userName: String
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = false
    @State private var comments: [Comment] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header con información del usuario
                    userInfoSection
                    
                    Divider()
                    
                    // Título del post
                    Text(post.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    // Cuerpo del post
                    Text(post.body)
                        .font(.body)
                        .lineSpacing(4)
                        .multilineTextAlignment(.leading)
                    
                    Divider()
                    
                    // Sección de comentarios (simulada)
                    commentsSection
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .navigationTitle("Post \(post.id)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    ShareLink(item: "Post: \(post.title)\n\n\(post.body)") {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
    
    // MARK: - Secciones de la vista
    private var userInfoSection: some View {
        HStack {
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 50, height: 50)
                .overlay {
                    Image(systemName: "person")
                        .foregroundColor(.blue)
                        .font(.title3)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(userName)
                    .font(.headline)
                
                Text("User ID: \(post.userId)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
    
    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Comentarios")
                    .font(.headline)
                Spacer()
            }
            
            if isLoading {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        .scaleEffect(0.8)
                    Text("Cargando comentarios...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                ForEach(1...3, id: \.self) { index in
                    commentView(index: index)
                }
            }
        }
        .onAppear {
            loadComments()
        }
    }
    
    private func commentView(index: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Usuario \(index)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("hace \(index)h")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text("Este es un comentario de ejemplo para el post. Los comentarios reales se cargarían desde la API.")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1))
        )
    }
    
    private func loadComments() {
        isLoading = true
        
        // Simula carga de comentarios
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
        }
    }
}

// MARK: - Modelo de Comentario (para ejemplo)
struct Comment: Identifiable, Codable {
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}

// MARK: - Preview
#Preview("Posts List") {
    PostsListView()
}

#Preview("Post Detail") {
    PostDetailView(
        post: Post(
            id: 1,
            userId: 1,
            title: "Título de ejemplo",
            body: "Este es el cuerpo del post de ejemplo. Aquí iría el contenido completo del post que se está mostrando."
        ),
        userName: "Juan Pérez"
    )
}
