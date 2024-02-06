//
//  TimeTableState.swift
//  SwiftUI-Uurrooster
//
//  Created by docent on 06/02/2024.
//

import Foundation

class TimeTableState: Observable {
    var dates: [Date] = []
    var isLoading = false
    let loadingDelay = 0.4
    
    init() {
        dates.append(Date())
        for _ in 0..<3 {
            self.addLaterDate()
        }
    }
    
    func loadLaterDates() {
        if !isLoading {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingDelay) {
                for _ in 0..<1 {
                    self.addLaterDate()
                    self.dates.removeFirst()
                }
                self.isLoading = false
            }
        }
    }
    
    func loadEarlierDates() {
        if !isLoading {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingDelay) {
                for _ in 0..<1 {
                    self.addEarlierDate()
                    self.dates.removeLast()
                }
                self.isLoading = false
            }
        }
    }
    
    func addLaterDate() {
        self.dates.append(Calendar.current.date(byAdding: .day, value: 1, to: self.dates.last!)!)
    }
    
    func addEarlierDate() {
        self.dates.insert(Calendar.current.date(byAdding: .day, value: -1, to: self.dates.first!)!, at: 0)
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        return "\(date.formatted(Date.FormatStyle().weekday(.short))) \(dateFormatter.string(from: date))"
    }
    
    func intToHourString(hour: Int) -> String {
        return String(format: "%02d:00", hour)
    }
}
