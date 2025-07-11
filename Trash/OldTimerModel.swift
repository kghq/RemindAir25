//
//  TimerModel.swift
//  RemindAir25
//
//  Created by Krzysztof Garmulewicz on 10/07/2025.
//

import Combine
import Foundation

@Observable class OldTimerModel {
    private var timerCancellable: Cancellable?
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    
    var counter: TimeInterval
    
    var isRunning: Bool = false
    
    // Called when counter reaches 0
    var onFinished: (() -> ())?

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
            onFinished?()
            return
        }
        counter -= 1
    }
    
    func load(with timeDuration: TimeInterval) {
        counter = timeDuration
    }
    
    init(initialDuration: TimeInterval) {
        self.counter = initialDuration
    }
    
}


extension TimeInterval {
    func formatAsTimer() -> String {
        let totalSeconds = Int(self)
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
