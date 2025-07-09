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
    
    @State private var name = ""
    @State private var description = ""
    
    @State private var inhale = TimeInterval(0)
    @State private var exhale = TimeInterval(0)
    @State private var holdFull = TimeInterval(0)
    @State private var holdEmpty = TimeInterval(0)
    
    @State private var cycles = 1.0
    @State private var prepTime = TimeInterval(0)
    @State private var holdingBreath = false
    
    @State private var showingConfirmationAlert = false
    
    var breathDuration: TimeInterval {
        inhale + exhale + holdFull + holdEmpty
    }
    
    var totalDuration: Double {
        breathDuration * cycles
    }
    
    var body: some View {
        if let index = index {
            Form {
                
                // Name and description
                Section {
                    TextField(exercises.items[index].name, text: $name)
                    TextField((exercises.items[index].description == "" ? "Add a description" : "Add a Description"), text: $description)
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
                    HStack {
                        Image(systemName: "wind")
                        Text("Breath Duration")
                        Spacer()
                        Text(breathDuration.formatAsWords())
                    }
                    .bold()
                }
                
                // Number of cycles and duration, and prep
                Section {
                    HStack {
                        Text("\(Int(cycles)) breaths")
                            .font(.subheadline.smallCaps())
                        Spacer()
                        Slider(value: $cycles, in: 1...100, step: 1)
                            .frame(width: 200)
                    }
                    HStack {
                        Text("\(prepTime.formatted()) sec prep")
                            .font(.subheadline.smallCaps())
                        Spacer()
                        Slider(value: $prepTime, in: 1...100, step: 1)
                            .frame(width: 200)
                    }
                    HStack {
                        Image(systemName: "clock")
                        Text("Total Duration")
                        Spacer()
                        //Text("\(totalDuration.formatAsWords()) + \(prepTime.formatAsWords()) Prep")
                    }
                    .bold()
                }
                
                // Confirm changes
                Section {
                    Button("Confirm Changes") {
                        
                        // Probably should go to its own funcion
                        exercises.items[index].name = name
                        exercises.items[index].description = description
                        
                        exercises.items[index].inhale = inhale
                        exercises.items[index].exhale = exhale
                        exercises.items[index].holdFull = holdFull
                        exercises.items[index].holdEmpty = holdEmpty
                        
                        exercises.items[index].cycles = Int(cycles)
                        
                        dismiss()
                    }
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
            
            // Toolbar
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            
            // Zeroing the breath hold, when user toggled off
            .onChange(of: holdingBreath) {
                if holdingBreath == false {
                    holdFull = 0
                    holdEmpty = 0
                }
            }
            
            // Setting the initial values to the edited exercise
            .onAppear {
                if let exercise = exercises.items.first(where: { $0.id == exerciseID }) {
                    name = exercise.name
                    description = exercise.description
                    inhale = exercise.inhale
                    exhale = exercise.exhale
                    holdFull = exercise.holdFull
                    holdEmpty = exercise.holdEmpty
                    cycles = Double(exercise.cycles)
                    if holdFull > 0 || holdEmpty > 0 {
                        holdingBreath = true
                    } else {
                        holdingBreath = false
                    }
                }
            }
            
            .alert("Delete The Exercise?", isPresented: $showingConfirmationAlert) {
                Button("Delete", role: .destructive) {
                    exercises.items.remove(at: index)
                    ExerciseStore.save(exercises.items, to: "exercises.json")
                    path = NavigationPath()
                }
                Button("Cancel", role: .cancel) { }
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

    return EditView(path: .constant(NavigationPath()), exerciseID: id)
        .environment(model)
}
