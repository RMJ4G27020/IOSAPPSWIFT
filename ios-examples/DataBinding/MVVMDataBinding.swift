import SwiftUI

// MARK: - Modelo de Datos
struct Usuario: Identifiable, Codable {
    let id = UUID()
    var nombre: String
    var email: String
    var edad: Int
    var isActivo: Bool = true
}

// MARK: - ViewModel con @Published
class UsuarioViewModel: ObservableObject {
    @Published var usuarios: [Usuario] = []
    @Published var isLoading = false
    @Published var mensajeError: String?
    
    init() {
        cargarUsuariosMock()
    }
    
    // MARK: - Funciones públicas
    func agregarUsuario(_ usuario: Usuario) {
        withAnimation(.easeInOut) {
            usuarios.append(usuario)
        }
    }
    
    func eliminarUsuario(at index: Int) {
        guard index < usuarios.count else { return }
        
        withAnimation(.easeInOut) {
            usuarios.remove(at: index)
        }
    }
    
    func toggleUsuarioActivo(at index: Int) {
        guard index < usuarios.count else { return }
        
        withAnimation(.easeInOut) {
            usuarios[index].isActivo.toggle()
        }
    }
    
    // MARK: - Funciones privadas
    private func cargarUsuariosMock() {
        isLoading = true
        
        // Simula carga de datos
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.usuarios = [
                Usuario(nombre: "Juan Pérez", email: "juan@example.com", edad: 25),
                Usuario(nombre: "María García", email: "maria@example.com", edad: 30),
                Usuario(nombre: "Carlos López", email: "carlos@example.com", edad: 28)
            ]
            self.isLoading = false
        }
    }
}

// MARK: - Vista Principal con @StateObject
struct GestionUsuariosView: View {
    @StateObject private var viewModel = UsuarioViewModel()
    @State private var showingAgregarUsuario = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    LoadingView()
                } else {
                    listaUsuarios
                }
            }
            .navigationTitle("Usuarios")
            .toolbar {
                Button(action: { showingAgregarUsuario = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAgregarUsuario) {
                AgregarUsuarioView(viewModel: viewModel)
            }
        }
    }
    
    // MARK: - Vista de Lista
    private var listaUsuarios: some View {
        List {
            ForEach(viewModel.usuarios.indices, id: \.self) { index in
                UsuarioRowView(
                    usuario: viewModel.usuarios[index],
                    onToggleActivo: {
                        viewModel.toggleUsuarioActivo(at: index)
                    }
                )
            }
            .onDelete { indexSet in
                for index in indexSet {
                    viewModel.eliminarUsuario(at: index)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

// MARK: - Vista de Fila de Usuario con @Binding
struct UsuarioRowView: View {
    let usuario: Usuario
    let onToggleActivo: () -> Void
    
    var body: some View {
        HStack {
            // Avatar
            Circle()
                .fill(usuario.isActivo ? Color.green : Color.gray)
                .frame(width: 40, height: 40)
                .overlay {
                    Text(String(usuario.nombre.prefix(1)))
                        .foregroundColor(.white)
                        .font(.headline)
                }
            
            // Información del usuario
            VStack(alignment: .leading, spacing: 4) {
                Text(usuario.nombre)
                    .font(.headline)
                    .foregroundColor(usuario.isActivo ? .primary : .secondary)
                
                Text(usuario.email)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Edad: \(usuario.edad)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Toggle activo
            Button(action: onToggleActivo) {
                Image(systemName: usuario.isActivo ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(usuario.isActivo ? .green : .gray)
                    .font(.title2)
            }
        }
        .padding(.vertical, 4)
        .opacity(usuario.isActivo ? 1.0 : 0.6)
        .animation(.easeInOut, value: usuario.isActivo)
    }
}

// MARK: - Vista para Agregar Usuario
struct AgregarUsuarioView: View {
    @ObservedObject var viewModel: UsuarioViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var nombre = ""
    @State private var email = ""
    @State private var edad = 18
    @State private var showingAlert = false
    @State private var mensajeAlerta = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información Personal")) {
                    TextField("Nombre completo", text: $nombre)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
                    Stepper("Edad: \(edad)", value: $edad, in: 18...100)
                }
            }
            .navigationTitle("Nuevo Usuario")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        guardarUsuario()
                    }
                    .disabled(!isFormularioValido)
                }
            }
            .alert("Error", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(mensajeAlerta)
            }
        }
    }
    
    // MARK: - Computed Properties
    private var isFormularioValido: Bool {
        !nombre.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        email.contains("@")
    }
    
    // MARK: - Funciones privadas
    private func guardarUsuario() {
        guard isFormularioValido else {
            mensajeAlerta = "Por favor completa todos los campos correctamente"
            showingAlert = true
            return
        }
        
        let nuevoUsuario = Usuario(
            nombre: nombre.trimmingCharacters(in: .whitespaces),
            email: email.trimmingCharacters(in: .whitespaces),
            edad: edad
        )
        
        viewModel.agregarUsuario(nuevoUsuario)
        dismiss()
    }
}

// MARK: - Vista de Loading
struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.5)
            
            Text("Cargando usuarios...")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

// MARK: - Preview
#Preview("Gestión de Usuarios") {
    GestionUsuariosView()
}

#Preview("Agregar Usuario") {
    AgregarUsuarioView(viewModel: UsuarioViewModel())
}

#Preview("Usuario Row - Activo") {
    UsuarioRowView(
        usuario: Usuario(nombre: "Juan Pérez", email: "juan@example.com", edad: 25),
        onToggleActivo: { }
    )
    .previewLayout(.sizeThatFits)
}

#Preview("Usuario Row - Inactivo") {
    UsuarioRowView(
        usuario: Usuario(nombre: "María García", email: "maria@example.com", edad: 30, isActivo: false),
        onToggleActivo: { }
    )
    .previewLayout(.sizeThatFits)
}
