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
            ScrollView([.vertical, .horizontal], showsIndicators: false) {
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
                    .onAppear {
                        cellProxy.scrollTo("7_2", anchor: .topLeading)
                    }
                }
                .background( GeometryReader { geo in
                    Color.clear
                        .preference(key: ViewOffsetKey.self, value: geo.frame(in: .named("scroll")).origin)
                })
                .onPreferenceChange(ViewOffsetKey.self) { value in
                    if !eventState.isLoading {
                        if value.x >= layoutState.getLeftXLoadingOffset() {
                            Task.init {
                                await eventState.loadEarlierDates()
                                //cellProxy.scrollTo("7_1", anchor: .topLeading)
                                layoutState.offset = value
                            }
                        }
                        else if value.x <= layoutState.getRightXLoadingOffset(loadedDaysAmount: eventState.dates.count) {
                            Task.init {
                                await eventState.loadLaterDates()
                                //cellProxy.scrollTo("7_1", anchor: .topLeading)
                                layoutState.offset = value
                            }
                        }
                    }
                    /*if eventState.resetXPosition == true {
                        cellProxy.scrollTo("7_1", anchor: .topLeading)
                        eventState.resetXPosition = false
                    }*/
                    layoutState.offset = value  // de headers meescrollen
                }
                .onAppear {
                    cellProxy.scrollTo("7_1", anchor: .topLeading)  // verwijderen later
                }
                .scrollTargetLayout()
            }.scrollDisabled(eventState.isLoading)
                .scrollTargetBehavior(.viewAligned)
        }
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
