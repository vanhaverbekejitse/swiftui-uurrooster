//
//  DateUtils.swift
//  SwiftUI-Uurrooster
//
//  Created by docent on 08/02/2024.
//

import Foundation

class DateUtils {
    class func intToTimetableHour(hour: Int) -> String {
        return String(format: "%02d:00", hour)
    }
    
    class func formatTimeTableDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        return "\(date.formatted(Date.FormatStyle().weekday(.short))) \(dateFormatter.string(from: date))"
    }
    
    class func dateToEventDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    class func eventTimeStringToDate(str: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.date(from: str)!
    }
    
    class func getEventDuration(event: Event) -> Double {
        return eventTimeStringToDate(str: event.endTime)
            .timeIntervalSince(eventTimeStringToDate(str: event.startTime))
    }
    
    class func getEventStartTimeInHours(event: Event) -> Double {
        let date = eventTimeStringToDate(str: event.startTime)
        var hoursTime = Double(Calendar.current.component(.hour, from: date))
        hoursTime += Double(Calendar.current.component(.minute, from: date)) / 60
        hoursTime += Double(Calendar.current.component(.minute, from: date)) / 60 / 60
        //print(String(hoursTime) + " " + event.startTime)
        return hoursTime
    }
    
    class func getEventCellTime(event: Event) -> String {
        return eventTimeStringToDate(str: event.startTime).formatted(.dateTime.hour().minute())
    }
}
