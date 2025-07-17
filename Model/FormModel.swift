//
//  FormModel.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 09/07/2025.
//

import Foundation

@Observable class ExerciseFormModel {
    var name: String = ""
    var description: String = ""
    
    var inhale = TimeInterval(4)
    var exhale = TimeInterval(6)
    var holdFull = TimeInterval(0)
    var holdEmpty = TimeInterval(0)
    
    var breathCount = 1.0
    var prepTime = TimeInterval(0)
    var holdingBreath = false
    
    init() { }

    func load(from exercise: BreathExercise) {
        name = exercise.name
        description = exercise.description
        inhale = exercise.inhale
        exhale = exercise.exhale
        holdFull = exercise.holdFull
        holdEmpty = exercise.holdEmpty
        breathCount = Double(exercise.breathCount)
        prepTime = exercise.prepTime
        holdingBreath = (holdFull > 0 || holdEmpty > 0)
    }
    
    func newExercise() -> BreathExercise {
        BreathExercise(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description,
            inhale: inhale,
            exhale: exhale,
            holdFull: holdFull,
            holdEmpty: holdEmpty,
            prepTime: prepTime,
            breathCount: Int(breathCount)
        )
    }
    
    func applyChanges(to exercise: inout BreathExercise) {
        exercise.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        exercise.description = description
        exercise.inhale = inhale
        exercise.exhale = exhale
        exercise.holdFull = holdFull
        exercise.holdEmpty = holdEmpty
        exercise.breathCount = Int(breathCount)
        exercise.prepTime = prepTime
    }
    
    func isValid() -> Bool {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        guard inhale > 0 || exhale > 0 else { return false }
        guard inhale < 601 && exhale < 601 && holdFull < 601 && holdEmpty < 601 else { return false }
        guard breathCount > 0 else { return false }
        
        return true
    }
    // validation goes here
}
