//
//  CopilotGuideAppUITests.swift
//  CopilotGuideAppUITests
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 CopilotGuide. All rights reserved.
//

import XCTest

final class CopilotGuideAppUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Configuración de interfaz de usuario
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Main Navigation Tests
    func testMainNavigationExists() throws {
        // Given
        let app = XCUIApplication()
        
        // When
        app.launch()
        
        // Then
        XCTAssertTrue(app.staticTexts["Copilot Guide"].exists)
    }
    
    func testTabNavigationWorks() throws {
        // Given
        let app = XCUIApplication()
        app.launch()
        
        // When & Then - Test tab navigation
        XCTAssertTrue(app.buttons["Ejemplos Básicos"].exists)
        XCTAssertTrue(app.buttons["MVVM"].exists)
        XCTAssertTrue(app.buttons["Networking"].exists)
    }

    // MARK: - Basic Examples Tests
    func testBasicExamplesNavigation() throws {
        // Given
        let app = XCUIApplication()
        app.launch()
        
        // When
        app.buttons["Ejemplos Básicos"].tap()
        
        // Then
        XCTAssertTrue(app.staticTexts["Ejemplos Básicos"].exists)
    }
    
    func testCounterFunctionality() throws {
        // Given
        let app = XCUIApplication()
        app.launch()
        
        // When
        app.buttons["Ejemplos Básicos"].tap()
        
        // Then - Verify counter elements exist
        XCTAssertTrue(app.staticTexts["Contador: 0"].exists)
        XCTAssertTrue(app.buttons["+"].exists)
        XCTAssertTrue(app.buttons["-"].exists)
    }

    // MARK: - MVVM Examples Tests
    func testMVVMExamplesNavigation() throws {
        // Given
        let app = XCUIApplication()
        app.launch()
        
        // When
        app.buttons["MVVM"].tap()
        
        // Then
        XCTAssertTrue(app.staticTexts["Ejemplos MVVM"].exists)
    }
    
    func testUserManagementExists() throws {
        // Given
        let app = XCUIApplication()
        app.launch()
        
        // When
        app.buttons["MVVM"].tap()
        
        // Then
        XCTAssertTrue(app.staticTexts["Gestión de Usuarios"].exists)
        XCTAssertTrue(app.textFields["Nombre de usuario"].exists)
    }

    // MARK: - Networking Tests
    func testNetworkingNavigation() throws {
        // Given
        let app = XCUIApplication()
        app.launch()
        
        // When
        app.buttons["Networking"].tap()
        
        // Then
        XCTAssertTrue(app.staticTexts["Ejemplos de Networking"].exists)
    }
    
    func testNetworkingButtons() throws {
        // Given
        let app = XCUIApplication()
        app.launch()
        
        // When
        app.buttons["Networking"].tap()
        
        // Then
        XCTAssertTrue(app.buttons["Cargar Posts"].exists)
        XCTAssertTrue(app.buttons["Cargar Usuarios"].exists)
        XCTAssertTrue(app.buttons["Cargar Fotos"].exists)
    }

    // MARK: - Performance Tests
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // Mide el tiempo de lanzamiento de la aplicación
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testNavigationPerformance() throws {
        // Given
        let app = XCUIApplication()
        app.launch()
        
        // When & Then - Measure navigation performance
        measure {
            app.buttons["Ejemplos Básicos"].tap()
            app.buttons["MVVM"].tap()
            app.buttons["Networking"].tap()
        }
    }

    // MARK: - Accessibility Tests
    func testAccessibilityLabels() throws {
        // Given
        let app = XCUIApplication()
        app.launch()
        
        // Then - Verify accessibility labels exist
        XCTAssertTrue(app.buttons["Ejemplos Básicos"].isAccessibilityElement)
        XCTAssertTrue(app.buttons["MVVM"].isAccessibilityElement)
        XCTAssertTrue(app.buttons["Networking"].isAccessibilityElement)
    }
}
