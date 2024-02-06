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
    
    @State private var offset = CGPoint.zero
    @State private var viewSize = CGSize.zero
    @State private var state = TimeTableState()
    @State private var isDragging = false
    
    private var contentWidth: CGFloat {
        return rowHeaderWidth + cellWidth * CGFloat(state.dates.count)
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    // empty corner
                    Color.clear.frame(width: rowHeaderWidth, height: columnHeaderHeight)
                    ScrollView([.vertical], showsIndicators: false) {
                        rowsHeader
                            .offset(y: offset.y)
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
            .padding()
            .onAppear() {
                self.viewSize = geometry.size
                cellWidth = (self.viewSize.width - self.rowHeaderWidth) / 2
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
                    .border(Color.blue)
            }
        }
    }
    
    var rowsHeader: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<rows) { row in
                Text(state.intToHourString(hour: row))
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .frame(width: rowHeaderWidth, height: cellHeight)
                    .border(Color.blue)
            }
        }
    }
    
    var table: some View {
        ScrollViewReader { cellProxy in
            ScrollView([.vertical, .horizontal], showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(0..<rows) { row in
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(state.dates, id: \.self) { date in
                                // Cell
                                Text("")
                                    .frame(width: cellWidth, height: cellHeight)
                                    .border(Color.blue)
                                    .id("\(row)_\(date)")
                            }
                        }
                    }
                }
                .background( GeometryReader { geo in
                    Color.clear
                        .preference(key: ViewOffsetKey.self, value: geo.frame(in: .named("scroll")).origin)
                })
                .onPreferenceChange(ViewOffsetKey.self) { value in
                    print("\(value.x) \(value.y)")
                    if value.x <= -268 {
                        state.loadLaterDates()
                    }
                    else if value.x >= -1 {
                        state.loadEarlierDates()
                    }
                    offset = value
                    //offset.x = round(value.x / CGFloat(cellWidth)) * CGFloat(cellWidth)
                }
                .onAppear {
                    // HIER VERDERDOEN
                    cellProxy.scrollTo("0_\(cellHeight * 6)")
                }
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
