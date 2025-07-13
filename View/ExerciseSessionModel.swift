//
//  ExerciseSessionModel.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 11/07/2025.
//

// BUG: totalduration runs on pause

import Foundation

@Observable class ExerciseSessionModel {
    
    var totalDuration = TimeInterval(0)
    
    // Phase: Breath digested into an exercise
    struct Phase: Identifiable {
        var id = UUID()
        var start: Date
        var end: Date
    }
    
    var phases: [Phase]
    
    var startDate = Date.now
    
    // Pause/resume controls
    var hasStarted = false
    var isRunning = false
    var frozenDate: Date? = .now // for display
    // track how much time the session has been paused
    var pauseOffset: TimeInterval = 0
    private var pauseStart: Date? = .now
    
    func start() {
        hasStarted = true
        resume()
        // more code to come
    }
    
    func pause() {
        isRunning = false
        pauseStart = .now
        frozenDate = .now
    }
    
    func resume() {
        guard !isRunning, let pausedAt = pauseStart else { return }
        pauseOffset = Date.now.timeIntervalSince(pausedAt)
        pauseStart = nil
        frozenDate = nil
        isRunning = true
        
        // Adjust all timers to shift forward
        startDate += pauseOffset
        for i in phases.indices {
            phases[i].start = phases[i].start.advanced(by: pauseOffset)
            phases[i].end = phases[i].end.advanced(by: pauseOffset)
        }
    }
    
    func reset() {
        // more code to come
    }
    
    func done() {
        // more code to come
    }
    
    init(from exercise: BreathExercise) {
        
        self.phases = []
        
        for _ in 0..<exercise.breathCount {
            // Add inhale
            phases.append(Phase(
                start: startDate.addingTimeInterval(totalDuration),
                end: startDate.addingTimeInterval(exercise.inhale + totalDuration)
            ))
            totalDuration += exercise.inhale
            // Add holdIn
            phases.append(Phase(
                start: startDate.addingTimeInterval(totalDuration),
                end: startDate.addingTimeInterval(exercise.holdFull + totalDuration)
            ))
            totalDuration += exercise.holdFull
            // Add exhale
            phases.append(Phase(
                start: startDate.addingTimeInterval(totalDuration),
                end: startDate.addingTimeInterval(exercise.exhale + totalDuration)
            ))
            totalDuration += exercise.exhale
            // Add holdOut
            phases.append(Phase(
                start: startDate.addingTimeInterval(totalDuration),
                end: startDate.addingTimeInterval(exercise.holdEmpty + totalDuration)
            ))
            totalDuration += exercise.holdEmpty
        }
    }
    
    // init
//    init(from exercise: BreathExercise) {
//        self.phases = []
//        
//        // Create a single breath
//        let currentTime = startDate
//        var singleBreath = [BreathPhase]()
//        // Add inhale
//        singleBreath.append(BreathPhase(step: .inhale, duration: exercise.inhale, start: currentTime))
//        // Add holdFull
//        if exercise.holdFull > 0 {
//            singleBreath.append(BreathPhase(step: .holdFull, duration: exercise.holdFull, start: currentTime))
//        }
//        // Add exhale
//        singleBreath.append(BreathPhase(step: .exhale, duration: exercise.exhale, start: currentTime))
//        // Add holdEmpty
//        if exercise.holdEmpty > 0 {
//            singleBreath.append(BreathPhase(step: .holdEmpty, duration: exercise.holdEmpty, start: currentTime))
//        }
//        
//        // Single breath times breathCount
//        for _ in 0..<exercise.breathCount {
//            self.phases.append(contentsOf: singleBreath)
//        }
//        
//        for breath in phases {
//            totalDuration += breath.duration
//        }
//    }
}
