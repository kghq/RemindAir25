//
//  FormatAsWords.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 08/07/2025.
//

import Foundation

extension BinaryFloatingPoint {
    func formatAsWords() -> String {
        let interval = TimeInterval(self)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        
        return formatter.string(from: interval) ?? ""
    }
}

extension BinaryInteger {
    func formatAsWords() -> String {
        let seconds = Int(self)
        return TimeInterval(seconds).formatAsWords()
    }
}
