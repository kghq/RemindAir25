//
//  ExerciseSessionModel.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 11/07/2025.
//

import Foundation

@Observable class ExerciseSessionModel {
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
    
    init(from exercise: BreathExercise) {
        phases = []
        
        // Add inhale
        phases.append(BreathPhase(step: .inhale, duration: exercise.inhale))
        // Add holdFull
        if exercise.holdFull > 0 {
            phases.append(BreathPhase(step: .holdFull, duration: exercise.holdFull))
        }
        // Add exhale
        phases.append(BreathPhase(step: .exhale, duration: exercise.exhale))
        // Add holdEmpty
        if exercise.holdFull > 0 {
            phases.append(BreathPhase(step: .holdEmpty, duration: exercise.holdEmpty))
        }
    }
}
