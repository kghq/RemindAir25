//
//  EditView.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 07/07/2025.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var exercise: BreathExercise
    
    @State private var name = ""
    
    var body: some View {
        List {
            Section {
                TextField(exercise.name, text: $name)
            }
            Section {
                Button("Confirm Changes") {
                    // replace old one with new
                }
            }
            Section {
                Button("Delete", role: .destructive) { }
            }
        }
        .toolbar {
            ToolbarItem {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    EditView(exercise: BreathExercise(name: "Test", breathPattern: BreathPattern()))
    // EditView(exercise: .constant(BreathExercise(breathPattern: BreathPattern())))
}
