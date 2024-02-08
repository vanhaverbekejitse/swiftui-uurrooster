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
    let api = MockupEventAPI()
    var events: [Event]
    
    init() {
        events = api.getEvents()
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
    
    func getEventsOnDay(date: Date) -> [Event] {
        return api.getEventsOnDay(date: date)
    }
}
