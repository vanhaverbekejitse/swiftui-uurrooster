//
//  MockupEventAPI.swift
//  SwiftUI-Uurrooster
//
//  Created by docent on 08/02/2024.
//

import Foundation

class MockupEventAPI {
    let events: [Event] = [
        Event(date: "2024-02-17", startTime: "07:00:00", endTime: "09:00:00", title: "Event 1"),
        Event(date: "2024-02-17", startTime: "09:00:00", endTime: "10:00:00", title: "Event 2"),
        Event(date: "2024-02-17", startTime: "10:00:00", endTime: "12:00:00", title: "Event 3"),
        Event(date: "2024-02-17", startTime: "11:15:00", endTime: "14:45:00", title: "Event 4"),
        Event(date: "2024-02-17", startTime: "12:15:00", endTime: "14:45:00", title: "Event 5"),
        Event(date: "2024-02-18", startTime: "07:30:00", endTime: "08:00:00", title: "Event 1"),
        Event(date: "2024-02-18", startTime: "08:45:00", endTime: "12:15:00", title: "Practice Enterprise 3"),
        Event(date: "2024-02-18", startTime: "13:30:00", endTime: "17:15:00", title: "Practice Enterprise 3"),
        Event(date: "2024-02-19", startTime: "09:00:00", endTime: "10:00:00", title: "Event 2"),
        Event(date: "2024-02-19", startTime: "09:00:00", endTime: "12:00:00", title: "Event 3"),
        Event(date: "2024-02-21", startTime: "13:00:00", endTime: "14:45:00", title: "Event 4"),
        Event(date: "2024-02-23", startTime: "15:00:00", endTime: "15:45:00", title: "Event 5"),
    ]
    
    func getEvents() -> [Event] {
        return events
    }
    
    func getEventsOnDay(date: Date) -> [Event] {
        return events.filter { event in
            return event.date == DateUtils.dateToEventDateString(date: date)
        }.sorted { event1, event2 in
            if event1.startTime == event2.startTime {
                return event1.endTime < event2.endTime
            }
            return event1.startTime < event2.startTime
        }
    }
}
