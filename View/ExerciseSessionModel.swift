//
//  ExerciseSessionModel.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 11/07/2025.
//

import Foundation

@Observable class ExerciseSessionModel {
    
    var timer: TimerModel?
    
    var phases: [BreathPhase]
    private(set) var currentPhaseIndex: Int = 0
    
    var currentPhase: BreathPhase? {
        guard currentPhaseIndex < phases.count else { return nil }
        return phases[currentPhaseIndex]
    }
    
    enum BreathStep: String {
        case inhale
        case holdFull
        case exhale
        case holdEmpty
    }
    
    // Main part
    struct BreathPhase: Identifiable {
        let id = UUID()
        let step: BreathStep
        let duration: TimeInterval
    }
    
    var isFinished: Bool {
        currentPhaseIndex >= phases.count
    }
    
    func startPhaseTimer() {
        guard let phase = currentPhase else { return }

        timer = TimerModel(initialDuration: phase.duration)
        timer?.onFinished = { [weak self] in
            self?.advanceToNextPhase()
        }
        timer?.start()
    }
    
    func pause() {
        timer?.pause()
    }

    func reset() {
//        for i in phases.indices {
//            phases[i].remainingTime = phases[i].duration
//        }
        currentPhaseIndex = 0
        timer = nil
    }

    private func advanceToNextPhase() {
        currentPhaseIndex += 1
        if !isFinished {
            startPhaseTimer()
        } else {
            timer = nil
        }
    }
    
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
        if exercise.holdFull > 0 {
            phases.append(BreathPhase(step: .holdEmpty, duration: exercise.holdEmpty))
        }
    }
}
