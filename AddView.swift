//
//  AddView.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 06/07/2025.
//

import SwiftUI

//struct BreathSelectorView: View {
//    
//    @Binding var breathPattern: BreathPattern
//    
//    var body: some View {
//        HStack {
//            Spacer()
//            Text("Exhale: \(breathPattern.inhale.formatted()) sec")
//                .font(.subheadline.smallCaps())
//            Spacer()
//        }
//            Slider(value: $breathPattern.inhale, in: 1...200, step: 1) {
//                Text("Bob")
//            }
////            Text("\(breathPattern.inhale.formatted()) sec")
////                .font(.subheadline.smallCaps())
////                .frame(width: 60)
//        //}
//    }
//}

struct AddView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(Exercises.self) var exercises
    
    @State private var name: String = ""
    @State private var description: String = ""
    
    @State private var inhale = TimeInterval(4)
    @State private var exhale = TimeInterval(6)
    @State private var holdFull = TimeInterval(0)
    @State private var holdEmpty = TimeInterval(0)
    
    @State private var cycles = 1.0
    @State private var prepTime = TimeInterval(0)
    @State private var holdingBreath = false
    
    var breathDuration: TimeInterval {
        inhale + exhale + holdFull + holdEmpty
    }
    
    var totalDuration: Double {
        breathDuration * cycles
    }
    
    var body: some View {
        
        // segmented picker for Exercises, WHM and Meditation
        
        NavigationStack {
            Form {
                
                // Name and description
                Section {
                    TextField("Name", text: $name)
                    TextField("Description (optional)", text: $description)
                }
                
                // Breath Pattern
                Section("Breath Duration") {
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
                        Spacer()
                        Text("\(breathDuration.formatted()) sec")
                            .bold()
                    }
                }
                
                // Number of cycles, duration, and prep
                Section("Total Duration") {
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
                        Spacer()
                        Text("\(totalDuration.formatted()) + \(prepTime.formatted()) sec Prep")
                            .bold()
                    }
                }
                
                Button("Add Exercise") {
                    let newBreathExercise = BreathExercise(
                        name: name,
                        description: description,
                        inhale: inhale,
                        exhale: exhale,
                        holdFull: holdFull,
                        holdEmpty: holdEmpty,
                        prepTime: prepTime,
                        cycles: Int(cycles)
                    )
                    
                    exercises.items.append(newBreathExercise)
                    
                    ExerciseStore.save(exercises.items, to: "exercises.json")
                    
                    dismiss()
                }
            }
            .navigationTitle("Add New Exercise")
            .navigationBarTitleDisplayMode(.inline)
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
