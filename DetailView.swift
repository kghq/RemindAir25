//
//  DetailView.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 07/07/2025.
//

import SwiftUI

struct DetailView: View {
    
    @Binding var path: NavigationPath

    @Environment(Exercises.self) var exercises
    let exerciseID: UUID
    var exercise: BreathExercise? {
        exercises.items.first { $0.id == exerciseID }
    }
    
    @State private var showingEdit = false
    
    var body: some View {
        if let exercise = exercise {
            List {
                Text(exercise.description)
                Text("\(exercise.id)")
                Section("\(exercise.cycles) Cycles of") {
                    Text("Inhale: \(exercise.exhale.formatted()) sec and 3 sec hold")
                    Text("Exhale: \(exercise.exhale.formatted()) sec and 4 sec hold")
                    //Text("\(exercise.cycles) Cycles")
                }
                Section {
                    Button("Start 1 h 20 min Session") {
                        path.append(exercise.id)
                    }
                }
            }
            .navigationTitle(exercise.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: UUID.self) { id in
                TimerView()
            }
            .toolbar {
                ToolbarItem {
                    Button("Edit") {
                        showingEdit = true
                    }
                }
            }
            .sheet(isPresented: $showingEdit) {
                NavigationStack {
                    EditView(path: $path, exerciseID: exercise.id)
                }
            }
            
        // Nil handling
        } else {
            ContentUnavailableView("Exercise Not Found", systemImage: "exclamationmark.triangle")
        }
    }
}

#Preview {
    let model = Exercises.preview
    let id = model.items[0].id

    return DetailView(path: .constant(NavigationPath()), exerciseID: id)
        .environment(model)
}
