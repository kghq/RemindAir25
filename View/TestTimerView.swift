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
    let id: UUID
    
    let dateFormatter = Date.FormatStyle(date: .omitted, time: .standard)
    
    var index: Int? {
        exercises.items.firstIndex(where: { $0.id == id })
    }
    
    var body: some View {
        
        if let index {
            TimelineView(.periodic(from: .now, by: 1)) { context in
                
                // Total Duration
                if session.isRunning {
                    Text(context.date, format: .timer(countingDownIn: session.startDate..<session.sessionEndDate))
                        .font(.title).bold()
                        .monospacedDigit()
                } else {
                    Text(exercises.items[index].totalDuration.formatAsTimer())
                        .font(.title).bold()
                        .monospacedDigit()
                }
                
                // Phases
                    
                // Current Phase
                if session.isRunning {
                    if let phase = session.currentPhase(for: context.date) {
                        if let start = phase.startDate, let end = phase.endDate {
                            Text(context.date, format: .timer(countingDownIn: start..<end))
                                .foregroundStyle(.green)
                        }
                    }
                } else {
                    Text(session.phases[0].duration.formatAsTimer())
                }
                
                // Upcoming phases
                if session.isRunning {
                    if let currentIndex = session.currentPhaseIndex(for: context.date) {
                        let upcomingPhases = session.phases[currentIndex + 1..<(min(currentIndex + 3, session.phases.count))]
                        ForEach(upcomingPhases) { phase in
                            Text(phase.duration.formatAsTimer())
                                .foregroundStyle(.red)
                        }
                    }
                } else {
                    ForEach(session.phases.dropFirst().prefix(2)) { phase in
                        Text(phase.duration.formatAsTimer())
                            .foregroundStyle(.red)
                    }
                }
//                ForEach (session.phases) { phase in
//                    if let start = phase.startDate, let end = phase.endDate {
//                        Text(context.date, format: .timer(countingDownIn: start..<end))
//                    } else {
//                        Text(phase.duration.formatAsTimer())
//                    }
//                }
//                .font(.title)
//                .monospacedDigit()
            }
            Button("Start") {
                session.start()
            }
            
        // When Index Failed
        } else {
            ContentUnavailableView("No Timer Found", systemImage: "wind")
        }
    }
}

#Preview {
    let model = Exercises.preview
    let id = model.items[0].id
    let exercise = model.items[0]

    return TestTimerView(session: ExerciseSessionModel(from: exercise), path: .constant(NavigationPath()), id: id)
        .environment(model)
}

