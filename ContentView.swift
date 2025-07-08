//
//  ContentView.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 06/07/2025.
//

// swipe to delete, long press to edit and start
// data persistence (file manager)

import SwiftUI

struct ContentView: View {
    
    @Bindable var exercises = Exercises()
    
    //@State private var path = FileManager.default.currentDirectoryPath
    @State private var path = NavigationPath()
    
    @State private var showingAdd = false
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                
                // ContentUnavailableView
                if exercises.items.isEmpty {
                    ContentUnavailableView("No Exercises", systemImage: "wind", description: Text("Tap \"+\" to create an Exercise"))
                    
                // Main List
                } else {
                    List(exercises.items) { exercise in
                        NavigationLink(value: exercise.id) {
                            Text(exercise.name)
                        }
                    }
                }
            }
            
            // Navigation
            .navigationTitle("Exercises")
            .navigationDestination(for: UUID.self) { id in
                DetailView(exerciseID: id)
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
