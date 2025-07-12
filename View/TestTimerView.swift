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
    
    let dateFormatter = Date.FormatStyle(date: .omitted, time: .standard)
    
    var body: some View {
        
        TimelineView(.periodic(from: .now, by: 1)) { context in
            
            let displayDate = session.isRunning ? context.date : (session.frozenDate ?? context.date)
            
            // Total Duration
            if session.currentPhaseIndex < session.phases.count {
                Text(displayDate, format: .timer(countingDownIn: session.startDate..<session.sessionEndDate))
                    .font(.title).bold()
                    .monospacedDigit()
            }
            
            // Phases
                
            // Current Phase
            if session.currentPhaseIndex < session.phases.count {
                if let phase = session.currentPhase(for: context.date) {
                    HStack {
                        Text(displayDate, format: .timer(countingDownIn: phase.startDate..<phase.endDate))
                        //Text(phase.step.rawValue)
                    }
                    .foregroundStyle(.blue)
                } else {
                    Text(session.phases[0].duration.formatAsTimer())
                        .foregroundStyle(.blue)
                }
            }
            
            // Upcoming phases
            if let currentIndex = session.currentPhaseIndex(for: context.date) {
                let upcomingPhases = session.phases[currentIndex + 1..<(min(currentIndex + 3, session.phases.count))]
                ForEach(upcomingPhases) { phase in
                    HStack {
                        Text(phase.duration.formatAsTimer())
                        Text(phase.step.rawValue)
                    }
                    .foregroundStyle(.red)
                }
            } else {
                let upcomingPhases = session.phases[1..<3]
                ForEach(upcomingPhases) { phase in
                    HStack {
                        Text(phase.duration.formatAsTimer())
                        Text(phase.step.rawValue)
                    }
                    .foregroundStyle(.red)
                }
            }
        }
        
        Spacer()
        
        VStack {
            controlButton(label: "Start", action: session.start)
            controlButton(label: "Pause", action: session.pause)
            controlButton(label: "Resume", action: session.resume)
            controlButton(label: "Reset", action: session.reset)
            controlButton(label: "Done", action: session.reset)
            .tint(.red)
        }
        .padding()
    }
}

struct controlButton: View {
    
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

