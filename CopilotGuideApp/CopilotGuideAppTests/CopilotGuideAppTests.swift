//
//  CopilotGuideAppTests.swift
//  CopilotGuideAppTests
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 CopilotGuide. All rights reserved.
//

import XCTest
@testable import CopilotGuideApp

final class CopilotGuideAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Configuración antes de cada test
    }

    override func tearDownWithError() throws {
        // Limpieza después de cada test
    }

    // MARK: - User Model Tests
    func testUserModelInitialization() throws {
        // Given
        let name = "Juan Pérez"
        let email = "juan@example.com"
        
        // When
        let user = User(name: name, email: email)
        
        // Then
        XCTAssertEqual(user.name, name)
        XCTAssertEqual(user.email, email)
        XCTAssertNotNil(user.id)
    }
    
    func testUserFullName() throws {
        // Given
        let user = User(name: "Ana García", email: "ana@example.com")
        
        // When
        let fullName = user.fullName
        
        // Then
        XCTAssertEqual(fullName, "Ana García")
    }

    // MARK: - Task Model Tests
    func testTaskModelInitialization() throws {
        // Given
        let title = "Tarea de prueba"
        let description = "Descripción de la tarea"
        
        // When
        let task = Task(title: title, description: description)
        
        // Then
        XCTAssertEqual(task.title, title)
        XCTAssertEqual(task.description, description)
        XCTAssertFalse(task.isCompleted)
        XCTAssertNotNil(task.id)
        XCTAssertNotNil(task.createdAt)
    }
    
    func testTaskCompletion() throws {
        // Given
        var task = Task(title: "Tarea", description: "Descripción")
        
        // When
        task.isCompleted = true
        
        // Then
        XCTAssertTrue(task.isCompleted)
    }

    // MARK: - String Extensions Tests
    func testEmailValidation() throws {
        // Given
        let validEmail = "test@example.com"
        let invalidEmail = "invalid-email"
        
        // When & Then
        XCTAssertTrue(validEmail.isValidEmail)
        XCTAssertFalse(invalidEmail.isValidEmail)
    }
    
    func testStringTrimming() throws {
        // Given
        let stringWithWhitespace = "  Hola Mundo  "
        
        // When
        let trimmed = stringWithWhitespace.trimmed
        
        // Then
        XCTAssertEqual(trimmed, "Hola Mundo")
    }
    
    func testStringTruncation() throws {
        // Given
        let longString = "Esta es una cadena muy larga"
        
        // When
        let truncated = longString.truncated(limit: 10)
        
        // Then
        XCTAssertEqual(truncated, "Esta es un...")
    }

    // MARK: - Performance Tests
    func testPerformanceExample() throws {
        // Mide el tiempo que tarda en ejecutarse
        self.measure {
            // Código a medir
            for _ in 0...1000 {
                let _ = User(name: "Test", email: "test@example.com")
            }
        }
    }
}
