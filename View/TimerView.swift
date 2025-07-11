//
//  TimerView.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 07/07/2025.
//

import SwiftUI

struct TimerView: View {
    
    @State private var sessionModel: ExerciseSessionModel? = nil
    @Environment(Exercises.self) var exercises
    @Binding var path: NavigationPath
    
    var offsetFormatter: SystemFormatStyle.DateOffset {
        .offset(to: Date.now.addingTimeInterval((exercises.items[index ?? 0].totalDuration)), sign: .never)
    }
    let dateFormatter = Date.FormatStyle(date: .omitted, time: .standard)
    
    let id: UUID
    var index: Int? {
        exercises.items.firstIndex(where: { $0.id == id })
    }
    
    var body: some View {
        if let index = index, let session = sessionModel {
            
            TimelineView(.periodic(from: session.startDate, by: 1)) { context in
                
                VStack {
                    Spacer()
                    
                    // Main
                        
                    // Timers
                    
                    // Prepare
                    
                    //Total Duration
                    
                    // Phases
                    ForEach(session.phases) { phase in
                        if session.currentPhase?.id == phase.id {
                            Text(phase.duration.formatAsTimer())
                                .monospacedDigit()
                                .font(.largeTitle)
                            // .foregroundStyle(.primary)
                        } else {
                            Text(phase.duration.formatAsTimer())
                                .font(.largeTitle)
//                                .font(.title2)
//                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    // Button Start / Pause
                    if session.isRunning {
                        
                        // Pause
                        Button {
                            session.pause()
                            // path.removeLast()
                        } label: {
                            Text("Pause")
                                .font(.title3)
                                .bold()
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .tint(.blue)
                        .padding()
                        
                    } else {
                        
                        // Start
                        if session.startDate == Date.now {
                            Button {
                                exercises.items[index].dateLastUsed = Date.now
                                
                            } label: {
                                if session.startDate != Date.now {
                                    Text("Start")
                                        .font(.title3)
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                } else {
                                    Text("Resume")
                                        .font(.title3)
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .padding()
                        }
                    }
                    
                    Spacer()
                    
                    // Button Reset
                    Button {
                        session.reset()
                        // path.removeLast()
                    } label: {
                        Text("Reset")
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .padding()
                    .disabled(session.isRunning) // hasStarted, or something
                    //}
                    
                    // Button done
                    Button {
                        path.removeLast()
                    } label: {
                        Text("Done")
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    .padding(.horizontal)
                    
                }
            }
            .onAppear {
                // load the session
                let exercise = exercises.items[index]
                sessionModel = ExerciseSessionModel(from: exercise)
            }
            
        // Guard against no timer
        } else {
            ContentUnavailableView("No Timer Found", systemImage: "wind")
        }
    }
}

#Preview {
    let model = Exercises.preview
    let id = model.items[0].id

    return TimerView(path: .constant(NavigationPath()), id: id)
        .environment(model)
}
