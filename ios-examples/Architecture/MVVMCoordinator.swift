import SwiftUI
import Combine

// MARK: - Arquitectura MVVM + Coordinator Pattern

// MARK: - Coordinator Protocol
protocol Coordinator: ObservableObject {
    func navigate(to destination: any Hashable)
    func goBack()
    func popToRoot()
}

// MARK: - App Coordinator
class AppCoordinator: Coordinator {
    @Published var path = NavigationPath()
    @Published var currentTab: AppTab = .home
    
    func navigate(to destination: any Hashable) {
        path.append(destination)
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func switchTab(to tab: AppTab) {
        currentTab = tab
        popToRoot() // Limpiar navegación al cambiar de tab
    }
}

// MARK: - App Tabs
enum AppTab: String, CaseIterable {
    case home = "home"
    case profile = "profile"
    case settings = "settings"
    
    var title: String {
        switch self {
        case .home: return "Inicio"
        case .profile: return "Perfil"
        case .settings: return "Configuración"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .profile: return "person"
        case .settings: return "gearshape"
        }
    }
}

// MARK: - Navigation Destinations
enum HomeDestination: Hashable {
    case userDetail(User)
    case taskDetail(Task)
    case taskCreate
}

enum ProfileDestination: Hashable {
    case editProfile
    case preferences
}

enum SettingsDestination: Hashable {
    case notifications
    case privacy
    case about
}

// MARK: - Models
struct User: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var email: String
    var avatar: String?
    var isActive: Bool
    
    init(name: String, email: String, isActive: Bool = true) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.isActive = isActive
    }
}

struct Task: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var description: String
    var isCompleted: Bool
    var priority: Priority
    var dueDate: Date?
    var assignedUserId: UUID?
    
    init(title: String, description: String, priority: Priority = .medium, dueDate: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.isCompleted = false
        self.priority = priority
        self.dueDate = dueDate
    }
    
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
    }
}

// MARK: - Repository Protocol
protocol DataRepository: ObservableObject {
    func fetchUsers() async throws -> [User]
    func fetchTasks() async throws -> [Task]
    func saveTask(_ task: Task) async throws
    func updateTask(_ task: Task) async throws
    func deleteTask(id: UUID) async throws
}

// MARK: - Mock Data Repository
class MockDataRepository: DataRepository {
    @Published var users: [User] = []
    @Published var tasks: [Task] = []
    
    init() {
        loadMockData()
    }
    
    func fetchUsers() async throws -> [User] {
        // Simular delay de red
        try await Task.sleep(nanoseconds: 500_000_000)
        return users
    }
    
    func fetchTasks() async throws -> [Task] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return tasks
    }
    
    func saveTask(_ task: Task) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
        tasks.append(task)
    }
    
    func updateTask(_ task: Task) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func deleteTask(id: UUID) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
        tasks.removeAll { $0.id == id }
    }
    
    private func loadMockData() {
        users = [
            User(name: "Ana García", email: "ana@example.com"),
            User(name: "Carlos López", email: "carlos@example.com"),
            User(name: "María Rodríguez", email: "maria@example.com"),
            User(name: "David Martín", email: "david@example.com", isActive: false)
        ]
        
        tasks = [
            Task(title: "Diseñar interfaz", description: "Crear mockups para la nueva pantalla", priority: .high),
            Task(title: "Implementar API", description: "Desarrollar endpoints REST", priority: .medium),
            Task(title: "Testing", description: "Escribir tests unitarios", priority: .low),
            Task(title: "Documentación", description: "Actualizar README", priority: .medium)
        ]
        
        // Asignar algunas tareas a usuarios
        tasks[0].assignedUserId = users[0].id
        tasks[1].assignedUserId = users[1].id
        tasks[2].assignedUserId = users[2].id
    }
}

// MARK: - ViewModels

