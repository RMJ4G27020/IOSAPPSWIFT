import SwiftUI

// MARK: - Vista Básica con @State
struct ContadorView: View {
    @State private var contador = 0
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Título con animación
            Text("Contador SwiftUI")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: isAnimating)
            
            // Display del contador
            Text("\(contador)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(.blue)
                .padding()
                .background(
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 150, height: 150)
                )
                .animation(.bouncy, value: contador)
            
            // Botones de control
            HStack(spacing: 15) {
                // Botón decrementar
                Button(action: decrementar) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .buttonStyle(ScaleButtonStyle())
                .disabled(contador <= 0)
                
                // Botón reset
                Button(action: resetear) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.title)
                        .foregroundColor(.orange)
                }
                .buttonStyle(ScaleButtonStyle())
                
                // Botón incrementar
                Button(action: incrementar) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.green)
                }
                .buttonStyle(ScaleButtonStyle())
            }
            
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.clear]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    // MARK: - Acciones
    private func incrementar() {
        withAnimation(.spring()) {
            contador += 1
            isAnimating = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isAnimating = false
        }
    }
    
    private func decrementar() {
        withAnimation(.spring()) {
            if contador > 0 {
                contador -= 1
                isAnimating = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isAnimating = false
        }
    }
    
    private func resetear() {
        withAnimation(.easeInOut) {
            contador = 0
            isAnimating = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isAnimating = false
        }
    }
}

// MARK: - Custom Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Lista con @State
struct ListaBasicaView: View {
    @State private var items: [String] = ["Manzana", "Plátano", "Naranja"]
    @State private var nuevoItem = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Campo de entrada
                HStack {
                    TextField("Agregar item...", text: $nuevoItem)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Agregar") {
                        agregarItem()
                    }
                    .disabled(nuevoItem.isEmpty)
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                
                // Lista de items
                List {
                    ForEach(items.indices, id: \.self) { index in
                        HStack {
                            Text(items[index])
                                .font(.body)
                            
                            Spacer()
                            
                            Button(action: {
                                eliminarItem(at: index)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                eliminarItem(at: index)
                            } label: {
                                Label("Eliminar", systemImage: "trash")
                            }
                        }
                    }
                    .onMove(perform: moverItems)
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Mi Lista")
            .toolbar {
                EditButton()
            }
            .alert("Lista vacía", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text("No hay items en la lista")
            }
        }
    }
    
    // MARK: - Funciones privadas
    private func agregarItem() {
        guard !nuevoItem.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        withAnimation(.easeInOut) {
            items.append(nuevoItem)
            nuevoItem = ""
        }
    }
    
    private func eliminarItem(at index: Int) {
        withAnimation(.easeInOut) {
            items.remove(at: index)
            
            if items.isEmpty {
                showingAlert = true
            }
        }
    }
    
    private func moverItems(from source: IndexSet, to destination: Int) {
        withAnimation {
            items.move(fromOffsets: source, toOffset: destination)
        }
    }
}

// MARK: - Preview
#Preview("Contador") {
    ContadorView()
}

#Preview("Lista Básica") {
    ListaBasicaView()
}
