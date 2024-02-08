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
    
    let hours = 24
    @State var cellWidth = 140.0
    let cellHeight = 60.0
    let rowHeaderWidth = 50.0
    let columnHeaderHeight = 50.0
    let padding = 10.0
    
    @State private var canTrigger = false
    
    @State private var offset = CGPoint.zero
    @State private var viewSize = CGSize.zero
    @State private var state = TimeTableState()
    @GestureState private var dragOffset = CGFloat.zero
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    // empty corner
                    Color.clear.frame(width: rowHeaderWidth, height: columnHeaderHeight)
                    ScrollView([.vertical], showsIndicators: false) {
                        rowsHeader
                            .offset(y: offset.y + cellHeight / 2)
                    }
                    .disabled(true)
                }
                VStack(alignment: .leading, spacing: 0) {
                    ScrollView([.horizontal], showsIndicators: false) {
                        colsHeader
                            .offset(x: offset.x)
                    }
                    .disabled(true)
                    
                    table
                        .coordinateSpace(name: "scroll")
                }
            }
            .padding(padding)
            .onAppear() {
                viewSize = geometry.size
                cellWidth = (viewSize.width - rowHeaderWidth - padding * 2) / 2
            }
        }
    }
    
    var colsHeader: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(state.dates, id: \.self) { date in
                Text(DateUtils.formatTimeTableDate(date: date))
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .frame(width: cellWidth, height: columnHeaderHeight)
                    .border(Color.gray)
            }
        }
    }
    
    var rowsHeader: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(1..<hours) { row in
                Text(DateUtils.intToTimetableHour(hour: row))
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .frame(width: rowHeaderWidth, height: cellHeight)
            }
        }
    }
    
    var table: some View {
        ScrollViewReader { cellProxy in
            ScrollView([.vertical, .horizontal], showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(state.dates.indices, id: \.self) { index in
                        ZStack(alignment: .leading) {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(0..<hours) { row in
                                    // Cell
                                    Text("")
                                        .frame(width: cellWidth, height: cellHeight)
                                        .border(Color.gray)
                                        .id("\(row)_\(index)")
                                }
                            }
                            HStack(spacing: 0) {
                                ForEach(state.api.getEventsOnDay(date: state.dates[index])) { event in
                                    eventCell(event)
                                }
                            }
                            .frame(width: cellWidth)
                        }
                    }
                }
                .background( GeometryReader { geo in
                    Color.clear
                        .preference(key: ViewOffsetKey.self, value: geo.frame(in: .named("scroll")).origin)
                })
                .onPreferenceChange(ViewOffsetKey.self) { value in
                    //print("\(value.x) \(value.y)")
                    //print("x \(value.x), lower \(0), upper \(cellWidth * -2)")
                    if value.x >= 0 {
                        state.loadEarlierDates()
                        cellProxy.scrollTo("18_2")
                    }
                    else if value.x <= cellWidth * -2 {
                        state.loadLaterDates()
                        cellProxy.scrollTo("18_1")
                    }
                    offset = value
                }
                .onAppear {
                    cellProxy.scrollTo("18_2")
                }
            }
        }
    }
    
    func eventCell(_ event: Event) -> some View {
        let eventHeight = DateUtils.getEventDuration(event: event) / 60 / 60 * cellHeight
        // -12 want offset y=0 is in het midden
        var eventOffset = (DateUtils.getEventStartTimeInHours(event: event) - 12) * (cellHeight) + (eventHeight / 2)

        return VStack(alignment: .leading) {
            Text(DateUtils.getEventCellTime(event: event))
            Text(event.title).bold()
        }
        .font(.caption)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(4)
        .frame(height: eventHeight, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.teal)
        )
        .offset(y: eventOffset)
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


#Preview {
    TimeTableView()
}