// Home ViewModel
@MainActor
class HomeViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var tasks: [Task] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: DataRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: DataRepository) {
        self.repository = repository
        observeRepositoryChanges()
    }
    
    func loadData() {
        Task {
            await loadDataAsync()
        }
    }
    
    func refreshData() {
        Task {
            await loadDataAsync()
        }
    }
    
    func toggleTaskCompletion(_ task: Task) {
        var updatedTask = task
        updatedTask.isCompleted.toggle()
        
        Task {
            try? await repository.updateTask(updatedTask)
        }
    }
    
    func deleteTask(_ task: Task) {
        Task {
            try? await repository.deleteTask(id: task.id)
        }
    }
    
    private func loadDataAsync() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let usersData = repository.fetchUsers()
            async let tasksData = repository.fetchTasks()
            
            users = try await usersData
            tasks = try await tasksData
        } catch {
            errorMessage = "Error al cargar datos: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func observeRepositoryChanges() {
        if let mockRepo = repository as? MockDataRepository {
            mockRepo.$users
                .receive(on: DispatchQueue.main)
                .assign(to: &$users)
            
            mockRepo.$tasks
                .receive(on: DispatchQueue.main)
                .assign(to: &$tasks)
        }
    }
    
    func getUserName(for userId: UUID?) -> String {
        guard let userId = userId,
              let user = users.first(where: { $0.id == userId }) else {
            return "Sin asignar"
        }
        return user.name
    }
}

// Profile ViewModel
@MainActor
class ProfileViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoading = false
    
    init() {
        loadCurrentUser()
    }
    
    func updateProfile(name: String, email: String) {
        guard var user = currentUser else { return }
        
        user.name = name
        user.email = email
        currentUser = user
        
        // Aquí iría la lógica para guardar en el backend
    }
    
    private func loadCurrentUser() {
        // Mock current user
        currentUser = User(name: "Usuario Actual", email: "usuario@example.com")
    }
}

// Task Creation ViewModel
@MainActor
class TaskCreationViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var priority: Task.Priority = .medium
    @Published var dueDate = Date()
    @Published var hasDueDate = false
    @Published var selectedUserId: UUID?
    @Published var isLoading = false
    
    private let repository: DataRepository
    
    init(repository: DataRepository) {
        self.repository = repository
    }
    
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !description.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func saveTask() async -> Bool {
        guard isValid else { return false }
        
        isLoading = true
        
        let newTask = Task(
            title: title.trimmingCharacters(in: .whitespaces),
            description: description.trimmingCharacters(in: .whitespaces),
            priority: priority,
            dueDate: hasDueDate ? dueDate : nil
        )
        
        do {
            try await repository.saveTask(newTask)
            resetForm()
            isLoading = false
            return true
        } catch {
            isLoading = false
            return false
        }
    }
    
    private func resetForm() {
        title = ""
        description = ""
        priority = .medium
        dueDate = Date()
        hasDueDate = false
        selectedUserId = nil
    }
}

// MARK: - Main App View
struct MVVMArchitectureApp: View {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var repository = MockDataRepository()
    
    var body: some View {
        TabView(selection: $coordinator.currentTab) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                NavigationStack(path: $coordinator.path) {
                    contentView(for: tab)
                        .navigationDestinations()
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.icon)
                }
                .tag(tab)
            }
        }
        .environmentObject(coordinator)
        .environmentObject(repository)
    }
    
    @ViewBuilder
    private func contentView(for tab: AppTab) -> some View {
        switch tab {
        case .home:
            HomeView()
        case .profile:
            ProfileView()
        case .settings:
            SettingsView()
        }
    }
}

// MARK: - Navigation Extension
extension View {
    func navigationDestinations() -> some View {
        self
            .navigationDestination(for: HomeDestination.self) { destination in
                switch destination {
                case .userDetail(let user):
                    UserDetailView(user: user)
                case .taskDetail(let task):
                    TaskDetailView(task: task)
                case .taskCreate:
                    TaskCreationView()
                }
            }
            .navigationDestination(for: ProfileDestination.self) { destination in
                switch destination {
                case .editProfile:
                    EditProfileView()
                case .preferences:
                    PreferencesView()
                }
            }
            .navigationDestination(for: SettingsDestination.self) { destination in
                switch destination {
                case .notifications:
                    NotificationsSettingsView()
                case .privacy:
                    PrivacySettingsView()
                case .about:
                    AboutView()
                }
            }
    }
}

// MARK: - Views

