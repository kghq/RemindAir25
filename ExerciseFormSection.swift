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
            Section("Breath Pattern") {
                HStack {
                    Text("Inhale")
                    Spacer()
                    TextField("Inhale", value: $inhale, formatter: NumberFormatter())
                }
                HStack {
                    Text("Exhale")
                    Spacer()
                    TextField("Exhale", value: $exhale, formatter: NumberFormatter())
                }
                Toggle("Breath Hold", isOn: $holdingBreath.animation())
                if holdingBreath {
                    HStack {
                        Text("Full")
                        Spacer()
                        TextField("Hold Full", value: $holdFull, formatter: NumberFormatter())
                    }
                    HStack {
                        Text("Empty")
                        Spacer()
                        TextField("Hold Empty", value: $holdEmpty, formatter: NumberFormatter())
                    }
                }
            }
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            
            // Number of cycles and duration, and prep
            Section("Session pattern") {
                HStack {
                    Text("Breath Count")
                    Spacer()
                    TextField("Number of Breaths", value: $inhale, formatter: NumberFormatter())
                }
                HStack {
                    Text("Preparation Time")
                    Spacer()
                    TextField("Preparation time", value: $prepTime, formatter: NumberFormatter())
                }
            }
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            
            Section("Summary") {
                HStack {
                    Image(systemName: "wind")
                    Text("Breath Duration")
                    Spacer()
                    Text(breathDuration.formatAsWords())
                }
                .bold()
                HStack {
                    Image(systemName: "clock")
                    Text("Session Duration").bold()
                    Spacer()
                    Text(totalDuration.formatAsWords()).bold() + Text(" + ") +  Text(prepTime.formatAsWords())
                }
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
            holdFull: .constant(0),
            holdEmpty: .constant(0),
            cycles: .constant(5),
            prepTime: .constant(10),
            holdingBreath: .constant(true)
        )
    }
}
