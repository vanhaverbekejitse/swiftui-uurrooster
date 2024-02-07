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
    let loadingDelay = 0.0
    let loadedEarlierDaysAmount = 1
    let loadedLaterDaysAmount = 2
    
    let events: [[Event]] = [
        [
            Event(startDate: dateFrom(9,5,2023,7,0), endDate: dateFrom(9,5,2023,8,0), title: "Event 1"),
            Event(startDate: dateFrom(9,5,2023,9,0), endDate: dateFrom(9,5,2023,10,0), title: "Event 2"),
            Event(startDate: dateFrom(9,5,2023,11,0), endDate: dateFrom(9,5,2023,12,00), title: "Event 3"),
            Event(startDate: dateFrom(9,5,2023,13,0), endDate: dateFrom(9,5,2023,14,45), title: "Event 4"),
            Event(startDate: dateFrom(9,5,2023,15,0), endDate: dateFrom(9,5,2023,15,45), title: "Event 5")
        ],
        // Add events for other dates as needed
        [Event(startDate: dateFrom(10,5,2023,7,0), endDate: dateFrom(10,5,2023,8,0), title: "Event 1"),], // Empty array for the second date
        [Event(startDate: dateFrom(11,5,2023,9,0), endDate: dateFrom(11,5,2023,10,0), title: "Event 2"),
         Event(startDate: dateFrom(11,5,2023,9,0), endDate: dateFrom(11,5,2023,12,00), title: "Event 3"),],
        [],
        [Event(startDate: dateFrom(13,5,2023,13,0), endDate: dateFrom(13,5,2023,14,45), title: "Event 4"),],
        [Event(startDate: dateFrom(14,5,2023,15,0), endDate: dateFrom(14,5,2023,15,45), title: "Event 5"),]// Empty array for the third date
    ]
    
    init() {
        dates.append(Date())
        for _ in 0..<loadedEarlierDaysAmount {
            addLaterDate()
        }
        for _ in 0..<loadedLaterDaysAmount {
            addLaterDate()
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
