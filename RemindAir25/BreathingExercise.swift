//
//  BreathingExercise.swift
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
    var items = [Exercise]()
    
    // will require init with loading funcionality
}

@Observable class BreathingExercise: Exercise, Codable, Identifiable {
    var id = UUID()
    var name = ""
    
    var breathPattern: BreathPattern
    var cycles: Int
    var totalDuration: TimeInterval {
        breathPattern.duration * TimeInterval(cycles)
    }
    
    var dateCreated = Date.now
    // date created (watch out for edit so the date isn't replaced by date edited
    //
    
    enum CodingKeys: String, CodingKey {
        case _id = "id"
        case _name = "name"
        case _breathPattern = "breathPattern"
        case _cycles = "cycles"
        case _dateCreated = "dateCreated"
    }
    
    init(id: UUID = UUID(), name: String = "", breathPattern: BreathPattern, cycles: Int, dateCreated: Foundation.Date = Date.now) {
        self.id = id
        self.name = name
        self.breathPattern = breathPattern
        self.cycles = cycles
        self.dateCreated = dateCreated
    }
}
