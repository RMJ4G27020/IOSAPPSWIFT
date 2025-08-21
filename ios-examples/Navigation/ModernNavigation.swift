import SwiftUI

// MARK: - Navegación con NavigationStack (iOS 16+)
struct NavigacionModernaView: View {
    @State private var path = NavigationPath()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Navegación Stack
            NavigationStack(path: $path) {
                PantallaInicioView(path: $path)
                    .navigationDestination(for: DetalleDestino.self) { destino in
                        DetalleView(destino: destino, path: $path)
                    }
                    .navigationDestination(for: ConfiguracionDestino.self) { _ in
                        ConfiguracionView(path: $path)
                    }
            }
            .tabItem {
                Label("Inicio", systemImage: "house")
            }
            .tag(0)
            
            // Tab 2: Lista
            NavigationStack {
                ListaElementosView()
            }
            .tabItem {
                Label("Lista", systemImage: "list.bullet")
            }
            .tag(1)
            
            // Tab 3: Perfil
            NavigationStack {
                PerfilView()
            }
            .tabItem {
                Label("Perfil", systemImage: "person")
            }
            .tag(2)
        }
    }
}

// MARK: - Modelos para Navegación
enum DetalleDestino: Hashable {
    case producto(id: Int, nombre: String)
    case categoria(nombre: String)
    case busqueda(termino: String)
}

enum ConfiguracionDestino: Hashable {
    case general
    case privacidad
    case notificaciones
}

