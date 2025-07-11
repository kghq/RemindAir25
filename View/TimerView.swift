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
    
    @State private var timerModel: TimerModel? = nil // load the duration from exercise
    @State private var sessionModel: ExerciseSessionModel? = nil
    
    let id: UUID
    
    var index: Int? {
        exercises.items.firstIndex(where: { $0.id == id })
    }
    
    var body: some View {
        if let index = index {
            VStack {
                Spacer()
                
                // Main
                if let session = sessionModel, let timer = timerModel {
                    
                    // Timers
                    ForEach(session.phases) { phase in
                        if session.currentPhase?.id == phase.id {
                            Text(session.timer?.counter.formatAsTimer() ?? phase.duration.formatAsTimer())
                                .monospacedDigit()
                                .font(.largeTitle)
//                                .foregroundStyle(.primary)
                        } else {
                            Text(phase.duration.formatAsTimer())
                                .font(.largeTitle)
//                                .font(.title2)
//                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    // Button Start / Pause
                    if timer.isRunning {
                        
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
                        if timer.counter != 0 {
                            Button {
                                exercises.items[index].dateLastUsed = Date.now
                                session.startPhaseTimer()
                            } label: {
                                if exercises.items[index].totalDuration != timer.counter {
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
                        session.reset()                        // path.removeLast()
                    } label: {
                        Text("Reset")
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .padding()
                    .disabled(timer.counter == exercises.items[index].totalDuration)
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
                } else {
                    ProgressView("Preparing timer…")
                }
                
            }
            .onAppear {
                // load the timer and session
                let exercise = exercises.items[index]

                sessionModel = ExerciseSessionModel(from: exercise)
                
                if let phase = sessionModel?.currentPhase {
                    timerModel = TimerModel(initialDuration: phase.duration)
                }
            }
            
        // Guard against no timer
        } else {
            ContentUnavailableView("No timer found.", systemImage: "wind")
        }
    }
}

#Preview {
    let model = Exercises.preview
    let id = model.items[0].id

    return TimerView(path: .constant(NavigationPath()), id: id)
        .environment(model)
}
