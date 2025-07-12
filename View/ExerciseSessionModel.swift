//
//  ExerciseSessionModel.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 11/07/2025.
//

import Foundation

@Observable class ExerciseSessionModel {
    
    // Setup values
    private(set) var currentPhaseIndex: Int = 0
    var startDate: Date
    let totalDuration: TimeInterval
    
    // track how much time the session has been paused in total
    var pauseOffset: TimeInterval = 0
    private var pauseStart: Date?
    
    var sessionEndDate: Date {
        startDate + totalDuration
    }
    
    // Phases store
    var phases: [BreathPhase]
    
    enum BreathStep: String {
        case inhale
        case holdFull
        case exhale
        case holdEmpty
    }
    
    struct BreathPhase: Identifiable {
        let id = UUID()
        let step: BreathStep
        let duration: TimeInterval
        
        var startDate: Date?
        var endDate: Date? {
            guard let startDate else { return nil }
            return startDate.addingTimeInterval(duration)
        }
    }
    
    // Timer controls
    var hasStarted = false
    var isRunning = false
    var isFinished: Bool {
        currentPhaseIndex >= phases.count
    }
    
    func start() {
        hasStarted = true
        isRunning = true
        startDate = Date.now
        pauseOffset = 0
        pauseStart = nil // why not zero?
        
        var currentTime = Date.now
        for i in phases.indices {
            phases[i].startDate = currentTime
            currentTime += phases[i].duration
        }
    }
    
    func pause() {
        isRunning = false
        pauseStart = Date.now
    }
    
    func resume() {
        guard !isRunning, let pausedAt = pauseStart else { return } // why do we check here, if isRunning is false?
        let pauseDuration = Date.now.timeIntervalSince(pausedAt)
        pauseOffset += pauseDuration
        pauseStart = nil
        isRunning = true

        // Adjust all timers to shift forward
        startDate += pauseDuration
        for i in phases.indices {
            phases[i].startDate = phases[i].startDate?.advanced(by: pauseDuration)
        }
    }

    func reset() {
        hasStarted = false
        isRunning = false
        pauseOffset = 0
        pauseStart = nil
        startDate = .distantFuture
        currentPhaseIndex = 0
        for i in phases.indices {
            phases[i].startDate = nil
        }
    }
    
    // Helpers
    func currentPhase(for date: Date) -> BreathPhase? {
        return phases.first(where: { phase in
            guard let start = phase.startDate, let end = phase.endDate else { return false }
            return start <= date && date < end
        })
    }
    
    func currentPhaseIndex(for date: Date) -> Int? {
        phases.firstIndex(where: { phase in
            guard let start = phase.startDate, let end = phase.endDate else { return false }
            return start <= date && date < end
        })
    }
    
    // init
    init(from exercise: BreathExercise) {
        self.phases = []
        self.startDate = .distantFuture
        self.totalDuration = exercise.totalDuration
        
        // Create a single breath
        var singleBreath = [BreathPhase]()
        // Add inhale
        singleBreath.append(BreathPhase(step: .inhale, duration: exercise.inhale))
        // Add holdFull
        if exercise.holdFull > 0 {
            singleBreath.append(BreathPhase(step: .holdFull, duration: exercise.holdFull))
        }
        // Add exhale
        singleBreath.append(BreathPhase(step: .exhale, duration: exercise.exhale))
        // Add holdEmpty
        if exercise.holdEmpty > 0 {
            singleBreath.append(BreathPhase(step: .holdEmpty, duration: exercise.holdEmpty))
        }
        
        // Single breath times breathCount
        for _ in 0..<exercise.breathCount {
            self.phases.append(contentsOf: singleBreath)
        }
    }
}
