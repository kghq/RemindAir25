//
//  AddView.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 06/07/2025.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(Exercises.self) var exercises
    
    @Bindable var model = ExerciseFormModel()
    
    var body: some View {
        
        NavigationStack {
            
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
                
                Button("Add Exercise") {
                    let newExercise = model.newExercise()
                    
                    exercises.items.append(newExercise)
                    ExerciseStore.save(exercises.items, to: "exercises.json")
                    
                    dismiss()
                }
                .disabled(!model.isValid())
            }
            .navigationTitle("Add New Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .scrollDismissesKeyboard(.immediately)
            // Zeroing the breath hold, when user toggled off
            .onChange(of: model.holdingBreath) {
                if model.holdingBreath == false {
                    model.holdFull = 0
                    model.holdEmpty = 0
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddView()
        .environment(Exercises())
}
