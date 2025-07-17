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

    @Binding var breathCount: Double
    @Binding var prepTime: TimeInterval
    @Binding var holdingBreath: Bool

    var breathDuration: TimeInterval {
        inhale + exhale + holdFull + holdEmpty
    }

    var totalDuration: TimeInterval {
        breathDuration * breathCount
    }
    
    var body: some View {
        
        Group {
            
            // Name and description
            Section {
                TextField("Name", text: $name)
                    .textInputAutocapitalization(.words)
                    .submitLabel(.return)
                TextField("Description (Optional)", text: $description, axis: .vertical)
            }
            
            // Breath Pattern
            Section("Breath Pattern") {
                HStack {
                    Spacer()
                    VStack {
                        Text("Inhale")
                            .font(.headline.smallCaps())
                        Picker("Inhale", selection: $inhale) {
                            ForEach(1..<241, id: \.self) { selection in
                                let formatted = formatTime(selection)
                                Text(formatted)
                                    .tag(TimeInterval(selection))
                                    .font(.headline)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 80, height: 100)
                    }
                    
                    VStack {
                        Text("Hold")
                            .font(.headline.smallCaps())
                        Picker("Hold Full", selection: $holdFull) {
                            ForEach(0..<241, id: \.self) { selection in
                                let formatted = formatTime(selection)
                                Text(formatted)
                                    .tag(TimeInterval(selection))
                                    .font(.headline)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 80, height: 100)
                    }
                    
                    VStack {
                        Text("Exhale")
                            .font(.headline.smallCaps())
                        Picker("Exhale", selection: $exhale) {
                            ForEach(1..<241, id: \.self) { selection in
                                let formatted = formatTime(selection)
                                Text(formatted)
                                    .tag(TimeInterval(selection))
                                    .font(.headline)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 80, height: 100)
                    }
                    
                    VStack {
                        Text("Hold")
                            .font(.headline.smallCaps())
                        Picker("Hold Empty", selection: $holdEmpty) {
                            ForEach(0..<241, id: \.self) { selection in
                                let formatted = formatTime(selection)
                                Text(formatted)
                                    .tag(TimeInterval(selection))
                                    .font(.headline)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 80, height: 100)
                    }
                    Spacer()
                }
//                Toggle("Breath Hold", isOn: $holdingBreath.animation())
//                if holdingBreath {
//                    HStack {
//                        Text("Full")
//                        Spacer()
//                        TextField("Hold Full", value: $holdFull, formatter: NumberFormatter())
//                            .bold()
//                    }
//                    HStack {
//                        Text("Empty")
//                        Spacer()
//                        TextField("Hold Empty", value: $holdEmpty, formatter: NumberFormatter())
//                            .bold()
//                    }
//                }
                HStack {
                    Image(systemName: "wind")
                    Text("Breath Duration")
                    Spacer()
                    Text(breathDuration.formatAsWords())
                }
            }
//            .keyboardType(.decimalPad)
//            .multilineTextAlignment(.trailing)
            
            // Number of cycles and duration, and prep
            Section("Breath Count") {
                HStack {
                    Spacer()
                    Picker("Number of Breaths", selection: $breathCount) {
                        ForEach(0..<241, id: \.self) { selection in
                            Text(selection.formatAsWords())
                                .tag(TimeInterval(selection))
                                .font(.headline)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 80, height: 100)
                    Spacer()
                }
                HStack {
                    Text("Preparation Time")
                    Spacer()
                    TextField("Preparation time", value: $prepTime, formatter: NumberFormatter())
                        .bold()
                }
            }
            .keyboardType(.decimalPad)
            
            Section("Summary") {
                HStack {
                    Image(systemName: "clock")
                    Text("Session Duration").bold()
                    Spacer()
                    Text(totalDuration.formatAsWords()).bold()
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
            breathCount: .constant(5),
            prepTime: .constant(10),
            holdingBreath: .constant(true)
        )
    }
}

func formatTime(_ seconds: Int) -> String {
    
    if seconds < 60 {
        return seconds.formatAsWords()
    }
    
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second]
    formatter.zeroFormattingBehavior = [.dropLeading]
    return formatter.string(from: TimeInterval(seconds)) ?? "0:00"
}


//.background(.red)
//                    TextField("Exhale", value: $exhale, formatter: NumberFormatter())
//                        .bold()
//                        .scrollDismissesKeyboard(.immediately)
