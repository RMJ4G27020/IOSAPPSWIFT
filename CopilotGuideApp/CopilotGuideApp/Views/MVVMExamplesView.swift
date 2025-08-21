//
//  MVVMExamplesView.swift
//  CopilotGuideApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 CopilotGuide. All rights reserved.
//

import SwiftUI

struct MVVMExamplesView: View {
    var body: some View {
        NavigationView {
            List {
                Section("MVVM Pattern") {
                    NavigationLink("Gestión de Usuarios", destination: UserManagementView())
                    NavigationLink("ToDo App", destination: TodoAppView())
                    NavigationLink("Shopping Cart", destination: ShoppingCartView())
                }
                
                Section("State Management") {
                    NavigationLink("Complex Form", destination: ComplexFormView())
                    NavigationLink("Data Synchronization", destination: DataSyncView())
                }
            }
            .navigationTitle("MVVM Examples")
        }
    }
}

// MARK: - User Management
struct UserManagementView: View {
    @StateObject private var viewModel = UserManagementViewModel()
    @State private var showingAddUser = false
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Cargando usuarios...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.users.indices, id: \.self) { index in
                        UserRowView(
                            user: viewModel.users[index],
                            onToggleActive: {
                                viewModel.toggleUserStatus(at: index)
                            }
                        )
                    }
                    .onDelete { indexSet in
                        viewModel.deleteUsers(at: indexSet)
                    }
                }
            }
        }
        .navigationTitle("Usuarios")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddUser = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddUser) {
            AddUserView(viewModel: viewModel)
        }
        .task {
            await viewModel.loadUsers()
        }
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage ?? "Error desconocido")
        }
    }
}

struct UserRowView: View {
    let user: User
    let onToggleActive: () -> Void
    
    var body: some View {
        HStack {
            // Avatar
            Circle()
                .fill(user.isActive ? Color.green : Color.gray)
                .frame(width: 40, height: 40)
                .overlay {
                    Text(String(user.name.prefix(1)))
                        .foregroundColor(.white)
                        .font(.headline)
                }
            
            // User Info
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)
                    .foregroundColor(user.isActive ? .primary : .secondary)
                
                Text(user.email)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("ID: \(user.id.uuidString.prefix(8))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Status Toggle
            Button(action: onToggleActive) {
                Image(systemName: user.isActive ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(user.isActive ? .green : .gray)
                    .font(.title2)
            }
        }
        .opacity(user.isActive ? 1.0 : 0.6)
        .animation(.easeInOut, value: user.isActive)
    }
}

struct AddUserView: View {
    @ObservedObject var viewModel: UserManagementViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var email = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nueva Usuario")) {
                    TextField("Nombre completo", text: $name)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                }
            }
            .navigationTitle("Agregar Usuario")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        Task {
                            await saveUser()
                        }
                    }
                    .disabled(!isFormValid)
                }
            }
            .alert("Error", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        email.contains("@")
    }
    
    private func saveUser() async {
        guard isFormValid else {
            alertMessage = "Por favor completa todos los campos correctamente"
            showingAlert = true
            return
        }
        
        let newUser = User(
            name: name.trimmingCharacters(in: .whitespaces),
            email: email.trimmingCharacters(in: .whitespaces)
        )
        
        await viewModel.addUser(newUser)
        dismiss()
    }
}

// MARK: - ToDo App
struct TodoAppView: View {
    @StateObject private var viewModel = TodoViewModel()
    @State private var showingAddTask = false
    
    var body: some View {
        VStack {
            if viewModel.tasks.isEmpty && !viewModel.isLoading {
                ContentUnavailableView(
                    "No hay tareas",
                    systemImage: "checkmark.circle",
                    description: Text("Agrega una tarea para comenzar")
                )
            } else {
                List {
                    ForEach(viewModel.tasks) { task in
                        TaskRowView(
                            task: task,
                            onToggleComplete: {
                                viewModel.toggleTaskCompletion(task)
                            }
                        )
                    }
                    .onDelete { indexSet in
                        viewModel.deleteTasks(at: indexSet)
                    }
                }
            }
        }
        .navigationTitle("ToDo App")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddTask = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(viewModel: viewModel)
        }
    }
}

struct TaskRowView: View {
    let task: Task
    let onToggleComplete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggleComplete) {
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
                    
                    if let dueDate = task.dueDate {
                        Label(DateFormatter.short.string(from: dueDate), systemImage: "calendar")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct AddTaskView: View {
    @ObservedObject var viewModel: TodoViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var priority: Task.Priority = .medium
    @State private var hasDueDate = false
    @State private var dueDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información de la Tarea")) {
                    TextField("Título", text: $title)
                    TextField("Descripción", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section(header: Text("Configuración")) {
                    Picker("Prioridad", selection: $priority) {
                        ForEach(Task.Priority.allCases, id: \.self) { priority in
                            Text(priority.displayName).tag(priority)
                        }
                    }
                    
                    Toggle("Fecha límite", isOn: $hasDueDate)
                    
                    if hasDueDate {
                        DatePicker("Fecha", selection: $dueDate, displayedComponents: [.date])
                    }
                }
            }
            .navigationTitle("Nueva Tarea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        saveTask()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !description.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private func saveTask() {
        let newTask = Task(
            title: title.trimmingCharacters(in: .whitespaces),
            description: description.trimmingCharacters(in: .whitespaces),
            priority: priority,
            dueDate: hasDueDate ? dueDate : nil
        )
        
        viewModel.addTask(newTask)
        dismiss()
    }
}

// MARK: - Placeholder Views
struct ShoppingCartView: View {
    var body: some View {
        Text("Shopping Cart - En desarrollo")
            .navigationTitle("Carrito")
    }
}

struct ComplexFormView: View {
    var body: some View {
        Text("Complex Form - En desarrollo")
            .navigationTitle("Formulario")
    }
}

struct DataSyncView: View {
    var body: some View {
        Text("Data Sync - En desarrollo")
            .navigationTitle("Sincronización")
    }
}

#Preview("MVVM Examples") {
    MVVMExamplesView()
}

#Preview("User Management") {
    UserManagementView()
}

#Preview("Todo App") {
    TodoAppView()
}
