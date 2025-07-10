//
//  DetailView.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 07/07/2025.
//

import SwiftUI

struct DetailView: View {
    
    @Binding var path: NavigationPath

    @Environment(Exercises.self) var exercises
    let id: UUID
    var exercise: BreathExercise? {
        exercises.items.first { $0.id == id }
    }
    
    @State private var showingEdit = false
    
    var body: some View {
        if let exercise = exercise {
            List {
                
                // Presentation
                VStack {
                    Image(systemName: "wind.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundStyle(.green)
                    Text(exercise.name)
                        .font(.title2.weight(.bold))
                        .frame(maxWidth: .infinity)
                    Text(exercise.description).multilineTextAlignment(.center)
                }
                .padding(.vertical)
                
                // Summary
                Section("Breath Pattern") {
                    HStack {
                        Spacer()
                        VStack {
                            Text(exercise.inhale.formatAsWords())
                            Text("in")
                                .font(.subheadline.smallCaps())
                        }
                        Image(systemName: "arrow.right")
                            .padding(.horizontal, 5)
                        VStack {
                            Text(exercise.holdFull.formatAsWords())
                            Text("hold")
                                .font(.subheadline.smallCaps())
                        }
                        Image(systemName: "arrow.right")
                            .padding(.horizontal, 5)
                        VStack {
                            Text(exercise.exhale.formatAsWords())
                            Text("out")
                                .font(.subheadline.smallCaps())
                        }
                        Image(systemName: "arrow.right")
                            .padding(.horizontal, 5)
                        VStack {
                            Text(exercise.holdEmpty.formatAsWords())
                            Text("hold")
                                .font(.subheadline.smallCaps())
                        }
                        Spacer()
                    }
                }
                
                // Summary
                Section("Summary") {
                    HStack {
                        Image(systemName: "wind")
                        Text("Breath Duration")
                        Spacer()
                        Text(exercise.breathDuration.formatAsWords())
                    }
                    HStack {
                        Image(systemName: "arrow.trianglehead.2.counterclockwise")
                        Text("Breath Count")
                        Spacer()
                        Image(systemName: "multiply")
                            .font(.footnote)
                        Text("\(exercise.breathCount)")
                    }
                    HStack {
                        Image(systemName: "clock")
                        Text("Session Duration")
                        Spacer()
                        Text(exercise.totalDuration.formatAsWords())
                    }
                    .bold()
                    HStack {
                        Text("Preparation Time")
                        Spacer()
                        Text("+ \(exercise.prepTime.formatAsWords())")
                    }
                }
                
                // Start
                Section {
                    Button {
                        path.append(Route.timer(exercise.id))
                    } label: {
                        HStack {
                            Image(systemName: "wind")
                            Text("Start a \(exercise.totalDuration.formatAsWords()) Session")
                                .bold()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .listRowBackground(Color.blue.opacity(0.1))
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Edit") {
                        showingEdit = true
                    }
                }
            }
            .sheet(isPresented: $showingEdit) {
                NavigationStack {
                    EditView(path: $path, id: exercise.id)
                }
            }
            
        // Nil handling
        } else {
            ContentUnavailableView("Exercise Not Found", systemImage: "exclamationmark.triangle")
        }
    }
}

#Preview {
    let model = Exercises.preview
    let id = model.items[0].id

    return DetailView(path: .constant(NavigationPath()), id: id)
        .environment(model)
}
