//
//  TimeTableLayoutState.swift
//  SwiftUI-Uurrooster
//
//  Created by docent on 08/02/2024.
//

import Foundation

@Observable
class TimeTableLayoutState {
    let hours = 24
    let cellHeight = 60.0
    let rowHeaderWidth = 50.0
    let columnHeaderHeight = 50.0
    let screenPadding = 10.0
    let timeIndicatorHeight = 2.0
    
    var cellWidth = 140.0
    var offset = CGPoint.zero
    
    init() {
        
    }
    
    func setCellWidth(screenSize: CGSize) {
        cellWidth = (screenSize.width - rowHeaderWidth - screenPadding * 2) / 2
    }
    
    func getRowsHeaderYOffset() -> Double {
        return offset.y + cellHeight / 2
    }
    
    func getEventHeight(event: EventForCell) -> Double {
        return DateUtils.getEventDuration(event: event.event) / 60 / 60 * cellHeight
    }
    
    func getEventWidth(event: EventForCell) -> Double {
        return cellWidth / Double(event.simultaniousEventsAmount)
    }
    
    func getEventYOffset(event: EventForCell) -> Double {
        // -12 want offset y=0 is in het midden
        return (DateUtils.getEventStartTimeInHours(event: event.event) - 12) * (cellHeight) + (getEventHeight(event: event) / 2)
    }
    
    func getEventXOffset(event: EventForCell) -> Double {
        return getEventWidth(event: event) * Double(event.position)
    }
    
    func getTimeIndicatorYOffset() -> Double {
        return getHourYOffset(hours: DateUtils.getHours(date: Date()), height: timeIndicatorHeight)
    }
    
    func getHourYOffset(hours: Double, height: Double) -> Double {
        return hours * (cellHeight) + (height / 2)
    }
}
