//
//  ExerciseTimerMockup.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 14/07/2025.
//

import SwiftUI

struct ExerciseTimerMockup: View {
    var body: some View {
        
        Text("3 breaths to go")
        
        Spacer()
        VStack {
            
            Text("Inhale")
                .font(.largeTitle.smallCaps())
            //.font(.system(size: 40).smallCaps())
            Text("0:04")
            //.font(.largeTitle)
                .font(.system(size: 70))
                .monospacedDigit()
            
            ForEach(0...2, id: \.self) { _ in
                Text("0:02")
                    .font(.title2)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
        }
        .background(
            ZStack {
                Circle()
                    .foregroundStyle(.orange)
                    .frame(width: 320, height: 320)
                Circle()
                    .foregroundStyle(.background)
                    .frame(width: 300, height: 300)
            }
        )
        
        // make it with overlay or clipshape?
        
        Spacer()
        Text("5 breaths done")
        // Buttons
        VStack {
                ControlButtonMockup(label: "Start")
                    .tint(.blue)
            HStack {
                ControlButtonMockup(label: "Reset")
                    .disabled(true)
                ControlButtonMockup(label: "Done")
                    .tint(.red)
            }
        }
        .padding()
    }
}

struct ControlButtonMockup: View {
    
    let label: String
    
    var body: some View {
        Button {
            
        } label: {
            Text(label)
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    ExerciseTimerMockup()
}
