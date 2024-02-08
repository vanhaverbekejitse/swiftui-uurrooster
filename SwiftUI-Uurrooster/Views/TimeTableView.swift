//
//  TimeTableView.swift
//  SwiftUI-Uurrooster
//
//  Created by docent on 08/02/2024.
//

import SwiftUI

struct TimeTableView: View {
    
    init() {
        UIScrollView.appearance().bounces = false   // Werkt niet voor macOS
    }
    
    @State private var eventState = TimeTableEventState()
    @State private var layoutState = TimeTableLayoutState()
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    // empty corner
                    Color.clear.frame(width: layoutState.rowHeaderWidth, height: layoutState.columnHeaderHeight)
                    ScrollView([.vertical], showsIndicators: false) {
                        rowsHeader
                            .offset(y: layoutState.getRowsHeaderYOffset())
                    }
                    .disabled(true)
                }
                VStack(alignment: .leading, spacing: 0) {
                    ScrollView([.horizontal], showsIndicators: false) {
                        colsHeader
                            .offset(x: layoutState.offset.x)
                    }
                    .disabled(true)
                    
                    table
                        .coordinateSpace(name: "scroll")
                }
            }
            .padding(layoutState.screenPadding)
            .onAppear() {
                layoutState.setCellWidth(screenSize: geometry.size)
            }
        }
    }
    
    var colsHeader: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(eventState.dates, id: \.self) { date in
                Text(DateUtils.formatTimeTableDate(date: date))
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .frame(width: layoutState.cellWidth, height: layoutState.columnHeaderHeight)
            }
        }
    }
    
    var rowsHeader: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(1..<layoutState.hours) { row in
                Text(DateUtils.intToTimetableHour(hour: row))
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .frame(width: layoutState.rowHeaderWidth, height: layoutState.cellHeight)
            }
        }
    }
    
    var table: some View {
        ScrollViewReader { cellProxy in
            ScrollView([.vertical, .horizontal], showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(eventState.dates.indices, id: \.self) { index in
                        ZStack(alignment: .leading) {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(0..<layoutState.hours) { row in
                                    Text("")
                                        .frame(width: layoutState.cellWidth, height: layoutState.cellHeight)
                                        .border(Color.gray)
                                        .id("\(row)_\(index)")
                                }
                            }
                            ForEach(eventState.getEventsWithSize(date: eventState.dates[index])) { event in
                                eventCell(event)
                            }
                            if (DateUtils.isToday(date: eventState.dates[index])) {
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: layoutState.cellWidth, height: layoutState.timeIndicatorHeight)
                                    .offset(y: layoutState.getTimeIndicatorYOffset())
                            }
                        }
                    }
                }
                .background( GeometryReader { geo in
                    Color.clear
                        .preference(key: ViewOffsetKey.self, value: geo.frame(in: .named("scroll")).origin)
                })
                .onPreferenceChange(ViewOffsetKey.self) { value in
                    if value.x >= 0 {
                        eventState.loadEarlierDates()
                        cellProxy.scrollTo("18_2")
                    }
                    else if value.x <= layoutState.cellWidth * -2 {
                        eventState.loadLaterDates()
                        cellProxy.scrollTo("18_1")
                    }
                    layoutState.offset = value
                }
                .onAppear {
                    cellProxy.scrollTo("18_2")
                }
            }
        }
    }
    
    func eventCell(_ event: EventForCell) -> some View {
        let eventHeight =  layoutState.getEventHeight(event: event)
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
                .padding([.bottom, .trailing], 3)
        )
        .offset(x: eventXOffset, y: eventYOffset)
    }
    
    struct ViewOffsetKey: PreferenceKey {
        typealias Value = CGPoint
        static var defaultValue = CGPoint.zero
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value.x += nextValue().x
            value.y += nextValue().y
        }
    }
}
