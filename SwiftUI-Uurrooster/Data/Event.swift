//
//  Event.swift
//  SwiftUI-Uurrooster
//
//  Created by docent on 08/02/2024.
//

import Foundation

struct Event: Identifiable {
    let id = UUID()
    let date: String        // YYYY-MM-DD
    let startTime: String   // HH:MM:SS
    let endTime: String
    let title: String
}
