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
                if exercises.items.isEmpty {
                    ContentUnavailableView("No Exercises", systemImage: "wind", description: Text("Tap \"+\" to create an Exercise"))
                } else {
                    List(exercises.items) { exercise in
                        NavigationLink(value: exercise) {
                            Text(exercise.name)
                        }
                    }
                }
            }
            .navigationTitle("Exercises")
            .navigationDestination(for: BreathExercise.self) { exercise in
                DetailView(exercise: exercise)
            }
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
            .environment(exercises)
        }
    }
}

#Preview {
    ContentView()
}
