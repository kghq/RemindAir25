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
    let startDate = Date.now
    
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
    }
    
    // Phase manager
    var currentPhase: BreathPhase? {
        guard currentPhaseIndex < phases.count else { return nil }
        return phases[currentPhaseIndex]
    }
    
    private func advanceToNextPhase() {
        currentPhaseIndex += 1
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
        // more code to come
    }
    
    func pause() {
        isRunning = false
        // more code to come
    }
    
    func resume() {
        isRunning = true
        // more code to come
    }

    func reset() {
        hasStarted = false
        isRunning = false
        currentPhaseIndex = 0
        // more code to come
    }
    
    // init
    init(from exercise: BreathExercise) {
        self.phases = []
        
        // Add inhale
        phases.append(BreathPhase(step: .inhale, duration: exercise.inhale))
        // Add holdFull
        if exercise.holdFull > 0 {
            phases.append(BreathPhase(step: .holdFull, duration: exercise.holdFull))
        }
        // Add exhale
        phases.append(BreathPhase(step: .exhale, duration: exercise.exhale))
        // Add holdEmpty
        if exercise.holdEmpty > 0 {
            phases.append(BreathPhase(step: .holdEmpty, duration: exercise.holdEmpty))
        }
    }
}
