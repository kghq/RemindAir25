//
//  EditView.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 07/07/2025.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    @Environment(Exercises.self) var exercises
    let exerciseID: UUID
    var index: Int? {
        exercises.items.firstIndex { $0.id == exerciseID }
    }
    
    @Bindable var model = ExerciseFormModel()
    
    @State private var showingConfirmationAlert = false
    
    var body: some View {
        if let index = index {
            Form {
                
                ExerciseFormSection(
                    name: $model.name,
                    description: $model.description,
                    inhale: $model.inhale,
                    exhale: $model.exhale,
                    holdFull: $model.holdFull,
                    holdEmpty: $model.holdEmpty,
                    cycles: $model.cycles,
                    prepTime: $model.prepTime,
                    holdingBreath: $model.holdingBreath
                )
                
                // Confirm changes
                Section {
                    Button("Confirm Changes") {
                        
                        // Probably should go to its own funcion
                        model.applyChanges(to: &exercises.items[index])
                        ExerciseStore.save(exercises.items, to: "exercises.json")
                        
                        dismiss()
                    }
                    .disabled(!model.isValid())
                }
                
                // Delete
                Section {
                    Button("Delete", role: .destructive) {
                        showingConfirmationAlert = true
                    }
                }
            }
            
            // Navigation
            .navigationTitle("Edit \(exercises.items[index].name)")
            .navigationBarTitleDisplayMode(.inline)
            
            // tap to dismiss the keyboard
            .scrollDismissesKeyboard(.immediately)
            
            // Toolbar
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            
            // Zeroing the breath hold, when user toggled off
            .onChange(of: model.holdingBreath) {
                if model.holdingBreath == false {
                    model.holdFull = 0
                    model.holdEmpty = 0
                }
            }
            
            // Setting the initial values to the edited exercise
            .onAppear {
                if let exercise = exercises.items.first(where: { $0.id == exerciseID }) {
                    model.load(from: exercise)
                }
            }
            
            .alert("Delete This Exercise?", isPresented: $showingConfirmationAlert) {
                Button("Delete", role: .destructive) {
                    exercises.items.remove(at: index)
                    ExerciseStore.save(exercises.items, to: "exercises.json")
                    path = NavigationPath()
                }
                Button("Cancel", role: .cancel) { }
            }
            
        // Nil handling
        } else {
            ContentUnavailableView("Exercise Not Found", systemImage: "wind")
        }
    }
}

#Preview {
    let exercises = Exercises.preview
    let exercise = exercises.items[0]
    let model = ExerciseFormModel()
    model.load(from: exercise)

    return EditView(
        path: .constant(NavigationPath()),
        exerciseID: exercise.id,
        model: model
    )
    .environment(exercises)
}
