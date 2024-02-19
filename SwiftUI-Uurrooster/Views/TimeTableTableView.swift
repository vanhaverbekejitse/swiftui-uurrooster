//
//  TimeTableTableView.swift
//  SwiftUI-Uurrooster
//
//  Created by docent on 09/02/2024.
//

import SwiftUI

struct TimeTableTableView: View {
    @Binding var layoutState: TimeTableLayoutState
    @Binding var eventState: TimeTableEventState
    
    var body: some View {
        ScrollViewReader { cellProxy in
            ScrollView(.vertical, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(Array(zip(eventState.dates.indices, eventState.dates)), id: \.0) { column, date in
                        ZStack(alignment: .leading) {
                            VStack(alignment: .leading, spacing: 0) {
                                // Cellen van het rooster
                                ForEach(0..<layoutState.hours, id: \.self) { row in
                                    Text("")
                                        .frame(width: layoutState.cellWidth, height: layoutState.cellHeight)
                                        .border(Color(UIColor.lightGray))
                                        .id("\(row)_\(column)")
                                }
                            }
                            // Events op het rooster
                            ForEach(eventState.getEventsWithSize(date: date)) { event in
                                TimeTableEventView(layoutState: $layoutState, event: event)
                            }
                            // Lijn om huidig tijdstip te tonen
                            if (DateUtils.isToday(date: date)) {
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
                    layoutState.offset = value  // de headers meescrollen
                }
                .onAppear {
                    cellProxy.scrollTo("7_1", anchor: .topLeading)  // verwijderen later
                }
                .scrollTargetLayout()
            }.scrollDisabled(eventState.isLoading)
                .scrollTargetBehavior(.viewAligned)
        }.border(Color(UIColor.lightGray))
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