// MARK: - Pantalla de Inicio
struct PantallaInicioView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Header
                headerSection
                
                // Categorías
                categoriasSection
                
                // Productos destacados
                productosDestacadosSection
            }
            .padding()
        }
        .navigationTitle("Inicio")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    path.append(ConfiguracionDestino.general)
                }) {
                    Image(systemName: "gearshape")
                }
            }
        }
    }
    
    // MARK: - Secciones de la vista
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("¡Bienvenido!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Explora nuestros productos")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.1))
        )
    }
    
    private var categoriasSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Categorías")
                    .font(.headline)
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(categorias, id: \.self) { categoria in
                    Button(action: {
                        path.append(DetalleDestino.categoria(nombre: categoria))
                    }) {
                        CategoriaCardView(nombre: categoria)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var productosDestacadosSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Productos Destacados")
                    .font(.headline)
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(1...6, id: \.self) { id in
                    Button(action: {
                        path.append(DetalleDestino.producto(id: id, nombre: "Producto \(id)"))
                    }) {
                        ProductoCardView(id: id, nombre: "Producto \(id)")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    // MARK: - Data
    private let categorias = ["Electrónicos", "Ropa", "Hogar", "Deportes"]
}

// MARK: - Vista de Detalle
struct DetalleView: View {
    let destino: DetalleDestino
    @Binding var path: NavigationPath
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                switch destino {
                case .producto(let id, let nombre):
                    ProductoDetalleView(id: id, nombre: nombre)
                case .categoria(let nombre):
                    CategoriaDetalleView(nombre: nombre)
                case .busqueda(let termino):
                    BusquedaDetalleView(termino: termino)
                }
                
                // Botón para navegar más profundo
                Button("Ver más detalles") {
                    path.append(DetalleDestino.busqueda(termino: "detalle avanzado"))
                }
                .buttonStyle(.borderedProminent)
                
                // Botón para volver al inicio
                Button("Volver al inicio") {
                    path.removeLast(path.count)
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .navigationTitle(tituloSegunDestino)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var tituloSegunDestino: String {
        switch destino {
        case .producto(_, let nombre):
            return nombre
        case .categoria(let nombre):
            return nombre
        case .busqueda(let termino):
            return "Búsqueda: \(termino)"
        }
    }
}

// MARK: - Vistas de Contenido Específico
struct ProductoDetalleView: View {
    let id: Int
    let nombre: String
    
    var body: some View {
        VStack(spacing: 16) {
            // Imagen del producto
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.3))
                .frame(height: 200)
                .overlay {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
            
            Text(nombre)
                .font(.title)
                .fontWeight(.bold)
            
            Text("ID: \(id)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Descripción detallada del producto. Aquí iría toda la información relevante como especificaciones, precio, disponibilidad, etc.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct CategoriaDetalleView: View {
    let nombre: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Categoría: \(nombre)")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Productos en esta categoría:")
                .font(.headline)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(1...4, id: \.self) { id in
                    ProductoCardView(id: id, nombre: "\(nombre) \(id)")
                }
            }
        }
    }
}

struct BusquedaDetalleView: View {
    let termino: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Resultados para: '\(termino)'")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Aquí se mostrarían los resultados de búsqueda")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Componentes Reutilizables
struct CategoriaCardView: View {
    let nombre: String
    
    var body: some View {
        VStack {
            Image(systemName: "folder")
                .font(.title)
                .foregroundColor(.blue)
            
            Text(nombre)
                .font(.caption)
                .fontWeight(.medium)
        }
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct ProductoCardView: View {
    let id: Int
    let nombre: String
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.2))
                .frame(height: 60)
                .overlay {
                    Text("\(id)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            
            Text(nombre)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

// MARK: - Vista de Configuración
struct ConfiguracionView: View {
    @Binding var path: NavigationPath
    @State private var notificacionesHabilitadas = true
    @State private var modoOscuro = false
    
    var body: some View {
        List {
            Section("General") {
                HStack {
                    Image(systemName: "bell")
                    Text("Notificaciones")
                    Spacer()
                    Toggle("", isOn: $notificacionesHabilitadas)
                }
                
                HStack {
                    Image(systemName: "moon")
                    Text("Modo Oscuro")
                    Spacer()
                    Toggle("", isOn: $modoOscuro)
                }
            }
            
            Section("Información") {
                HStack {
                    Image(systemName: "info.circle")
                    Text("Versión")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Configuración")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Lista de Elementos (Tab 2)
struct ListaElementosView: View {
    @State private var elementos = (1...20).map { "Elemento \($0)" }
    
    var body: some View {
        List {
            ForEach(elementos, id: \.self) { elemento in
                NavigationLink(destination: DetalleElementoView(elemento: elemento)) {
                    HStack {
                        Image(systemName: "doc.text")
                        Text(elemento)
                    }
                }
            }
            .onDelete(perform: eliminarElementos)
        }
        .navigationTitle("Elementos")
        .toolbar {
            EditButton()
        }
    }
    
    private func eliminarElementos(at offsets: IndexSet) {
        elementos.remove(atOffsets: offsets)
    }
}

struct DetalleElementoView: View {
    let elemento: String
    
    var body: some View {
        VStack {
            Text(elemento)
                .font(.largeTitle)
                .padding()
            
            Text("Detalles del \(elemento)")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Vista de Perfil (Tab 3)
struct PerfilView: View {
    @State private var nombre = "Usuario"
    @State private var showingEditProfile = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Avatar
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 100, height: 100)
                .overlay {
                    Image(systemName: "person")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
            
            Text(nombre)
                .font(.title)
                .fontWeight(.semibold)
            
            Button("Editar Perfil") {
                showingEditProfile = true
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Perfil")
        .sheet(isPresented: $showingEditProfile) {
            EditarPerfilView(nombre: $nombre)
        }
    }
}

struct EditarPerfilView: View {
    @Binding var nombre: String
    @Environment(\.dismiss) private var dismiss
    @State private var nombreTemporal: String
    
    init(nombre: Binding<String>) {
        self._nombre = nombre
        self._nombreTemporal = State(initialValue: nombre.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Información Personal") {
                    TextField("Nombre", text: $nombreTemporal)
                }
            }
            .navigationTitle("Editar Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        nombre = nombreTemporal
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigacionModernaView()
}
