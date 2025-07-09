//
//  TimerView.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 07/07/2025.
//

import SwiftUI

struct TimerView: View {
    
    @Environment(Exercises.self) var exercises
    @Binding var path: NavigationPath
    let id: UUID
    
    var exercise: BreathExercise? {
        exercises.items.first(where: { $0.id == id })
    }
    
    var index: Int? {
        exercises.items.firstIndex(where: { $0.id == id })
    }
    
    var body: some View {
        if let exercise = exercise {
            Text(formatAsTimer(exercise.totalDuration))
                .font(.largeTitle)
            Button("Start") {
                if let index = index {
                    exercises.items[index].dateLastUsed = Date.now
                }
            }
            Button("Cancel") {
                path.removeLast()
            }
        }
    }
    
    func formatAsTimer(_ interval: TimeInterval) -> String {
        let totalSeconds = Int(interval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
}

#Preview {
    let model = Exercises.preview
    let id = model.items[0].id

    return TimerView(path: .constant(NavigationPath()), id: id)
        .environment(model)
}
