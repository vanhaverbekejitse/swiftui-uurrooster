//
//  InfiniteView.swift
//  SwiftUI-Uurrooster
//
//  Created by docent on 05/02/2024.
//

import SwiftUI

struct InfiniteView: View {
    @State private var dates: [Date] = [Date()]
    @State private var isLoading = false
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(.black)
                        .foregroundColor(.red)
                        .onAppear {
                            loadEarlierDates()
                        }
                    VStack(spacing: 20) {
                        ForEach(0..<24) { rowIndex in
                            Text("\(rowIndex)")
                        }
                    }
                    .frame(width: 150)
                    
                    LazyHStack {
                        ForEach(dates, id: \.self) { date in
                            VStack(spacing: 20) {
                                Text("\(date.formatted(Date.FormatStyle().weekday(.wide))) \(formatDate(date: date))")
                                ScrollView {
                                    LazyVStack(spacing: 10) {
                                        ForEach(0..<20) { rowIndex in
                                            Text("Content")
                                                .padding()
                                                .background(Color.green)
                                                .clipShape(.capsule)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(.black)
                        .foregroundColor(.red)
                        .onAppear {
                            loadLaterDates()
                        }
                }
                .padding()
            }
            .navigationTitle("Infinite List")
        }
    }
    
    func loadEarlierDates() {
        if !isLoading {
            isLoading = true
            // This simulates an asynchronus call
            DispatchQueue.main.asyncAfter(deadline: .now() /*+ 1.0*/) {
                for _ in 0..<20 {
                    dates.insert(Calendar.current.date(byAdding: .day, value: -1, to: dates.first!)!, at: 0)
                }
                isLoading = false
            }
        }
    }
    
    func loadLaterDates() {
        if !isLoading {
            isLoading = true
            // This simulates an asynchronus call
            DispatchQueue.main.asyncAfter(deadline: .now() /*+ 1.0*/) {
                for _ in 0..<20 {
                    dates.append(Calendar.current.date(byAdding: .day, value: 1, to: dates.last!)!)
                }
                isLoading = false
            }
        }
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        return dateFormatter.string(from: date)
    }
}

