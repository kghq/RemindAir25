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

// Helper for EditView
struct EditSheetID: Identifiable {
    var id: UUID
}

struct ContentView: View {
    
    @Bindable var exercises = Exercises()
    
    @State private var path = NavigationPath()
    
    @State private var showingAdd = false
    @State private var showingEdit = false
    @State private var editingID: EditSheetID?
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                
                // Main List
                if !exercises.items.isEmpty {
                    List(exercises.items) { exercise in
                        NavigationLink(value: Route.detail(exercise.id)) {
                            Text(exercise.name)
                        }
                        .swipeActions(edge: .leading) {
                            Button("Start") {
                                path.append(Route.timer(exercise.id))
                            }
                            .tint(.orange)
                        }
                        .swipeActions(edge: .trailing) {
                            Button("Delete", role: .destructive) {
                                if let index = exercises.items.firstIndex(where: { $0.id == exercise.id }) {
                                    exercises.items.remove(at: index)
                                    ExerciseStore.save(exercises.items, to: "exercises.json")
                                }
                            }
                        }
                        .contextMenu {
                            Button("Start", systemImage: "play.circle") {
                                path.append(Route.timer(exercise.id))
                            }
                            Button("Edit", systemImage: "pencil") {
                                editingID = EditSheetID(id: exercise.id)
                            }
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                if let index = exercises.items.firstIndex(where: { $0.id == exercise.id }) {
                                    exercises.items.remove(at: index)
                                    ExerciseStore.save(exercises.items, to: "exercises.json")
                                }
                            }
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
                    DetailView(path: $path, id: id)
                case .timer(let id):
                    if let exercise = exercises.items.first(where: { $0.id == id }) {
                        ExerciseTimerView(session: ExerciseSessionModel(from: exercise), path: $path)
                    } else {
                        ContentUnavailableView("Exercise not found", systemImage: "xmark.circle")
                    }
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
            .sheet(item: $editingID) { id in
                EditView(path: $path, id: id.id)
            }
        }
        .environment(exercises)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ContentView()
}
