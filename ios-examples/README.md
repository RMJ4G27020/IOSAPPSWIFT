# 🍎 Ejemplos de SwiftUI con GitHub Copilot

Esta carpeta contiene ejemplos prácticos de desarrollo iOS con SwiftUI, diseñados específicamente para demostrar cómo GitHub Copilot puede acelerar y mejorar tu flujo de desarrollo en el ecosistema Apple.

## 📁 Estructura de Ejemplos

### 🎯 [BasicViews/](BasicViews/)
**Conceptos fundamentales de SwiftUI**
- **SwiftUIBasics.swift**: Views básicos, @State, listas, animaciones
- Contadores con animaciones
- Listas interactivas con swipe actions
- Formularios básicos y validación

```swift
// Ejemplo: Copilot genera automáticamente views con estado
struct ContadorView: View {
    @State private var contador = 0
    // Copilot completa con body, animaciones, y botones
}
```

### 🧭 [Navigation/](Navigation/)
**Navegación moderna y patrones de UI**
- **ModernNavigation.swift**: NavigationStack, TabView, sheets
- Navegación programática con NavigationPath
- Tabs con estados independientes
- Modales y sheets
- Deep linking patterns

```swift
// Ejemplo: Navegación moderna con iOS 16+
NavigationStack(path: $path) {
    PantallaInicioView(path: $path)
        .navigationDestination(for: DetalleDestino.self) { destino in
            // Copilot sugiere destinos apropiados
        }
}
```

### 🔗 [DataBinding/](DataBinding/)
**Gestión de estado y MVVM**
- **MVVMDataBinding.swift**: @State, @Binding, @ObservableObject
- ViewModels con @Published properties
- Comunicación parent-child con @Binding
- StateObject vs ObservedObject
- Formularios complejos

```swift
// Ejemplo: ViewModel con Combine
class UsuarioViewModel: ObservableObject {
    @Published var usuarios: [Usuario] = []
    @Published var isLoading = false
    // Copilot genera métodos CRUD automáticamente
}
```

### 🌐 [Networking/](Networking/)
**APIs REST y manejo de datos**
- **APIClient.swift**: URLSession, async/await, error handling
- Arquitectura de servicios de red
- Manejo de errores personalizado
- Loading states y retry logic
- Modelos Codable

```swift
// Ejemplo: Servicio de red con async/await
class NetworkService: ObservableObject {
    func fetchPosts() async throws -> [Post] {
        // Copilot genera implementación completa con error handling
    }
}
```

### 🏗️ [Architecture/](Architecture/)
**Patrones de arquitectura avanzados**
- **MVVMCoordinator.swift**: MVVM + Coordinator pattern
- Dependency injection
- Repository pattern
- Navigation coordination
- State management centralizado

```swift
// Ejemplo: Coordinator pattern
protocol Coordinator: ObservableObject {
    func navigate(to destination: any Hashable)
    // Copilot sugiere métodos de navegación
}
```

### 🧪 [Testing/](Testing/) *(Próximamente)*
**Testing con XCTest y SwiftUI**
- Unit tests para ViewModels
- UI tests para SwiftUI views
- Mocking de servicios
- Test de navegación
- Accessibility testing

### ♿ [Accessibility/](Accessibility/) *(Próximamente)*
**Implementaciones accesibles**
- VoiceOver integration
- Dynamic Type support
- Accessibility modifiers
- Localización
- Color contrast

### ⚡ [Performance/](Performance/) *(Próximamente)*
**Optimización y mejores prácticas**
- LazyStacks para listas grandes
- Memory management
- Image caching
- Background processing
- Profiling con Instruments

### 📱 [CompleteApps/](CompleteApps/) *(Próximamente)*
**Aplicaciones ejemplo completas**
- ToDo App completa
- Weather App con APIs
- Social Media feed
- E-commerce básico

## 🚀 Cómo Usar Estos Ejemplos

