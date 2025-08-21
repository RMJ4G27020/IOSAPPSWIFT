# CopilotGuideApp

Una aplicación iOS completa desarrollada con SwiftUI que demuestra las mejores prácticas para trabajar con GitHub Copilot en el desarrollo de aplicaciones iOS.

## 🚀 Características

### Ejemplos Incluidos
- **Ejemplos Básicos**: Controles SwiftUI fundamentales
- **Arquitectura MVVM**: Implementación completa con ViewModels
- **Networking**: Integración con APIs REST usando async/await
- **Gestión de Estado**: @State, @StateObject, @ObservableObject
- **Navegación**: NavigationView, NavigationLink, programática

### Arquitectura
- **MVVM (Model-View-ViewModel)**
- **Dependency Injection**
- **Protocol-Oriented Programming**
- **Combine Framework**
- **Async/Await**

## 📁 Estructura del Proyecto

```
CopilotGuideApp/
├── CopilotGuideApp/
│   ├── CopilotGuideApp.swift          # App principal
│   ├── Models/                         # Modelos de datos
│   │   ├── User.swift
│   │   ├── Task.swift
│   │   └── Post.swift
│   ├── Views/                          # Vistas SwiftUI
│   │   ├── ContentView.swift
│   │   ├── BasicExamplesView.swift
│   │   ├── MVVMExamplesView.swift
│   │   ├── NetworkingExamplesView.swift
│   │   └── CopilotGuideView.swift
│   ├── ViewModels/                     # ViewModels MVVM
│   │   ├── UserManagementViewModel.swift
│   │   ├── TodoViewModel.swift
│   │   └── NetworkingViewModels.swift
│   ├── Services/                       # Servicios
│   │   └── NetworkService.swift
│   ├── Extensions/                     # Extensiones
│   │   ├── String+Extensions.swift
│   │   └── View+Extensions.swift
│   └── Resources/                      # Recursos
├── CopilotGuideAppTests/              # Tests unitarios
└── CopilotGuideAppUITests/            # Tests de UI
```

## 🛠 Configuración

### Requisitos
- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

### Instalación
1. Clona el repositorio
2. Abre `CopilotGuideApp.xcodeproj` en Xcode
3. Selecciona tu simulador o dispositivo
4. Ejecuta ⌘ + R para compilar y ejecutar

## 📱 Funcionalidades

### Ejemplos Básicos
- ✅ Contador interactivo
- ✅ Lista con elementos dinámicos
- ✅ Formulario con validación
- ✅ Animaciones SwiftUI

### MVVM Examples
- ✅ Gestión de usuarios con ViewModel
- ✅ Lista de tareas (Todo List)
- ✅ Binding bidireccional
- ✅ Estados de carga y error

### Networking
- ✅ Peticiones HTTP con async/await
- ✅ Manejo de errores de red
- ✅ Estados de carga
- ✅ Caché de imágenes
- ✅ API REST completa

## 🧪 Testing

### Tests Unitarios
```bash
# Ejecutar tests desde terminal
xcodebuild test -scheme CopilotGuideApp -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Tests de UI
- Navegación entre pantallas
- Interacciones de usuario
- Validación de elementos
- Performance y accesibilidad

## 📚 Mejores Prácticas con Copilot

### 1. Estructura de Prompts
```swift
// MARK: - TODO: Implementar función para validar email
// Función que valide formato de email usando regex
// Debe devolver Bool y manejar casos edge
```

### 2. Comentarios Descriptivos
```swift
/// ViewModel responsable de gestionar el estado de los usuarios
/// Incluye operaciones CRUD y manejo de errores de red
class UserManagementViewModel: ObservableObject {
    // Implementación generada con Copilot
}
```

### 3. Patrones Consistentes
- Usar naming conventions de Swift
- Seguir principios SOLID
- Implementar protocolos para testing
- Manejar errores de forma consistente

## 🔧 Configuración de GitHub Copilot

Para obtener los mejores resultados, asegúrate de:

1. **Contexto claro**: Incluye comentarios descriptivos
2. **Nombres significativos**: Variables y funciones autoexplicativas
3. **Estructura consistente**: Sigue los patrones establecidos
4. **Testing**: Escribe tests que guíen la implementación

## 📖 Recursos Adicionales

- [Documentación Oficial de SwiftUI](https://developer.apple.com/documentation/swiftui/)
- [Guías de GitHub Copilot](https://docs.github.com/en/copilot)
- [Swift Style Guide](https://swift.org/documentation/api-design-guidelines/)

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork del repositorio
2. Crea una branch para tu feature
3. Añade tests para nueva funcionalidad
4. Envía un Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver `LICENSE` para más detalles.

---

**Desarrollado con ❤️ y GitHub Copilot**
