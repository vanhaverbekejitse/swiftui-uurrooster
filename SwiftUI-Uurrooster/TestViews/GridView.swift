//
//  GridView.swift
//  SwiftUI-Uurrooster
//
//  Created by docent on 06/02/2024.
//

import SwiftUI

struct GridView: View {
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    let rows = 24
    @State var cellWidth = 140.0
    let cellHeight = 50.0
    let rowHeaderWidth = 50.0
    let columnHeaderHeight = 50.0
    let padding = 10.0
    
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
                Text(state.formatDate(date: date))
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .frame(width: cellWidth, height: columnHeaderHeight)
                    .border(Color.gray)
            }
        }
    }
    
    var rowsHeader: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(1..<rows) { row in
                Text(state.intToHourString(hour: row))
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .frame(width: rowHeaderWidth, height: cellHeight)
            }
        }
    }
    
    var table: some View {
        ScrollViewReader { cellProxy in
            ScrollView([.vertical, .horizontal], showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(0..<rows) { row in
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(state.dates.indices, id: \.self) { index in
                                // Cell
                                Text("\(row)_\(index)")
                                    .frame(width: cellWidth, height: cellHeight)
                                    .border(Color.gray)
                                    .id("\(row)_\(index)")
                            }
                        }
                    }
                }
                .background( GeometryReader { geo in
                    Color.clear
                        .preference(key: ViewOffsetKey.self, value: geo.frame(in: .named("scroll")).origin)
                })
                .onPreferenceChange(ViewOffsetKey.self) { value in
                    //print("\(value.x) \(value.y)")
                    //print("x \(value.x), lower \(0), upper \(cellWidth * -12)")
                    if value.x >= 0 {
                        cellProxy.scrollTo("18_2")
                        state.loadEarlierDates()
                    }
                    else if value.x <= cellWidth * -2 {
                        cellProxy.scrollTo("18_1")
                        state.loadLaterDates()
                    }
                    offset = value
                }
                .onAppear {
                    //cellProxy.scrollTo("18_2")
                }
            }
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
