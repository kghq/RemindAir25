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
    
    @State private var inhale: TimeInterval = 4
    @State private var exhale: TimeInterval = 6
    @State private var holdFull: TimeInterval = 0
    @State private var holdEmpty: TimeInterval = 0
    
    @State private var cycles: Double = 1
    
    @State private var holdingBreath = false
    
    var body: some View {
        
        // segmented picker for Exercises, WHM and Meditation
        
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $name)
                    //TextField("Description (optional)", text: $description)
                }
                
                Section("Description (optional)") {
                    TextEditor(text: $description)
                }
                
                Section("Breath Pattern") {
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
                }
                
                Section {
                    Toggle("Breath Hold", isOn: $holdingBreath.animation())
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
                
                Section("Number of Cycles") {
                    HStack {
                        Text("\(Int(cycles)) breaths")
                            .font(.subheadline.smallCaps())
                        Spacer()
                        Slider(value: $cycles, in: 1...100, step: 1)
                            .frame(width: 200)
                    }
                }
                
                // warmup, cool down
                
                Section("Total duration") {
                    let totalDuration = Int((inhale + exhale + holdFull + holdEmpty) * cycles)
                    Text("\(totalDuration) sec")
                }
                
                Button("Add Exercise") {
                    //let breathPattern = BreathPattern()
                    //let testExercise = BreathExercise(name: "Test", breathPattern: breathPattern, cycles: 3)
                    
                    let newBreathPattern = BreathPattern(inhale: inhale, exhale: exhale, holdFull: holdFull, holdEmpty: holdEmpty)
                    
                    let newBreathExercise = BreathExercise(name: name, description: description, breathPattern: newBreathPattern, cycles: Int(cycles))
                    
                    exercises.items.append(newBreathExercise)
                    dismiss()
                }
            }
            .navigationTitle("Add New Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
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
