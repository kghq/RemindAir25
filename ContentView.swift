//
//  ContentView.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 06/07/2025.
//

import SwiftUI

enum Route: Hashable {
    case detail(UUID)
    case timer(UUID)
}

struct ContentView: View {
    
    @Bindable var exercises = Exercises()
    
    //@State private var path = FileManager.default.currentDirectoryPath
    @State private var path = NavigationPath()
    
    @State private var showingAdd = false
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                
                // Main List
                if !exercises.items.isEmpty {
                    List(exercises.items) { exercise in
                        NavigationLink(value: Route.detail(exercise.id)) {
                            Text(exercise.name)
                        }
                    }
                    
                // ContentUnavailableView
                } else {
                    ContentUnavailableView("No Exercises", systemImage: "wind", description: Text("Tap \"+\" to create an Exercise"))
                }
            }
            
            // Navigation
            .navigationTitle("Exercises")
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .detail(let id):
                    DetailView(path: $path, exerciseID: id)
                case .timer(let id):
                    TimerView(id: id)
                }
            }
            
            // Toolbar, Sheet
            .toolbar {
                ToolbarItem {
                    Button("Add", systemImage: "plus") {
                        showingAdd = true
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddView()
            }
        }
        .environment(exercises)
    }
}

#Preview {
    ContentView()
}
