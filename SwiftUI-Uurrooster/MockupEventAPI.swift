//
//  MockupEventAPI.swift
//  SwiftUI-Uurrooster
//
//  Created by docent on 08/02/2024.
//

import Foundation

class MockupEventAPI {
    let events: [Event] = [
        Event(date: "2024-02-07", startTime: "07:00:00", endTime: "08:00:00", title: "Event 1"),
        Event(date: "2024-02-07", startTime: "09:00:00", endTime: "10:00:00", title: "Event 2"),
        Event(date: "2024-02-07", startTime: "11:00:00", endTime: "12:00:00", title: "Event 3"),
        Event(date: "2024-02-07", startTime: "13:00:00", endTime: "14:45:00", title: "Event 4"),
        Event(date: "2024-02-08", startTime: "07:30:00", endTime: "08:00:00", title: "Event 1"),
        Event(date: "2024-02-09", startTime: "09:00:00", endTime: "10:00:00", title: "Event 2"),
        Event(date: "2024-02-09", startTime: "09:00:00", endTime: "12:00:00", title: "Event 3"),
        Event(date: "2024-02-11", startTime: "13:00:00", endTime: "14:45:00", title: "Event 4"),
        Event(date: "2024-02-13", startTime: "15:00:00", endTime: "15:45:00", title: "Event 5"),
    ]
    
    func getEvents() -> [Event] {
        return events
    }
    
    func getEventsOnDay(date: Date) -> [Event] {
        return events.filter { event in
            return event.date == DateUtils.dateToEventDateString(date: date)
        }
    }
}
