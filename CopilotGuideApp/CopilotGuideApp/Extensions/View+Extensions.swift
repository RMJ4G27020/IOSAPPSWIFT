//
//  View+Extensions.swift
//  CopilotGuideApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 CopilotGuide. All rights reserved.
//

import SwiftUI

extension View {
    
    // MARK: - Card Style Extensions
    func cardStyle() -> some View {
        self
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    func modernCardStyle() -> some View {
        self
            .background(.regularMaterial)
            .cornerRadius(16)
            .shadow(color: .primary.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Button Style Extensions
    func primaryButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(12)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(.accentColor)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor.opacity(0.1))
            .cornerRadius(12)
    }
    
    // MARK: - Loading State Extensions
    func loadingOverlay(_ isLoading: Bool) -> some View {
        self.overlay(
            Group {
                if isLoading {
                    Color.black.opacity(0.3)
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.2)
                        )
                }
            }
        )
    }
    
    // MARK: - Navigation Extensions
    func navigationDestination<V: View>(
        for type: some Hashable.Type,
        @ViewBuilder destination: @escaping (type) -> V
    ) -> some View {
        self.navigationDestination(for: type, destination: destination)
    }
    
    // MARK: - Accessibility Extensions
    func accessibleCard(
        label: String,
        hint: String? = nil,
        value: String? = nil
    ) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityValue(value ?? "")
    }
    
    // MARK: - Animation Extensions
    func springAnimation() -> some View {
        self.animation(.spring(response: 0.6, dampingFraction: 0.8), value: UUID())
    }
    
    func bounceAnimation() -> some View {
        self.animation(.interpolatingSpring(stiffness: 300, damping: 10), value: UUID())
    }
    
    // MARK: - Conditional Modifiers
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    // MARK: - Error State Extensions
    func errorAlert(
        isPresented: Binding<Bool>,
        title: String = "Error",
        message: String
    ) -> some View {
        self.alert(title, isPresented: isPresented) {
            Button("OK") { }
        } message: {
            Text(message)
        }
    }
}

// MARK: - Color Extensions
extension Color {
    static let cardBackground = Color(.systemGroupedBackground)
    static let primaryText = Color(.label)
    static let secondaryText = Color(.secondaryLabel)
    static let accent = Color.accentColor
    
    // Custom brand colors
    static let copilotBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let copilotGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let copilotOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
}

// MARK: - Font Extensions
extension Font {
    static let largeTitle = Font.largeTitle.weight(.bold)
    static let title = Font.title2.weight(.semibold)
    static let headline = Font.headline.weight(.medium)
    static let body = Font.body
    static let caption = Font.caption.weight(.medium)
}
