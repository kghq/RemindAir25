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
        
        TimelineView(.periodic(from: .now, by: 1.0)) { context in
            
            Spacer()
            
            // let _ = updateTime(context.date)
            let now = context.date
            let shift = session.shift(at: now)
            let displayDate = now
            
            // Preparation timer
            let prepRange = session.shiftedPrepRange(at: now)
            Text(displayDate, format: .timer(countingDownIn: prepRange))
                .font(.title2)
                .monospacedDigit()
                .foregroundStyle(.blue)
            
            // Phase Timers
            let shiftedPhases = session.shiftedPhases(by: shift)
            ForEach(shiftedPhases) { phase in
                Text(displayDate, format: .timer(countingDownIn: phase.start..<phase.end))
                    .monospacedDigit()
            }

            // Total Duration Timer
            let baseStart = session.appearTime.addingTimeInterval(session.preparationDuration)
            let totalStart = baseStart.addingTimeInterval(shift)
            let totalEnd = totalStart.addingTimeInterval(session.totalDuration)
            Text(displayDate, format: .timer(countingDownIn: totalStart..<totalEnd))
                .font(.largeTitle)
                .bold()
                .monospacedDigit()
                .foregroundStyle(.red)
            
            Spacer()
            
            // Buttons
            VStack {
                if !session.hasStarted {
                    ControlButton(label: "Start", action: session.start)
                }
                if session.isFinished {
                    ControlButton(label: "Start Again", action: session.reset)
                }
                if session.isRunning {
                    ControlButton(label: "Pause", action: session.pause)
                }
                if session.hasStarted && !session.isRunning {
                    ControlButton(label: "Resume", action: session.resume)
                }
                HStack {
                    ControlButton(label: "Reset", action: session.reset)
                        .disabled(session.isRunning || !session.hasStarted)
                    ControlButton(label: "Done", action: session.done)
                        .tint(.red)
                }
            }
            .padding()
            
        }
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

