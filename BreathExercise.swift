//
//  BreathExercise.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 06/07/2025.
//

import Foundation

protocol Exercise {
    var name: String { get }
    var totalDuration: TimeInterval { get }
}

@Observable class Exercises {
    
    let test1 = BreathExercise(
        name: "Test 1",
        description: "Test 1 description",
        breathPattern: BreathPattern(inhale: 4, exhale: 4, holdFull: 4, holdEmpty: 4)
    )
    
    let test2 = BreathExercise(
        name: "Test 2",
        description: "Test 2 description",
        breathPattern: BreathPattern(inhale: 2, exhale: 8, holdFull: 3, holdEmpty: 0)
    )
    
    let test3 = BreathExercise(
        name: "Test 3",
        description: "Test 1 description",
        breathPattern: BreathPattern(inhale: 10, exhale: 3, holdFull: 5, holdEmpty: 3)
    )
    
    let test4 = BreathExercise(
        name: "Test 4",
        description: "Test 2 description",
        breathPattern: BreathPattern(inhale: 2, exhale: 10, holdFull: 2, holdEmpty: 5)
    )
    
    var items = [BreathExercise]()
    
    init() {
        self.items = [test1, test2, test3, test4]
    }
    
    // var items = [BreathExercise]()
    
    // will require init with loading funcionality
}

struct BreathExercise: Exercise, Codable, Hashable, Identifiable {
    var id = UUID()
    var name = ""
    var description = ""
    
    var breathPattern: BreathPattern
    var cycles: Int = 5
    var totalDuration: TimeInterval {
        breathPattern.duration * TimeInterval(cycles)
    }
    
    var dateCreated = Date.now
    // date created (watch out for edit so the date isn't replaced by date edited
    var dateUsed = Date.now
}
