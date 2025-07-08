//
//  EditView.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 07/07/2025.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(Exercises.self) var exercises
    let exerciseID: UUID
    var exercise: BreathExercise? {
        exercises.items.first { $0.id == exerciseID } // nil coalescing later
    }
    
    @State private var name = ""
    
    var body: some View {
        if let exercise = exercise {
            List {
                Section {
                    TextField(exercise.name, text: $name)
                }
                Section {
                    Button("Confirm Changes") {
                        // func that replaces old values with new
                    }
                }
                Section {
                    Button("Delete", role: .destructive) { }
                }
            }
            .navigationTitle("Edit \(exercise.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
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

    return DetailView(exerciseID: id)
        .environment(model)
}
