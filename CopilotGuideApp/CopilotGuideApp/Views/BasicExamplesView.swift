//
//  BasicExamplesView.swift
//  CopilotGuideApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 CopilotGuide. All rights reserved.
//

import SwiftUI

struct BasicExamplesView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Controles Básicos") {
                    NavigationLink("Contador Animado", destination: AnimatedCounterView())
                    NavigationLink("Lista Interactiva", destination: InteractiveListView())
                    NavigationLink("Formulario Simple", destination: SimpleFormView())
                }
                
                Section("Layouts") {
                    NavigationLink("Grid Personalizado", destination: CustomGridView())
                    NavigationLink("Stack Avanzado", destination: AdvancedStackView())
                }
                
                Section("Animaciones") {
                    NavigationLink("Transiciones", destination: TransitionsView())
                    NavigationLink("Gestos", destination: GesturesView())
                }
            }
            .navigationTitle("Ejemplos Básicos")
        }
    }
}

// MARK: - Contador Animado
struct AnimatedCounterView: View {
    @State private var counter = 0
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Contador SwiftUI")
                .font(.largeTitle)
                .fontWeight(.bold)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: isAnimating)
            
            Text("\(counter)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(.blue)
                .padding()
                .background(
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 150, height: 150)
                )
                .animation(.bouncy, value: counter)
            
            HStack(spacing: 20) {
                Button("Decrementar") {
                    decrementCounter()
                }
                .buttonStyle(.bordered)
                .disabled(counter <= 0)
                
                Button("Reset") {
                    resetCounter()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Incrementar") {
                    incrementCounter()
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Contador")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func incrementCounter() {
        withAnimation(.spring()) {
            counter += 1
            triggerAnimation()
        }
    }
    
    private func decrementCounter() {
        withAnimation(.spring()) {
            if counter > 0 {
                counter -= 1
                triggerAnimation()
            }
        }
    }
    
    private func resetCounter() {
        withAnimation(.easeInOut) {
            counter = 0
            triggerAnimation()
        }
    }
    
    private func triggerAnimation() {
        isAnimating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isAnimating = false
        }
    }
}

// MARK: - Lista Interactiva
struct InteractiveListView: View {
    @State private var items = ["Manzana", "Plátano", "Naranja", "Pera", "Uva"]
    @State private var newItem = ""
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            HStack {
                TextField("Nuevo item...", text: $newItem)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Agregar") {
                    addItem()
                }
                .disabled(newItem.isEmpty)
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
            List {
                ForEach(items.indices, id: \.self) { index in
                    HStack {
                        Text(items[index])
                        
                        Spacer()
                        
                        Button(action: {
                            removeItem(at: index)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            removeItem(at: index)
                        } label: {
                            Label("Eliminar", systemImage: "trash")
                        }
                    }
                }
                .onMove(perform: moveItems)
            }
        }
        .navigationTitle("Lista")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton()
        }
        .alert("Lista vacía", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text("No hay elementos en la lista")
        }
    }
    
    private func addItem() {
        guard !newItem.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        withAnimation(.easeInOut) {
            items.append(newItem)
            newItem = ""
        }
    }
    
    private func removeItem(at index: Int) {
        withAnimation(.easeInOut) {
            items.remove(at: index)
            if items.isEmpty {
                showingAlert = true
            }
        }
    }
    
    private func moveItems(from source: IndexSet, to destination: Int) {
        withAnimation {
            items.move(fromOffsets: source, toOffset: destination)
        }
    }
}

// MARK: - Formulario Simple
struct SimpleFormView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var age = 18
    @State private var isSubscribed = false
    @State private var selectedCategory = "General"
    @State private var showingAlert = false
    
    private let categories = ["General", "Tecnología", "Diseño", "Marketing"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información Personal")) {
                    TextField("Nombre", text: $name)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
                    Stepper("Edad: \(age)", value: $age, in: 18...100)
                }
                
                Section(header: Text("Preferencias")) {
                    Picker("Categoría", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Toggle("Suscribirse al newsletter", isOn: $isSubscribed)
                }
                
                Section {
                    Button("Enviar") {
                        submitForm()
                    }
                    .disabled(!isFormValid)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Formulario")
            .alert("Formulario enviado", isPresented: $showingAlert) {
                Button("OK") {
                    resetForm()
                }
            } message: {
                Text("Gracias por enviar tu información, \(name)!")
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && email.contains("@")
    }
    
    private func submitForm() {
        showingAlert = true
    }
    
    private func resetForm() {
        name = ""
        email = ""
        age = 18
        isSubscribed = false
        selectedCategory = "General"
    }
}

// MARK: - Placeholder Views
struct CustomGridView: View {
    var body: some View {
        Text("Custom Grid - En desarrollo")
            .navigationTitle("Grid")
    }
}

struct AdvancedStackView: View {
    var body: some View {
        Text("Advanced Stack - En desarrollo")
            .navigationTitle("Stack")
    }
}

struct TransitionsView: View {
    var body: some View {
        Text("Transitions - En desarrollo")
            .navigationTitle("Transiciones")
    }
}

struct GesturesView: View {
    var body: some View {
        Text("Gestures - En desarrollo")
            .navigationTitle("Gestos")
    }
}

#Preview("Basic Examples") {
    BasicExamplesView()
}

#Preview("Counter") {
    AnimatedCounterView()
}

#Preview("List") {
    InteractiveListView()
}

#Preview("Form") {
    SimpleFormView()
}
