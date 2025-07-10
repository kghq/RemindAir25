//
//  TimerModel.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 10/07/2025.
//

import Combine
import Foundation

//@Observable class timerModel {
//    
//}

@Observable class TimerModel {
    private var timerCancellable: Cancellable?
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    
    var counter: TimeInterval
    var counterFormatted: String {
        formatAsTimer(counter)
    }
    
    var isRunning: Bool = false
    
    init(initialDuration: TimeInterval) {
        self.counter = initialDuration
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true
        timer = Timer.publish(every: 1, tolerance: 0.2, on: .main, in: .common).autoconnect()
        timerCancellable = timer?.sink { [weak self] _ in
            self?.tick()
        }
    }

    func pause() {
        isRunning = false
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    func reset(to duration: TimeInterval) {
        pause()
        counter = duration
    }

    private func tick() {
        guard counter > 0 else {
            pause()
            return
        }
        counter -= 1
    }
    
    func load(with timeDuration: TimeInterval) {
        counter = timeDuration
    }
    
    // Styling
    func formatAsTimer(_ interval: TimeInterval) -> String {
        let totalSeconds = Int(interval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
}
