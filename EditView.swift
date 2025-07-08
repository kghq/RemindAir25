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
        exercises.items.first { $0.id == exerciseID }
    }
    
    @State private var name = ""
    @State private var description = ""
    
    @State private var inhale = TimeInterval( 0 )
    @State private var exhale = TimeInterval( 0 )
    @State private var holdFull = TimeInterval( 0 )
    @State private var holdEmpty = TimeInterval( 0 )
    
    @State private var cycles = 1.0
    @State private var holdingBreath = false
    
    var totalDuration: Double {
        (inhale + exhale + holdFull + holdEmpty) * cycles
    }
    
    var body: some View {
        if let exercise = exercise {
            List {
                
                // Name and description
                Section {
                    TextField(exercise.name, text: $name)
                    TextField(exercise.description, text: $description)
                }
                
                // Breath Pattern
                Section {
                    HStack {
                        Text("Inhale: \(inhale.formatted()) sec")
                            .font(.subheadline.smallCaps())
                        Spacer()
                        Slider(value: $inhale, in: 1...100, step: 1)
                            .frame(width: 200)
                    }
                    HStack {
                        Text("Exhale: \(exhale.formatted()) sec")
                            .font(.subheadline.smallCaps())
                        Spacer()
                        Slider(value: $exhale, in: 1...100, step: 1)
                            .frame(width: 200)
                    }
                    Toggle("Breath Hold", isOn: $holdingBreath.animation())
                        .font(.subheadline.smallCaps())
                    if holdingBreath {
                        HStack {
                            Text("Full: \(holdFull.formatted()) sec")
                                .font(.subheadline.smallCaps())
                            Spacer()
                            Slider(value: $holdFull, in: 1...100, step: 1)
                                .frame(width: 200)
                        }
                        HStack {
                            Text("Empty: \(holdEmpty.formatted()) sec")
                                .font(.subheadline.smallCaps())
                            Spacer()
                            Slider(value: $holdEmpty, in: 1...100, step: 1)
                                .frame(width: 200)
                        }
                    }
                }
                
                // Number of cycles and duration
                Section {
                    HStack {
                        Text("\(Int(cycles)) breaths")
                            .font(.subheadline.smallCaps())
                        Spacer()
                        Slider(value: $cycles, in: 1...100, step: 1)
                            .frame(width: 200)
                    }
                    HStack {
                        Spacer()
                        Text("Total Duration: \(totalDuration.formatted())")
                            .bold()
                        Spacer()
                    }
                }
                
                Section {
                    Button("Confirm Changes") {
                        var newExercise = BreathExercise()
                        newExercise.name = name
                        newExercise.description = description
                        
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

    return EditView(exerciseID: id)
        .environment(model)
}
