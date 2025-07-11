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
    
    @State private var startDate = Date.now
    
    let dateFormatter = Date.FormatStyle(date: .omitted, time: .standard)
    // Offset shows the distance between the displayed date and future date
    let futureDate = Date.now.addingTimeInterval(9)
    var offsetFormatter: SystemFormatStyle.DateOffset {
        .offset(to: futureDate, allowedFields: [.minute, .second], sign: .never)
    }
    // init(countingDownIn:showsHours:maxFieldCount:maxPrecision:)
    var timerDownStyle: SystemFormatStyle.Timer {
        .timer(countingDownIn: startDate..<futureDate)
    }
    
    var index: Int? {
        exercises.items.firstIndex(where: { $0.id == id })
    }
    
    var body: some View {
        
        if let index {
            Text(exercises.items[index].name)
            TimelineView(.periodic(from: startDate, by: 1)) { context in
                ForEach (session.phases) { phase in
                    Text(context.date, format: timerDownStyle)
                }
                .font(.title).bold()
                .monospacedDigit()
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

