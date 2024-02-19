//
//  TimeTableLayoutState.swift
//  SwiftUI-Uurrooster
//
//  Created by docent on 08/02/2024.
//

import Foundation

// regelt de layout voor het uurrooster
@Observable
class TimeTableLayoutState {
    let hours = 24
    let cellHeight = 60.0
    let rowHeaderWidth = 30.0
    let columnHeaderHeight = 50.0
    let screenPadding = 10.0
    let timeIndicatorHeight = 2.0
    
    var cellWidth = 140.0
    var offset = CGPoint.zero
    
    func setCellWidth(screenSize: CGSize) {
        cellWidth = (screenSize.width - rowHeaderWidth - screenPadding * 2) / 2
    }
    
    func getLeftXLoadingOffset() -> Double {
        return 0.0 //- cellWidth
    }
    
    func getRightXLoadingOffset(loadedDaysAmount: Int) -> Double {
        return cellWidth * (Double(loadedDaysAmount) - 2 /*- 1*/) * -1
    }
    
    func getRowsHeaderYOffset() -> Double {
        return offset.y + cellHeight / 2
    }
    
    func getEventHeight(event: EventLayout) -> Double {
        return DateUtils.getEventDuration(event: event.event) / 60 / 60 * cellHeight
    }
    
    func getEventWidth(event: EventLayout) -> Double {
        return cellWidth / Double(event.overlappingEventsAmount)
    }
    
    func getEventYOffset(event: EventLayout) -> Double {
        return getHourYOffset(hours: DateUtils.getEventStartTimeInHours(event: event.event), height: getEventHeight(event: event))
    }
    
    func getEventXOffset(event: EventLayout) -> Double {
        return getEventWidth(event: event) * Double(event.position)
    }
    
    func getTimeIndicatorYOffset() -> Double {
        return getHourYOffset(hours: DateUtils.getHours(date: Date()), height: timeIndicatorHeight)
    }
    
    func getHourYOffset(hours: Double, height: Double) -> Double {
        // -12 want offset y=0 is in het midden
        return (hours - 12) * (cellHeight) + (height / 2)
    }
}
