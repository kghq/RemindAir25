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
                
                // Description
                if exercise.description != "" {
                    Text(exercise.description)
                }
                
                Text("Date Created: \(exercise.dateCreated.formatted())")
                Text("Date Used: \(exercise.dateLastUsed.formatted())")
                
                Section {
                    Text("INHALE: \(exercise.exhale.formatAsWords()) + \(exercise.exhale.formatAsWords())  HOLD")
                    Text("EXHALE: \(exercise.exhale.formatAsWords()) + \(exercise.exhale.formatAsWords()) HOLD")
                    Text("x \(exercise.cycles) Cycles = \(exercise.totalDuration.formatAsWords()) + \(exercise.prepTime.formatAsWords()) PREP")
                }
                Section {
                    Button("Start a \(exercise.totalDuration.formatAsWords()) Session") {
                        path.append(Route.timer(exercise.id))
                    }
                }
            }
            .navigationTitle(exercise.name)
            .navigationBarTitleDisplayMode(.inline)
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
