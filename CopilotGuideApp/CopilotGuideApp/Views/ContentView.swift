//
//  ContentView.swift
//  CopilotGuideApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 CopilotGuide. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Ejemplos Básicos
            BasicExamplesView()
                .tabItem {
                    Label("Básicos", systemImage: "square.grid.2x2")
                }
                .tag(0)
            
            // Tab 2: MVVM Examples
            MVVMExamplesView()
                .tabItem {
                    Label("MVVM", systemImage: "arrow.triangle.branch")
                }
                .tag(1)
            
            // Tab 3: Networking
            NetworkingExamplesView()
                .tabItem {
                    Label("Network", systemImage: "network")
                }
                .tag(2)
            
            // Tab 4: Guía de Copilot
            CopilotGuideView()
                .tabItem {
                    Label("Guía", systemImage: "book")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
