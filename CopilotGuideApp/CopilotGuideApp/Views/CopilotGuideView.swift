//
//  CopilotGuideView.swift
//  CopilotGuideApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 CopilotGuide. All rights reserved.
//

import SwiftUI

struct CopilotGuideView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Conceptos Básicos") {
                    NavigationLink("¿Qué es Copilot?", destination: WhatIsCopilotView())
                    NavigationLink("Configuración Inicial", destination: InitialSetupView())
                    NavigationLink("Primeros Pasos", destination: FirstStepsView())
                }
                
                Section("Mejores Prácticas") {
                    NavigationLink("Escribir Buenos Prompts", destination: GoodPromptsView())
                    NavigationLink("Patrones SwiftUI", destination: SwiftUIPatternsView())
                    NavigationLink("Arquitectura MVVM", destination: MVVMArchitectureView())
                }
                
                Section("Técnicas Avanzadas") {
                    NavigationLink("Networking con Copilot", destination: NetworkingTechniquesView())
                    NavigationLink("Testing y Debugging", destination: TestingDebuggingView())
                    NavigationLink("Performance Tips", destination: PerformanceTipsView())
                }
                
                Section("Recursos") {
                    NavigationLink("Shortcuts de Teclado", destination: KeyboardShortcutsView())
                    NavigationLink("Comandos de Chat", destination: ChatCommandsView())
                    NavigationLink("Troubleshooting", destination: TroubleshootingView())
                }
            }
            .navigationTitle("Guía de Copilot")
        }
    }
}

// MARK: - What is Copilot
struct WhatIsCopilotView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                
                Text("¿Qué es GitHub Copilot?")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("GitHub Copilot es un asistente de programación con inteligencia artificial que te ayuda a escribir código más rápido y con mayor precisión.")
                    .font(.body)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Características principales:")
                        .font(.headline)
                    
                    FeatureRow(icon: "lightbulb", title: "Sugerencias Inteligentes", description: "Completa automáticamente líneas y bloques de código")
                    FeatureRow(icon: "message", title: "Chat Interactivo", description: "Conversa con Copilot para resolver problemas")
                    FeatureRow(icon: "doc.text", title: "Explicaciones", description: "Explica código complejo de forma clara")
                    FeatureRow(icon: "wrench.and.screwdriver", title: "Refactoring", description: "Mejora y optimiza código existente")
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Beneficios para SwiftUI:")
                        .font(.headline)
                    
                    BenefitRow(icon: "swift", title: "Sintaxis Swift", description: "Conoce las mejores prácticas de Swift y SwiftUI")
                    BenefitRow(icon: "iphone", title: "Patrones iOS", description: "Implementa patrones específicos de desarrollo iOS")
                    BenefitRow(icon: "paintbrush", title: "UI Components", description: "Crea interfaces de usuario modernas y accesibles")
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("¿Qué es Copilot?")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title3)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .font(.title3)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Initial Setup
struct InitialSetupView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Configuración Inicial")
                    .font(.title)
                    .fontWeight(.bold)
                
                setupStep(number: 1, title: "Instalar VS Code", description: "Descarga e instala Visual Studio Code desde code.visualstudio.com")
                
                setupStep(number: 2, title: "Instalar Extensión", description: "Busca 'GitHub Copilot' en el marketplace de extensiones e instálala")
                
                setupStep(number: 3, title: "Iniciar Sesión", description: "Conecta tu cuenta de GitHub y activa tu suscripción")
                
                setupStep(number: 4, title: "Configurar Swift", description: "Instala la extensión de Swift Language Support")
                
                Divider()
                
                Text("Configuración Recomendada")
                    .font(.headline)
                
                CodeBlockView(code: """
{
    "github.copilot.enable": {
        "*": true,
        "swift": true,
        "markdown": true
    },
    "editor.inlineSuggest.enabled": true,
    "editor.suggest.preview": true
}
""")
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Configuración")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func setupStep(number: Int, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Circle()
                .fill(Color.blue)
                .frame(width: 32, height: 32)
                .overlay {
                    Text("\(number)")
                        .foregroundColor(.white)
                        .font(.headline)
                        .fontWeight(.bold)
                }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct CodeBlockView: View {
    let code: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .font(.system(.caption, design: .monospaced))
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

// MARK: - First Steps
struct FirstStepsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Primeros Pasos")
                    .font(.title)
                    .fontWeight(.bold)
                
                TipCard(
                    icon: "hand.tap",
                    title: "Acepta Sugerencias",
                    description: "Presiona Tab para aceptar la sugerencia de Copilot",
                    color: .blue
                )
                
                TipCard(
                    icon: "arrow.left.arrow.right",
                    title: "Navega Opciones",
                    description: "Usa Alt+] y Alt+[ para ver diferentes sugerencias",
                    color: .green
                )
                
                TipCard(
                    icon: "message",
                    title: "Usa el Chat",
                    description: "Ctrl+Enter abre el panel de chat para hacer preguntas",
                    color: .orange
                )
                
                TipCard(
                    icon: "doc.text",
                    title: "Comentarios Claros",
                    description: "Escribe comentarios descriptivos para mejores sugerencias",
                    color: .purple
                )
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Primeros Pasos")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TipCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay {
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.title2)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 2)
        }
    }
}

// MARK: - Placeholder Views
struct GoodPromptsView: View {
    var body: some View {
        Text("Good Prompts - En desarrollo")
            .navigationTitle("Buenos Prompts")
    }
}

struct SwiftUIPatternsView: View {
    var body: some View {
        Text("SwiftUI Patterns - En desarrollo")
            .navigationTitle("Patrones SwiftUI")
    }
}

struct MVVMArchitectureView: View {
    var body: some View {
        Text("MVVM Architecture - En desarrollo")
            .navigationTitle("Arquitectura MVVM")
    }
}

struct NetworkingTechniquesView: View {
    var body: some View {
        Text("Networking Techniques - En desarrollo")
            .navigationTitle("Técnicas de Red")
    }
}

struct TestingDebuggingView: View {
    var body: some View {
        Text("Testing & Debugging - En desarrollo")
            .navigationTitle("Testing y Debug")
    }
}

struct PerformanceTipsView: View {
    var body: some View {
        Text("Performance Tips - En desarrollo")
            .navigationTitle("Tips de Performance")
    }
}

struct KeyboardShortcutsView: View {
    var body: some View {
        Text("Keyboard Shortcuts - En desarrollo")
            .navigationTitle("Atajos de Teclado")
    }
}

struct ChatCommandsView: View {
    var body: some View {
        Text("Chat Commands - En desarrollo")
            .navigationTitle("Comandos de Chat")
    }
}

struct TroubleshootingView: View {
    var body: some View {
        Text("Troubleshooting - En desarrollo")
            .navigationTitle("Solución de Problemas")
    }
}

#Preview("Copilot Guide") {
    CopilotGuideView()
}

#Preview("What is Copilot") {
    WhatIsCopilotView()
}

#Preview("Initial Setup") {
    InitialSetupView()
}
