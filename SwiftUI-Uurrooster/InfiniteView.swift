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
    NavigationStack {
      List {
          ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(.black)
            .foregroundColor(.red)
            .onAppear {
              loadMoreContentUp()
            }
          
        ForEach(dates, id: \.self) { date in
            Text(date.formatted(Date.FormatStyle().weekday(.wide)) + " " + formatDate(date: date))
        }
          
          
          ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(.black)
            .foregroundColor(.red)
            .onAppear {
              loadMoreContentDown()
            }
      }
      .navigationTitle("Infinite List")
    }
  }
    
    func loadMoreContentUp() {
      /*if !isLoading {
        isLoading = true
        // This simulates an asynchronus call
        DispatchQueue.main.asyncAfter(deadline: .now() /*+ 1.0*/) {
          let moreNumbers = numbers.first! - 20...numbers.first! - 1
            numbers.insert(contentsOf: moreNumbers, at: 0)
          isLoading = false
        }
      }*/
    }

  func loadMoreContentDown() {
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

