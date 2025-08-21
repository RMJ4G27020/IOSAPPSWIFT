# Recursos Adicionales para GitHub Copilot

## Configuraciones Avanzadas

### settings.json de VS Code
```json
{
    // Configuración de GitHub Copilot
    "github.copilot.enable": {
        "*": true,
        "yaml": true,
        "plaintext": false,
        "markdown": true,
        "json": true,
        "javascript": true,
        "typescript": true,
        "python": true
    },
    "github.copilot.advanced": {
        "length": 500,
        "temperature": 0.5,
        "top_p": 0.9
    },
    "github.copilot.chat.followUps": "always",
    "github.copilot.chat.localeOverride": "es",
    
    // Configuraciones complementarias
    "editor.inlineSuggest.enabled": true,
    "editor.quickSuggestions": {
        "other": true,
        "comments": true,
        "strings": true
    },
    "editor.suggest.showInlineDetails": true,
    "editor.suggest.preview": true
}
```

### Configuración por Proyecto
```json
// .vscode/settings.json
{
    "github.copilot.enable": {
        "*": true,
        "markdown": false
    },
    "github.copilot.chat.followUps": "onFocus",
    
    // Configuraciones específicas del proyecto
    "python.defaultInterpreterPath": "./venv/bin/python",
    "eslint.workingDirectories": ["src", "tests"]
}
```

## Prompts Efectivos para Copilot Chat

### Prompts para Desarrollo
```
🔍 Análisis de Código:
"@copilot /explain Explica qué hace esta función línea por línea y sugiere mejoras"

🛠️ Refactoring:
"@copilot /optimize Refactoriza este código para hacerlo más eficiente y legible"

🧪 Testing:
"@copilot /test Genera tests unitarios completos con casos edge para esta función"

📝 Documentación:
"@copilot /doc Genera documentación JSDoc/Sphinx detallada para este módulo"

🐛 Debugging:
"@copilot /fix Este código tiene un error de lógica, ayúdame a identificarlo y corregirlo"
```

### Prompts Especializados
```
🏗️ Arquitectura:
"Diseña la arquitectura de una aplicación [tipo] siguiendo el patrón [patrón] en [lenguaje]"

🔐 Seguridad:
"Revisa este código e identifica posibles vulnerabilidades de seguridad"

⚡ Performance:
"Optimiza este algoritmo para mejorar su complejidad temporal y espacial"

🎨 UI/UX:
"Crea un componente React accesible para [funcionalidad] siguiendo las mejores prácticas"
```

## Snippets y Templates

### Python Templates
```python
# Template para API Flask
"""
@copilot Crea una API Flask con:
- Endpoints CRUD para [entidad]
- Validación de datos con marshmallow
- Manejo de errores personalizado
- Logging configurado
- Tests unitarios con pytest
"""

# Template para análisis de datos
"""
@copilot Genera un script de análisis de datos que:
- Cargue datos desde [fuente]
- Realice limpieza y transformación
- Genere visualizaciones con matplotlib/seaborn
- Exporte resultados a [formato]
"""
```

### JavaScript Templates
```javascript
// Template para componente React
/*
@copilot Crea un componente React que:
- Use hooks (useState, useEffect, useContext)
- Maneje formularios con validación
- Integre con API REST
- Incluya loading states y error handling
- Sea responsive y accesible
*/

// Template para Node.js microservice
/*
@copilot Desarrolla un microservicio con Express que:
- Implemente autenticación JWT
- Use middleware de validación
- Conecte con MongoDB/PostgreSQL
- Incluya logging y monitoreo
- Tenga documentación OpenAPI
*/
```

## Workflow de Desarrollo con Copilot

### 1. Planificación
```markdown
## Checklist de Desarrollo

### Análisis Inicial
- [ ] Definir requisitos funcionales
- [ ] Identificar dependencias
- [ ] Diseñar arquitectura base
- [ ] Configurar entorno de desarrollo

### Desarrollo
- [ ] Crear estructura de proyecto
- [ ] Implementar modelos/entidades
- [ ] Desarrollar lógica de negocio
- [ ] Crear interfaces/APIs
- [ ] Implementar frontend (si aplica)

### Testing y QA
- [ ] Tests unitarios
- [ ] Tests de integración
- [ ] Tests E2E
- [ ] Code review
- [ ] Performance testing

### Deployment
- [ ] Configurar CI/CD
- [ ] Preparar documentación
- [ ] Deploy a staging
- [ ] Deploy a producción
```

