//
//  Countdown.swift
//  TimerChess
//
//  Created by Giovanni Jr Di Fenza on 17/03/25.
//

import Foundation

final class ViewModel: ObservableObject {
    @Published var isTopRectActive = false
    @Published var isBottomRectActive = false
    @Published var topRectTime: String = "5:00"
    @Published var bottomRectTime: String = "5:00"
    @Published var minutes: Float = 5.0
    @Published var remainingTopTime: TimeInterval? = nil
    @Published var remainingBottomTime: TimeInterval? = nil

    private var topRectEndDate: Date? = nil
    private var bottomRectEndDate: Date? = nil

    private var topRectTimer: Timer? = nil
    private var bottomRectTimer: Timer? = nil

    func startTopRect(minutes: Float) {
        if let remainingTime = remainingTopTime, remainingTime > 0 {
            self.topRectEndDate = Date().addingTimeInterval(remainingTime)
        } else {
            self.topRectEndDate = Calendar.current.date(byAdding: .minute, value: Int(minutes), to: Date())
        }
        self.isTopRectActive = true
        startTopRectTimer()
    }

    func startBottomRect(minutes: Float) {
        if let remainingTime = remainingBottomTime, remainingTime > 0 {
            self.bottomRectEndDate = Date().addingTimeInterval(remainingTime)
        } else {
            self.bottomRectEndDate = Calendar.current.date(byAdding: .minute, value: Int(minutes), to: Date())
        }
        self.isBottomRectActive = true
        startBottomRectTimer()
    }

    func stopTopRect() {
        self.isTopRectActive = false
        topRectTimer?.invalidate()
        topRectTimer = nil
        if let endDate = topRectEndDate {
            self.remainingTopTime = endDate.timeIntervalSince(Date())
        }
        updateTopRectCountdown()
    }

    func stopBottomRect() {
        self.isBottomRectActive = false
        bottomRectTimer?.invalidate()
        bottomRectTimer = nil
        if let endDate = bottomRectEndDate {
            self.remainingBottomTime = endDate.timeIntervalSince(Date())
        }
        updateBottomRectCountdown()
    }

    func startTopRectTimer() {
        topRectTimer?.invalidate()
        topRectTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateTopRectCountdown()
        }
    }

    func startBottomRectTimer() {
        bottomRectTimer?.invalidate()
        bottomRectTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateBottomRectCountdown()
        }
    }

    func updateTopRectCountdown() {
        guard let endDate = topRectEndDate, isTopRectActive else { return }
        let diff = endDate.timeIntervalSince1970 - Date().timeIntervalSince1970
        if diff <= 0 {
            self.isTopRectActive = false
            self.topRectTime = "0:00"
            topRectTimer?.invalidate()
            remainingTopTime = nil
            return
        }
        let minutes = Int(diff) / 60
        let seconds = Int(diff) % 60
        self.topRectTime = String(format: "%02d:%02d", minutes, seconds)
    }

    func updateBottomRectCountdown() {
        guard let endDate = bottomRectEndDate, isBottomRectActive else { return }
        let diff = endDate.timeIntervalSince1970 - Date().timeIntervalSince1970
        if diff <= 0 {
            self.isBottomRectActive = false
            self.bottomRectTime = "0:00"
            bottomRectTimer?.invalidate()
            remainingBottomTime = nil
            return
        }
        let minutes = Int(diff) / 60
        let seconds = Int(diff) % 60
        self.bottomRectTime = String(format: "%02d:%02d", minutes, seconds)
    }

    // Funzione che aggiorna i tempi per entrambi i rettangoli
    func updateTimesForSelectedMinutes() {
        let formattedTime = String(format: "%02d:%02d", Int(minutes), 0)
        self.topRectTime = formattedTime
        self.bottomRectTime = formattedTime
    }

    func reset() {
        stopTopRect()
        stopBottomRect()
        
        // Reset the times based on the value of 'minutes' from the picker
        let formattedTime = String(format: "%02d:%02d", Int(minutes), 0)
        self.topRectTime = formattedTime
        self.bottomRectTime = formattedTime
        
        // Reset remaining times as well to avoid carrying over old values
        self.remainingTopTime = nil
        self.remainingBottomTime = nil
        
        self.isTopRectActive = false
        self.isBottomRectActive = false
    }
}
