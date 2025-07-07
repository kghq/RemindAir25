//
//  BreathPattern.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 06/07/2025.
//

import Foundation

@Observable class BreathPattern: Codable {
    var inhale: TimeInterval = 4
    var exhale: TimeInterval = 6
    var holdFull: TimeInterval? = nil
    var holdEmpty: TimeInterval? = nil
    
    var duration: TimeInterval {
        exhale + inhale + (holdFull ?? 0) + (holdEmpty ?? 0)
    }
    
    enum CodingKeys: String, CodingKey {
        case _exhale = "exhale"
        case _inhale = "inhale"
        case _holdFull = "holdFull"
        case _holdEmpty = "holdEmpty"
    }
    
    init(inhale: TimeInterval, exhale: TimeInterval, holdFull: TimeInterval? = nil, holdEmpty: TimeInterval? = nil) {
        self.inhale = inhale
        self.exhale = exhale
        self.holdFull = holdFull
        self.holdEmpty = holdEmpty
    }
}
