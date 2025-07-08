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

extension Exercises {
    static var preview: Exercises {
        let model = Exercises()
        model.items = [
            BreathExercise(
                name: "Preview Exercise",
                description: "Preview Description",
                cycles: 5
            )
        ]
        return model
    }
}

@Observable class Exercises {
    
    let test1 = BreathExercise(
        name: "Test 1",
        description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
    )
    
    let test2 = BreathExercise(
        name: "Test 2",
        description: "Test 2 description",
    )
    
    let test3 = BreathExercise(
        name: "Test 3",
        description: "Test 1 description",
    )
    
    let test4 = BreathExercise(
        name: "Test 4",
        description: "Test 2 description",
    )
    
    var items = [BreathExercise]()
    
    init() {
        self.items = [test1, test2, test3, test4]
    }
    
    // var items = [BreathExercise]()
    
    // will require init with loading funcionality
}

struct BreathExercise: Exercise, Codable, Hashable, Identifiable {
    
    // Name and description
    var id = UUID()
    var name = ""
    var description = ""
    
    // Breath Pattern
    var inhale: TimeInterval = 4
    var exhale: TimeInterval = 6
    var holdFull: TimeInterval = 0
    var holdEmpty: TimeInterval = 4
    var breathDuration: TimeInterval {
        exhale + inhale + holdFull + holdEmpty
    }
    
    // Exercise Duration
    var prepTime: TimeInterval = 10
    var cycles: Int = 5
    var totalDuration: TimeInterval {
        breathDuration * TimeInterval(cycles)
    }
    
    // Dates: created and used
    var dateCreated = Date.now
    // date created (watch out for edit so the date isn't replaced by date edited
    var dateUsed = Date.now
}