// Home View
struct HomeView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var repository: MockDataRepository
    @StateObject private var viewModel: HomeViewModel
    
    init() {
        // Esta inicialización será mejorada con inyección de dependencias
        self._viewModel = StateObject(wrappedValue: HomeViewModel(repository: MockDataRepository()))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Sección de usuarios
                usersSection
                
                // Sección de tareas
                tasksSection
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    coordinator.navigate(to: HomeDestination.taskCreate)
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .task {
            viewModel.loadData()
        }
        .refreshable {
            viewModel.refreshData()
        }
    }
    
    private var usersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Usuarios")
                .font(.title2)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(viewModel.users) { user in
                        UserCardView(user: user) {
                            coordinator.navigate(to: HomeDestination.userDetail(user))
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tareas Recientes")
                .font(.title2)
                .fontWeight(.semibold)
            
            ForEach(viewModel.tasks.prefix(5)) { task in
                TaskRowView(
                    task: task,
                    assignedUserName: viewModel.getUserName(for: task.assignedUserId)
                ) {
                    coordinator.navigate(to: HomeDestination.taskDetail(task))
                } onToggle: {
                    viewModel.toggleTaskCompletion(task)
                } onDelete: {
                    viewModel.deleteTask(task)
                }
            }
        }
    }
}

// User Card View
struct UserCardView: View {
    let user: User
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(user.isActive ? Color.blue : Color.gray)
                .frame(width: 50, height: 50)
                .overlay {
                    Text(String(user.name.prefix(1)))
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
            
            Text(user.name)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
        .padding(.vertical, 8)
        .onTapGesture {
            onTap()
        }
    }
}

// Task Row View
struct TaskRowView: View {
    let task: Task
    let assignedUserName: String
    let onTap: () -> Void
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                
                Text(task.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Label(task.priority.displayName, systemImage: "flag.fill")
                        .font(.caption2)
                        .foregroundColor(task.priority.color)
                    
                    if !assignedUserName.isEmpty {
                        Label(assignedUserName, systemImage: "person")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .shadow(radius: 2)
        )
        .onTapGesture {
            onTap()
        }
    }
}

// Placeholder Views (estas se expandirían en una app real)
struct UserDetailView: View {
    let user: User
    
    var body: some View {
        VStack {
            Text("Detalle de \(user.name)")
                .font(.title)
            Text(user.email)
        }
        .navigationTitle(user.name)
    }
}

struct TaskDetailView: View {
    let task: Task
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(task.title)
                .font(.title2)
            Text(task.description)
            
            Label(task.priority.displayName, systemImage: "flag.fill")
                .foregroundColor(task.priority.color)
        }
        .padding()
        .navigationTitle("Detalle de Tarea")
    }
}

struct TaskCreationView: View {
    @EnvironmentObject private var repository: MockDataRepository
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: TaskCreationViewModel
    
    init() {
        // Esta inicialización será mejorada con inyección de dependencias
        self._viewModel = StateObject(wrappedValue: TaskCreationViewModel(repository: MockDataRepository()))
    }
    
    var body: some View {
        Form {
            TextField("Título", text: $viewModel.title)
            TextField("Descripción", text: $viewModel.description, axis: .vertical)
            
            Picker("Prioridad", selection: $viewModel.priority) {
                ForEach(Task.Priority.allCases, id: \.self) { priority in
                    Text(priority.displayName).tag(priority)
                }
            }
            
            Toggle("Fecha límite", isOn: $viewModel.hasDueDate)
            
            if viewModel.hasDueDate {
                DatePicker("Fecha", selection: $viewModel.dueDate, displayedComponents: .date)
            }
        }
        .navigationTitle("Nueva Tarea")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Guardar") {
                    Task {
                        let success = await viewModel.saveTask()
                        if success {
                            coordinator.goBack()
                        }
                    }
                }
                .disabled(!viewModel.isValid || viewModel.isLoading)
            }
        }
    }
}

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack {
            if let user = viewModel.currentUser {
                Text("Perfil de \(user.name)")
                    .font(.title)
                Text(user.email)
            }
        }
        .navigationTitle("Perfil")
    }
}

struct SettingsView: View {
    var body: some View {
        List {
            Text("Configuraciones")
        }
        .navigationTitle("Configuración")
    }
}

// Más placeholder views...
struct EditProfileView: View {
    var body: some View {
        Text("Editar Perfil")
            .navigationTitle("Editar")
    }
}

struct PreferencesView: View {
    var body: some View {
        Text("Preferencias")
    }
}

struct NotificationsSettingsView: View {
    var body: some View {
        Text("Notificaciones")
    }
}

struct PrivacySettingsView: View {
    var body: some View {
        Text("Privacidad")
    }
}

struct AboutView: View {
    var body: some View {
        Text("Acerca de")
    }
}

// MARK: - Preview
#Preview {
    MVVMArchitectureApp()
}