### 2. Comandos de Desarrollo
```bash
# Setup inicial con Copilot CLI
gh copilot suggest "inicializar proyecto Python con FastAPI"

# Durante desarrollo
@copilot "generar dockerfile para esta aplicación Flask"
@copilot "crear script de migración de base de datos"
@copilot "configurar pytest con coverage"

# Para deployment
@copilot "generar archivo docker-compose para desarrollo"
@copilot "crear workflow de GitHub Actions para CI/CD"
```

## Integración con Herramientas

### Git y GitHub
```bash
# Mensajes de commit con Copilot
gh copilot suggest "escribir mensaje de commit para estas changes"

# Pull request templates
# .github/pull_request_template.md
## Descripción
<!-- @copilot genera descripción basada en los cambios -->

## Checklist
- [ ] Tests agregados/actualizados
- [ ] Documentación actualizada
- [ ] Code review completado
- [ ] Sin breaking changes
```

### CI/CD con GitHub Actions
```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  # @copilot genera jobs para:
  # - Linting y formatting
  # - Tests unitarios
  # - Tests de integración
  # - Build y deployment
  # - Security scanning
```

## Mejores Prácticas por Lenguaje

### Python
```python
# Configuración específica para Python
"""
@copilot Al trabajar con Python:
- Usa type hints siempre
- Sigue PEP 8 para estilo
- Implementa logging apropiado
- Maneja excepciones específicas
- Usa virtual environments
- Incluye docstrings detallados
"""

import logging
from typing import Optional, List, Dict
from dataclasses import dataclass

@dataclass
class User:
    id: int
    name: str
    email: str
    active: bool = True
    
    def __post_init__(self):
        # @copilot generará validaciones
        pass
```

### JavaScript/TypeScript
```typescript
// Configuración para JS/TS
/*
@copilot Para JavaScript/TypeScript:
- Usa TypeScript cuando sea posible
- Implementa proper error handling
- Usa async/await sobre promises
- Aplica principios funcionales
- Optimiza para performance
- Sigue convenciones de naming
*/

interface ApiResponse<T> {
    data: T;
    success: boolean;
    message?: string;
}

class ApiClient {
    private baseUrl: string;
    
    constructor(baseUrl: string) {
        this.baseUrl = baseUrl;
    }
    
    // @copilot generará métodos HTTP
}
```

## Troubleshooting Avanzado

### Problemas Comunes
```json
{
    "problemas_frecuentes": {
        "copilot_no_responde": {
            "causas": [
                "Conexión a internet inestable",
                "Límites de API alcanzados",
                "Extensión desactualizada"
            ],
            "soluciones": [
                "Verificar conectividad",
                "Reiniciar VS Code",
                "Actualizar extensión",
                "Limpiar cache de VS Code"
            ]
        },
        "sugerencias_irrelevantes": {
            "causas": [
                "Contexto insuficiente",
                "Nombres poco descriptivos",
                "Configuración incorrecta"
            ],
            "soluciones": [
                "Agregar comentarios detallados",
                "Usar naming conventions",
                "Ajustar configuración de temperatura",
                "Proporcionar ejemplos"
            ]
        }
    }
}
```

### Comandos de Diagnóstico
```bash
# Verificar estado de Copilot
code --list-extensions | grep copilot
gh auth status
gh copilot status

# Logs de debugging
# Abrir Developer Tools en VS Code
# Help > Toggle Developer Tools
# Console > buscar errores de copilot
```

## Recursos de Aprendizaje

### Cursos y Tutoriales
- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [Copilot Best Practices Guide](https://github.blog/2023-06-20-how-to-write-better-prompts-for-github-copilot/)
- [VS Code Copilot Extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)

### Comunidad y Soporte
- [GitHub Community](https://github.com/community)
- [Stack Overflow - GitHub Copilot](https://stackoverflow.com/questions/tagged/github-copilot)
- [Reddit r/github](https://reddit.com/r/github)

### Blogs y Artículos
- GitHub Blog - Copilot updates
- Microsoft DevBlog - Copilot features
- Community tutorials y case studies

## Métricas y Análisis

### Tracking de Productividad
```javascript
// Ejemplo de tracking personal
const copilotMetrics = {
    suggestions_accepted: 0,
    suggestions_rejected: 0,
    time_saved_minutes: 0,
    lines_generated: 0,
    
    calculateAcceptanceRate() {
        return this.suggestions_accepted / 
               (this.suggestions_accepted + this.suggestions_rejected);
    },
    
    // @copilot generará más métodos de análisis
};
```

Esta guía de recursos te ayudará a aprovechar al máximo GitHub Copilot en tus proyectos de desarrollo.