### 1. Con Xcode (Recomendado para iOS)
```bash
# Crea un nuevo proyecto SwiftUI en Xcode
# Copia el código de los ejemplos a tus views
# Ejecuta en el simulador o dispositivo
```

### 2. Con VS Code + GitHub Copilot
```bash
# Abre los archivos .swift en VS Code
# Estudia cómo Copilot sugiere completions
# Experimenta modificando los prompts en comentarios
```

### 3. Como Playground
```bash
# Crea un Swift Playground
# Copia secciones específicas para experimentar
# Prueba variaciones con ayuda de Copilot
```

## 💡 Patrones de Copilot para SwiftUI

### Comentarios Descriptivos
```swift
// Vista para mostrar perfil de usuario con imagen, nombre y bio
struct PerfilUsuarioView: View {
    // Copilot generará @State properties apropiados
    // y estructura de vista completa
}
```

### Naming Conventions
```swift
// Usa nombres descriptivos en Swift (camelCase)
struct ProductListView: View {  // ✅ PascalCase para tipos
    @State private var isLoading = false  // ✅ camelCase + prefijo descriptivo
    @State private var products: [Product] = []  // ✅ Tipo explícito
}
```

### Property Wrappers
```swift
// Copilot reconoce patrones de SwiftUI
@State private var localValue = ""          // Estado local
@Binding var sharedValue: String           // Comunicación parent-child
@StateObject private var viewModel = VM()  // Owner del ViewModel
@ObservedObject var injectedVM: VM         // ViewModel inyectado
@EnvironmentObject var globalData: GD     // Datos globales
```

### Arquitectura MVVM
```swift
// Patrón reconocido por Copilot
class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []      // Copilot sugiere @Published
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Copilot genera métodos CRUD automáticamente
    func loadTasks() async { }
    func addTask(_ task: Task) { }
    func deleteTask(id: UUID) { }
}
```

## 🔧 Configuración Recomendada

### VS Code Extensions
```json
{
    "recommendations": [
        "GitHub.copilot",
        "GitHub.copilot-chat",
        "sswg.swift-lang"
    ]
}
```

### Settings para Swift
```json
{
    "github.copilot.enable": {
        "*": true,
        "swift": true
    },
    "swift.path": "/usr/bin/swift",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.fixAll": true
    }
}
```

## 📚 Recursos Adicionales

### Documentación Apple
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Swift Language Guide](https://docs.swift.org/swift-book/)

### GitHub Copilot
- [Copilot for Swift](https://github.com/features/copilot)
- [Best Practices](https://docs.github.com/copilot/using-github-copilot/best-practices-for-using-github-copilot)

### Comunidad
- [Swift Forums](https://forums.swift.org/)
- [iOS Dev Weekly](https://iosdevweekly.com/)
- [SwiftUI Lab](https://swiftui-lab.com/)

## 🤝 Contribuir

¿Tienes un ejemplo interesante de SwiftUI + Copilot? ¡Nos encantaría verlo!

1. Fork este repositorio
2. Crea una nueva carpeta en `ios-examples/`
3. Agrega tu ejemplo con comentarios explicativos
4. Actualiza este README.md
5. Envía un Pull Request

### Guidelines para Contribuir
- **Código funcional**: Todos los ejemplos deben compilar y ejecutarse
- **Comentarios explicativos**: Explica qué hace cada parte del código
- **Convenciones Swift**: Sigue las convenciones estándar de Swift/SwiftUI
- **Documentación**: Actualiza READMEs y documentación relevante
- **Testing**: Incluye tests cuando sea apropiado

---

### 💡 Tip Pro
> Cuando uses Copilot con SwiftUI, comienza siempre con un comentario descriptivo de lo que quieres lograr. Menciona el tipo de vista, qué datos maneja, y qué interacciones debe tener. Copilot generará código más preciso y siguiendo las mejores prácticas de Apple.

**¡Feliz desarrollo iOS con GitHub Copilot! 🍎✨**
