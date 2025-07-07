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
    var items = [BreathExercise]()
    
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
