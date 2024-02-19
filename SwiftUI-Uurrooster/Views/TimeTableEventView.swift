//
//  TimeTableEventView.swift
//  SwiftUI-Uurrooster
//
//  Created by docent on 09/02/2024.
//

import SwiftUI

struct TimeTableEventView: View {
    @Binding var layoutState: TimeTableLayoutState
    var event: EventLayout
    
    var body: some View {
        let eventHeight = layoutState.getEventHeight(event: event)
        let eventWidth = layoutState.getEventWidth(event: event)
        
        let eventYOffset = layoutState.getEventYOffset(event: event)
        let eventXOffset = layoutState.getEventXOffset(event: event)
        
        return VStack(alignment: .leading) {
            Text(event.event.title).bold().foregroundStyle(Color.white)
            Text(DateUtils.formatEventCellTime(event: event.event)).foregroundStyle(Color.white)
        }
        .font(.caption)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(4)
        .frame(width: eventWidth, height: eventHeight, alignment: .top)
        .background(
            Rectangle()
                .fill(Color.red)
                .padding([.bottom, .trailing], layoutState.eventMargin)
        )
        .offset(x: eventXOffset, y: eventYOffset)
    }
}
