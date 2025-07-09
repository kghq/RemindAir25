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
    
    var cycles = 1.0
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
        cycles = Double(exercise.cycles)
        prepTime = exercise.prepTime
        holdingBreath = (holdFull > 0 || holdEmpty > 0)
    }
    
    func toExercise() -> BreathExercise {
        BreathExercise(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description,
            inhale: inhale,
            exhale: exhale,
            holdFull: holdFull,
            holdEmpty: holdEmpty,
            prepTime: prepTime,
            cycles: Int(cycles)
        )
    }
    
    func applyChanges(to exercise: inout BreathExercise) {
        exercise.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        exercise.description = description
        exercise.inhale = inhale
        exercise.exhale = exhale
        exercise.holdFull = holdFull
        exercise.holdEmpty = holdEmpty
        exercise.cycles = Int(cycles)
        exercise.prepTime = prepTime
    }
    
    // validation goes here
}
