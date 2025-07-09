//
//  ExerciseFormView.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 09/07/2025.
//

import SwiftUI

struct ExerciseFormSection: View {
    
    @Binding var name: String
    @Binding var description: String

    @Binding var inhale: TimeInterval
    @Binding var exhale: TimeInterval
    @Binding var holdFull: TimeInterval
    @Binding var holdEmpty: TimeInterval

    @Binding var cycles: Double
    @Binding var prepTime: TimeInterval
    @Binding var holdingBreath: Bool

    var breathDuration: TimeInterval {
        inhale + exhale + holdFull + holdEmpty
    }

    var totalDuration: TimeInterval {
        breathDuration * cycles
    }
    
    var body: some View {
        
        Group {
            
            // Name and description
            Section {
                TextField("Name", text: $name)
                    .textInputAutocapitalization(.words)
                TextField("Description", text: $description)
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
                    Text("\(totalDuration.formatAsWords()) + \(prepTime.formatAsWords()) Prep")
                }
                .bold()
            }
        }
            
    }
}

#Preview {
    Form {
        ExerciseFormSection(
            name: .constant("Preview"),
            description: .constant("Description"),
            inhale: .constant(4),
            exhale: .constant(6),
            holdFull: .constant(2),
            holdEmpty: .constant(2),
            cycles: .constant(5),
            prepTime: .constant(10),
            holdingBreath: .constant(true)
        )
    }
}
