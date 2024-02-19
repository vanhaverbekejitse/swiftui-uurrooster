//
//  TimeTableView.swift
//  SwiftUI-Uurrooster
//
//  Created by docent on 08/02/2024.
//

import SwiftUI

struct TimeTableView: View {
    
    @State private var eventState = TimeTableEventState()
    @State private var layoutState = TimeTableLayoutState()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Leeg hoekje linksboven
                        Color.clear.frame(width: layoutState.rowHeaderWidth, height: layoutState.columnHeaderHeight)
                        
                        // Uren links van de tabel
                        ScrollView([.vertical], showsIndicators: false) {
                            TimeTableRowHeaderView(layoutState: $layoutState)
                                .offset(y: layoutState.getRowsHeaderYOffset())
                        }
                        .disabled(true)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        // Datums boven de tabel
                        ScrollView([.horizontal], showsIndicators: false) {
                            TimeTableColumnHeaderView(layoutState: $layoutState, eventState: $eventState)
                                .offset(x: layoutState.offset.x)
                        }
                        .disabled(true)
                        
                        // Tabel
                        TimeTableTableView(layoutState: $layoutState, eventState: $eventState).coordinateSpace(name: "scroll")
                    }
                }
                .padding(layoutState.screenPadding)
                .onAppear() {
                    layoutState.setCellWidth(screenSize: geometry.size)
                }
                HStack {
                    Spacer()
                    Image(systemName: "arrowtriangle.backward.fill").resizable().onTapGesture {
                        eventState.loadEarlierDates()
                    }.frame(width: layoutState.arrowWidth, height: layoutState.arrowHeight)
                        .foregroundStyle(Color(UIColor.lightGray))
                    Spacer()
                    Image(systemName: "arrowtriangle.forward.fill").resizable().onTapGesture {
                        eventState.loadLaterDates()
                    }.frame(width: layoutState.arrowWidth, height: layoutState.arrowHeight)
                        .foregroundStyle(Color(UIColor.lightGray))
                    Spacer()
                }
            }
        }
    }
}
