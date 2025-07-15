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
    
    @State private var animatedPhaseID: UUID?
    
    var body: some View {
        
        TimelineView(.periodic(from: .now, by: 1.0)) { context in
            
            // let _ = updateTime(context.date)
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
                    Text(displayDate, format: .timer(countingDownIn: phase.start..<phase.end))
                        .font(index == 0 ? .system(size: 70) : .title3)
                        .foregroundStyle(index == 0 ? .primary : .secondary)
                        .monospacedDigit()
                        // .contentTransition(.numericText(value: ))
                        .transition(.opacity)
                        .id(phase.id) // Track identity for proper animation
                }
            }
            .animation(.easeIn(duration: 0.3), value: currentPhaseIndex)
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

    return ExerciseTimerView(session: ExerciseSessionModel(from: exercise), path: .constant(NavigationPath()))
        .environment(model)
}

struct PhaseTimerView: View {
    let phase: Phase
    let isCurrent: Bool
    let now: Date

    var body: some View {
        VStack {
            Text(label(for: phase.type))
                .font(isCurrent ? .largeTitle.smallCaps() : .caption)
                .foregroundStyle(isCurrent ? .primary : .secondary)
            Text(now, format: .timer(countingDownIn: phase.start..<phase.end))
                .font(isCurrent ? .system(size: 70) : .title2)
                .monospacedDigit()
                .foregroundStyle(isCurrent ? .primary : .secondary)
        }
        .blur(radius: isCurrent ? 0 : 0.5)
        .opacity(isCurrent ? 1 : 0.6)
        .scaleEffect(isCurrent ? 1.0 : 0.9)
        .animation(.easeInOut(duration: 0.3), value: isCurrent)
    }

    func label(for type: BreathType) -> String {
        switch type {
        case .inhale: return "Inhale"
        case .exhale: return "Exhale"
        case .holdFull: return "Hold (In)"
        case .holdEmpty: return "Hold (Out)"
        }
    }
}
