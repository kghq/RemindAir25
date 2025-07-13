//
//  TestTimerView.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 11/07/2025.
//

import SwiftUI

struct TestTimerView: View {
    
    @Environment(Exercises.self) var exercises
    @Bindable var session: ExerciseSessionModel
    @Binding var path: NavigationPath
    
    var body: some View {
        
        Spacer()
        
        TimelineView(.periodic(from: .now, by: 1.0)) { context in
            
            let now = context.date
            let shift = session.shift(at: now)
            let displayDate = now
            let shiftedPhases = session.shiftedPhases(by: shift)

            ForEach(shiftedPhases) { phase in
                Text(displayDate, format: .timer(countingDownIn: phase.start..<phase.end))
                    .monospacedDigit()
            }

            let shiftedStart = session.appearTime.addingTimeInterval(shift)
            let shiftedEnd = shiftedStart.addingTimeInterval(session.totalDuration)
            Text(displayDate, format: .timer(countingDownIn: shiftedStart..<shiftedEnd))
                .font(.largeTitle)
                .bold()
                .monospacedDigit()
                .foregroundStyle(.red)
        }
        
        Spacer()
        
        // Buttons
        VStack {
            if !session.hasStarted {
                ControlButton(label: "Start", action: session.start)
            } else {
                if session.isRunning {
                    ControlButton(label: "Pause", action: session.pause)
                } else {
                    ControlButton(label: "Resume", action: session.resume)
                }
            }
            ControlButton(label: "Reset", action: session.reset)
                .disabled(session.isRunning || !session.hasStarted)
            ControlButton(label: "Done", action: session.done)
                .tint(.red)
        }
        .padding()
    }
}

struct ControlButton: View {
    
    let label: String
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
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
    let model = Exercises.preview
    let exercise = model.items[0]

    return TestTimerView(session: ExerciseSessionModel(from: exercise), path: .constant(NavigationPath()))
        .environment(model)
}

