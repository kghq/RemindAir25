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
        
        TimelineView(.periodic(from: session.startDate, by: 1.0)) { context in
            
            Spacer()
            
            let displayDate = session.isRunning ? context.date : (session.frozenDate ?? context.date)
            
            ForEach(session.phases) { phase in
                Text(displayDate, format: .timer(countingDownIn: phase.start..<phase.end))
            }
            
            Text(displayDate, format: .timer(countingDownIn: session.startDate..<session.startDate.addingTimeInterval(session.totalDuration)))
                .font(.largeTitle)
                .bold()
                .monospacedDigit()
                .foregroundStyle(.red)
            
            Spacer()
            
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

