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
    
    @Bindable var timerModel = TimerModel(initialDuration: 9000) // load the duration from exercise
    
    let id: UUID
    
    var index: Int? {
        exercises.items.firstIndex(where: { $0.id == id })
    }
    
    var body: some View {
        if let index = index {
            VStack {
                Spacer()
                
                // Time
                Text(timerModel.counterFormatted)
                    .font(.largeTitle)
                
                // Button Start / Pause
                if timerModel.isRunning {
                    Button {
                        timerModel.pause()
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
                    Button {
                        exercises.items[index].dateLastUsed = Date.now
                        timerModel.start()
                    } label: {
                        // correct line: if exercises.items[index].totalDuration != timerModel.counter {
                        if 9000 == timerModel.counter {
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
                
                Spacer()
                
                // Button Reset
                // correct line: if exercises.items[index].totalDuration != timerModel.counter {
                //if 9000 != timerModel.counter {
                    Button {
                        // correct line: timerModel.reset(to: exercises.items[index].totalDuration)
                        timerModel.reset(to: 9000)
                        // path.removeLast()
                    } label: {
                        Text("Reset")
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .padding()
                    .disabled(timerModel.counter == 9000)
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
            .onAppear {
                // load the timer
            }
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
