//
//  CountDownView.swift
//  LightningRemit
//
//  Created by Temiloluwa on 09/07/2024.
//

import SwiftUI

struct CountDownView: View {
    @State private var timeRemaining: TimeInterval
    private let expirySecs: Date
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(expiryDate: Date) {
        self.expirySecs = expiryDate
        self._timeRemaining = State(initialValue: expiryDate.timeIntervalSinceNow)
    }

    var body: some View {
        Text(timeString(from: timeRemaining))
            .onReceive(timer) { _ in
                updateCountdown()
            }
    }

    private func updateCountdown() {
        let newTimeRemaining = expirySecs.timeIntervalSinceNow
        if newTimeRemaining > 0 {
            timeRemaining = newTimeRemaining
        } else {
            timeRemaining = 0
            timer.upstream.connect().cancel() // Stop the timer when countdown reaches zero
        }
    }

    private func timeString(from time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
