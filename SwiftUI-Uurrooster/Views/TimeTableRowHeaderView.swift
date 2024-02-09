//
//  TimeTableRowHeaderView.swift
//  SwiftUI-Uurrooster
//
//  Created by docent on 09/02/2024.
//

import SwiftUI

struct TimeTableRowHeaderView: View {
    @Binding var layoutState: TimeTableLayoutState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(1..<layoutState.hours, id: \.self) { row in
                Text(DateUtils.intToTimetableHour(hour: row))
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .frame(width: layoutState.rowHeaderWidth, height: layoutState.cellHeight)
            }
        }
    }
}
