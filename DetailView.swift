//
//  DetailView.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 07/07/2025.
//

import SwiftUI

struct DetailView: View {
    
    // @Binding var exercise: BreathExercise
    // How do i make it a binding?
    
    @State private var showingEdit = false
    
    var exercise: BreathExercise
    
    var body: some View {
        List {
            Text(exercise.description)
            Text("\(exercise.id)")
            Section("\(exercise.cycles) Cycles of") {
                Text("Inhale: \(exercise.breathPattern.exhale.formatted()) sec and 3 sec hold")
                Text("Exhale: \(exercise.breathPattern.exhale.formatted()) sec and 4 sec hold")
                //Text("\(exercise.cycles) Cycles")
            }
            Section {
                Button("Start 1 h 20 min Session") { }
            }
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: BreathExercise.self) { exercise in
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
            EditView(exercise: exercise)
        }
    }
}

#Preview {
//    DetailView(exercise: .constant(BreathExercise(name: "Test", breathPattern: BreathPattern())))
    DetailView(exercise: BreathExercise(name: "Test", breathPattern: BreathPattern()))
}
