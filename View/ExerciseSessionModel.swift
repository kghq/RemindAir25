//
//  ExerciseSessionModel.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 11/07/2025.
//

// BUG: totalduration runs on pause

import Foundation

@Observable class ExerciseSessionModel {
    
    // Setup values
    private(set) var currentPhaseIndex: Int = 0
    var startDate: Date
    var frozenDate: Date? = nil
    var totalDuration: TimeInterval
    
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
        
        var startDate: Date
        var endDate: Date {
            startDate + duration
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
        pauseStart = nil
        
        var currentTime = Date.now
        for i in phases.indices {
            phases[i].startDate = currentTime
            currentTime += phases[i].duration
        }
    }
    
    func pause() {
        isRunning = false
        pauseStart = Date.now
        frozenDate = .now
    }
    
    func resume() {
        guard !isRunning, let pausedAt = pauseStart else { return } // why do we check here, if isRunning is false?
        let pauseDuration = Date.now.timeIntervalSince(pausedAt)
        pauseOffset += pauseDuration
        pauseStart = nil
        frozenDate = nil
        isRunning = true

        // Adjust all timers to shift forward
        startDate += pauseDuration
        for i in phases.indices {
            phases[i].startDate = phases[i].startDate.advanced(by: pauseDuration)
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
            phases[i].startDate = .distantFuture
        }
    }
    
    // Helpers
    func currentPhase(for date: Date) -> BreathPhase? {
        return phases.first(where: { phase in
            let start = phase.startDate
            let end = phase.endDate
            return start <= date && date < end
        })
    }
    
    func currentPhaseIndex(for date: Date) -> Int? {
        phases.firstIndex(where: { phase in
            
            let start = phase.startDate
            let end = phase.endDate
            return start <= date && date < end
        })
    }
    
    // init
    init(from exercise: BreathExercise) {
        self.phases = []
        self.startDate = .distantFuture
        self.totalDuration = TimeInterval(0)
        
        // Create a single breath
        let currentTime = startDate
        var singleBreath = [BreathPhase]()
        // Add inhale
        singleBreath.append(BreathPhase(step: .inhale, duration: exercise.inhale, startDate: currentTime))
        // Add holdFull
        if exercise.holdFull > 0 {
            singleBreath.append(BreathPhase(step: .holdFull, duration: exercise.holdFull, startDate: currentTime))
        }
        // Add exhale
        singleBreath.append(BreathPhase(step: .exhale, duration: exercise.exhale, startDate: currentTime))
        // Add holdEmpty
        if exercise.holdEmpty > 0 {
            singleBreath.append(BreathPhase(step: .holdEmpty, duration: exercise.holdEmpty, startDate: currentTime))
        }
        
        // Single breath times breathCount
        for _ in 0..<exercise.breathCount {
            self.phases.append(contentsOf: singleBreath)
        }
        
        for breath in phases {
            totalDuration += breath.duration
        }
    }
}
