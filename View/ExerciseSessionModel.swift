//
//  ExerciseSessionModel.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 11/07/2025.
//

// BUG: totalduration runs on pause

import Foundation

// Phase: Breath digested into an exercise
enum BreathType {
    case inhale, holdFull, exhale, holdEmpty
}

struct Phase: Identifiable {
    var id = UUID()
    var type: BreathType
    
    var start: Date
    var end: Date
}

@Observable class ExerciseSessionModel {
    
    // Foundational properties
    var appearTime = Date.now
    let preparationDuration: TimeInterval
    var currentTime = Date.now
    var totalDuration: TimeInterval
    var oneBreathPattern = 4
    
    var staticPhases: [Phase]
    
    var currentPhaseIndex: Int? { // For animations
        staticPhases.firstIndex(where: { $0.start <= Date.now && Date.now < $0.end })
    }
    
    // Preparation logic
    func prepDone(at date: Date) -> Bool {
        date >= appearTime.addingTimeInterval(preparationDuration + effectivePauseDuration)
    }
    
    func shiftedPrepRange(at date: Date) -> Range<Date> {
        let shift = isRunning ? pauseDuration : pauseDuration + date.timeIntervalSince(pauseTime)
        let start = appearTime.addingTimeInterval(shift)
        return start..<start.addingTimeInterval(preparationDuration)
    }
    
    // Pause/resume controls
    var hasStarted = false
    var isRunning = false
    var isFinished: Bool {
        totalDuration + effectivePauseDuration + preparationDuration <= Date.now.timeIntervalSince(appearTime)
    }
    var resumeTime = Date.now
    var pauseTime = Date.now
    var currentPause: TimeInterval {
        resumeTime.timeIntervalSince(pauseTime)
    }
    var pauseDuration = 0.0
    
    var effectivePauseDuration: TimeInterval {
        isRunning ? pauseDuration : pauseDuration + Date.now.timeIntervalSince(pauseTime)
    }
    
    func shiftedPhases(at date: Date) -> [Phase] {
        let shift = isRunning
            ? pauseDuration
            : pauseDuration + date.timeIntervalSince(pauseTime)

        return staticPhases.map {
            Phase(
                type: $0.type,
                start: $0.start.addingTimeInterval(shift),
                end: $0.end.addingTimeInterval(shift)
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
        appearTime = Date.now
        hasStarted = false
        isRunning = false
        pauseTime = appearTime
        resumeTime = appearTime
        pauseDuration = 0.0
    }
    
//    func reset() {
//        appearTime = Date.now
//        hasStarted = false
//    }
    
    func done() {
        // more code to come
    }
    
    // Helpers
    func shift(at date: Date) -> TimeInterval {
        isRunning ? pauseDuration : pauseDuration + date.timeIntervalSince(pauseTime)
    }

    func shiftedPhases(by shift: TimeInterval) -> [Phase] {
        staticPhases.map {
            Phase(
                type: $0.type,
                start: $0.start.addingTimeInterval(shift),
                end: $0.end.addingTimeInterval(shift)
            )
        }
    }
    
    init(from exercise: BreathExercise) {
        
        self.staticPhases = []
        self.preparationDuration = exercise.prepTime
        self.totalDuration = 0.0
        
        let realStartTime = appearTime.addingTimeInterval(preparationDuration)
        var phaseStart = realStartTime

        for _ in 0..<exercise.breathCount {
            staticPhases.append(Phase(
                type: .inhale,
                start: phaseStart,
                end: phaseStart.addingTimeInterval(exercise.inhale)
            ))
            phaseStart += exercise.inhale

            if exercise.holdFull > 0 {
                staticPhases.append(Phase(
                    type: .holdFull,
                    start: phaseStart,
                    end: phaseStart.addingTimeInterval(exercise.holdFull)
                ))
                phaseStart += exercise.holdFull
            }

            staticPhases.append(Phase(
                type: .exhale,
                start: phaseStart,
                end: phaseStart.addingTimeInterval(exercise.exhale)
            ))
            phaseStart += exercise.exhale

            if exercise.holdEmpty > 0 {
                staticPhases.append(Phase(
                    type: .holdEmpty,
                    start: phaseStart,
                    end: phaseStart.addingTimeInterval(exercise.holdEmpty)
                ))
                phaseStart += exercise.holdEmpty
            }
        }
        
        if exercise.holdFull == 0 && exercise.holdEmpty == 0 {
            oneBreathPattern = 2
        } else if exercise.holdFull == 0 || exercise.holdEmpty == 0 {
            oneBreathPattern = 3
        }

        self.totalDuration = phaseStart.timeIntervalSince(realStartTime)
    }
}
