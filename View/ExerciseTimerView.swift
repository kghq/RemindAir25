//
//  TestTimerView.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 11/07/2025.
//

import SwiftUI

struct ExerciseTimerView: View {
    
    @Environment(Exercises.self) var exercises
    @Bindable var session: ExerciseSessionModel
    @Binding var path: NavigationPath
    
    var body: some View {
        
        TimelineView(.periodic(from: .now, by: 1.0)) { context in
        
            let now = context.date
            let shift = session.shift(at: now)
            let displayDate = now
            
            // Preparation timer
            let prepRange = session.shiftedPrepRange(at: now)
            Text(displayDate, format: .timer(countingDownIn: prepRange))
                .monospacedDigit()
                .padding()
            
            Spacer()
            
            // Phase Timers
            let shiftedPhases = session.shiftedPhases(by: shift)
            let currentPhaseIndex = shiftedPhases.firstIndex(where: { $0.start <= now && now < $0.end })
            let displayPhases = Array(shiftedPhases.dropFirst(currentPhaseIndex ?? 0).prefix(session.oneBreathPattern))
            VStack {
                Text(shiftedPhases[currentPhaseIndex ?? 0].label)
                    .font(.largeTitle.smallCaps())
                    .animation(.easeInOut(duration: 0.1), value: currentPhaseIndex)
                ForEach(Array(displayPhases.enumerated()), id: \.element.id) { index, phase in
                    // let secondsRemaining = Double(phase.end.timeIntervalSince(now))
                    Text(displayDate, format: .timer(countingDownIn: phase.start..<phase.end))
                        .font(index == 0 ? .system(size: 70) : .title3)
                        .foregroundStyle(index == 0 ? .primary : .secondary)
                        .monospacedDigit()
                        .transition(.opacity)
                        .id(phase.id) // Track identity for proper animation
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
            
            Spacer()
            
            // Total Duration Timer
            let baseStart = session.appearTime.addingTimeInterval(session.preparationDuration)
            let totalStart = baseStart.addingTimeInterval(shift)
            let totalEnd = totalStart.addingTimeInterval(session.totalDuration)
            Text(displayDate, format: .timer(countingDownIn: totalStart..<totalEnd))
                .monospacedDigit()
            
            // Buttons
            VStack {
                if !session.hasStarted || session.isFinished {
                    ControlButton(label: "Start", action: session.start)
                        .tint(.blue)
                        .disabled(session.isFinished)
                }
//                if session.isFinished {
//                    ControlButton(label: "Start Again", action: session.reset)
//                        .tint(.blue)
//                }
                if session.isRunning && !session.isFinished {
                    ControlButton(label: "Pause", action: session.pause)
                        .tint(.blue)
                }
                if session.hasStarted && !session.isRunning {
                    ControlButton(label: "Resume", action: session.resume)
                        .tint(.blue)
                }
                HStack {
                    if !session.isFinished {
                        ControlButton(label: "Reset", action: session.reset)
                            .disabled(session.isRunning || !session.hasStarted)
                    } else {
                        ControlButton(label: "Reset", action: session.reset)
                    }
                    ControlButton(label: "Done", action: session.done)
                        .tint(.red)
                }
            }
            .padding()
            
        }
    }
    
    func formattedTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", minutes, secs)
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
                .padding(5)
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    let model = Exercises.preview
    let exercise = model.items[0]

    return ExerciseTimerView(session: ExerciseSessionModel(from: exercise), path: .constant(NavigationPath()))
        .environment(model)
}
