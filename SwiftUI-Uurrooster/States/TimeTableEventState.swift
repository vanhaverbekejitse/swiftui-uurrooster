//
//  TimeTableEventState.swift
//  SwiftUI-Uurrooster
//
//  Created by docent on 08/02/2024.
//

import Foundation

// Laadt de datums en events voor het uurrooster
@Observable
class TimeTableEventState {
    var dates: [Date] = []
    var isLoading = false
    let loadingDelay = 0.4
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
                    //self.dates.removeFirst()
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
                    //self.dates.removeLast()
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
    
    func getEventsWithSize(date: Date) -> [EventLayout] {
        let events = api.getEventsOnDay(date: date).map { event in
            return EventLayout(event: event)
        }
        var cellEvents: [EventLayout] = []
        var overlappingEvents: [EventLayout] = []
        for event in events {
            if (overlappingEvents.contains { overlappingEvent in
                return event.startTime < overlappingEvent.endTime
            }) {
                overlappingEvents.forEach { overlappingEvent in
                    overlappingEvent.incrementSimultaniousEvents()
                }
                overlappingEvents.append(event)
                event.position = overlappingEvents.count - 1
                event.simultaniousEventsAmount = overlappingEvents.count
            }
            else {
                cellEvents.append(contentsOf: overlappingEvents)
                overlappingEvents = [event]
            }
        }
        cellEvents.append(contentsOf: overlappingEvents)
        return cellEvents
    }
}

class EventLayout: Identifiable {
    let event: Event
    var startTime: Date
    var endTime: Date
    var position = 0
    var simultaniousEventsAmount = 1
    
    init(event: Event) {
        self.event = event
        self.startTime = DateUtils.eventTimeStringToDate(str: event.startTime)
        self.endTime = DateUtils.eventTimeStringToDate(str: event.endTime)
    }
    
    func incrementSimultaniousEvents() {
        simultaniousEventsAmount += 1
    }
}
