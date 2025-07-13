//
//  ExerciseSessionModel.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 11/07/2025.
//

// BUG: totalduration runs on pause

import Foundation

@Observable class ExerciseSessionModel {
    
    // Foundational properties
    let appearTime = Date.now
    var totalDuration: TimeInterval
    
    // Phase: Breath digested into an exercise
    enum BreathType {
        case inhale, holdFull, exhale, holdEmpty
    }
    
    struct Phase: Identifiable {
        var id = UUID()
        var type: BreathType
        var offset = 0.0
        
        var start: Date
        var end: Date
    }
    
    var staticPhases: [Phase]
    
    // Pause/resume controls
    var hasStarted = false
    var isRunning = false
    var resumeTime = Date.now
    var pauseTime = Date.now
    var currentPause: TimeInterval {
        resumeTime.timeIntervalSince(pauseTime)
    }
    var pauseDuration = 0.0
    
    var effectivePauseDuration: TimeInterval {
        isRunning ? pauseDuration : pauseDuration + Date.now.timeIntervalSince(pauseTime)
    }
    
    var adjustedPhases: [Phase] {
        return staticPhases.map {
            Phase(
                type: $0.type,
                start: $0.start.addingTimeInterval(effectivePauseDuration),
                end: $0.end.addingTimeInterval(effectivePauseDuration)
            )
        }
    }
    
    func start() {
        resumeTime = .now
        hasStarted = true
        isRunning = true
        
        pauseDuration += resumeTime.timeIntervalSince(pauseTime)
        
        // more code to come
    }
    
    func pause() {
        isRunning = false
        pauseTime = .now
    }
    
    func resume() {
        guard !isRunning else { return }
        
        resumeTime = .now
        pauseDuration += resumeTime.timeIntervalSince(pauseTime)
        isRunning = true
    }
    
    func reset() {
        // more code to come
    }
    
    func done() {
        // more code to come
    }
    
    init(from exercise: BreathExercise) {
        
        self.staticPhases = []
        self.totalDuration = 0.0
        
        for _ in 0..<exercise.breathCount {
            // Add inhale
            staticPhases.append(Phase(
                type: .inhale,
                start: appearTime.addingTimeInterval(totalDuration),
                end: appearTime.addingTimeInterval(exercise.inhale + totalDuration)
            ))
            totalDuration += exercise.inhale
            // Add holdFull
            if exercise.holdFull > 0 {
                staticPhases.append(Phase(
                    type: .holdFull,
                    start: appearTime.addingTimeInterval(totalDuration),
                    end: appearTime.addingTimeInterval(exercise.holdFull + totalDuration)
                ))
            }
            totalDuration += exercise.holdFull
            // Add exhale
            staticPhases.append(Phase(
                type: .exhale,
                start: appearTime.addingTimeInterval(totalDuration),
                end: appearTime.addingTimeInterval(exercise.exhale + totalDuration)
            ))
            totalDuration += exercise.exhale
            // Add holdEmpty
            if exercise.holdEmpty > 0 {
                staticPhases.append(Phase(
                    type: .holdEmpty,
                    start: appearTime.addingTimeInterval(totalDuration),
                    end: appearTime.addingTimeInterval(exercise.holdEmpty + totalDuration)
                ))
                totalDuration += exercise.holdEmpty
            }
        }
    }
}
