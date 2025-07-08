//
//  ContentView.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 06/07/2025.
//

import SwiftUI

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
                        NavigationLink(value: exercise.id) {
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
            .navigationDestination(for: UUID.self) { id in
                DetailView(path: $path, exerciseID: id)
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
