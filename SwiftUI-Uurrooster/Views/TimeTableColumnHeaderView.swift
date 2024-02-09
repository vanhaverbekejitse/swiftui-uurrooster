//
//  TimeTableColumnHeaderView.swift
//  SwiftUI-Uurrooster
//
//  Created by docent on 09/02/2024.
//

import SwiftUI

struct TimeTableColumnHeaderView: View {
    @Binding var layoutState: TimeTableLayoutState
    @Binding var eventState: TimeTableEventState
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(eventState.dates, id: \.self) { date in
                Text(DateUtils.formatTimeTableDate(date: date))
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .frame(width: layoutState.cellWidth, height: layoutState.columnHeaderHeight)
            }
        }
    }
}
