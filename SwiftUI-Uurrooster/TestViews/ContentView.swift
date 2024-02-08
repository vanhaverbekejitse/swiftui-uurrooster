//
//  ContentView.swift
//  Uurrooster test
//
//  Created by docent on 18/12/2023.
//

import SwiftUI


/*struct ContentView: View {

    let dates: [Date] = [
        dateFrom(9, 5, 2023),
        dateFrom(10, 5, 2023),
        dateFrom(11, 5, 2023),
        dateFrom(12, 5, 2023),
        dateFrom(13, 5, 2023),
        dateFrom(14, 5, 2023),
        dateFrom(15, 5, 2023),
        dateFrom(16, 5, 2023),
        dateFrom(17, 5, 2023),
        dateFrom(18, 5, 2023),
        dateFrom(19, 5, 2023),
        dateFrom(20, 5, 2023),
        // Add more dates as needed
    ]

    let events: [[Event]] = [
        [
            Event(startDate: dateFrom(9,5,2023,7,0), endDate: dateFrom(9,5,2023,8,0), title: "Event 1"),
            Event(startDate: dateFrom(9,5,2023,9,0), endDate: dateFrom(9,5,2023,10,0), title: "Event 2"),
            Event(startDate: dateFrom(9,5,2023,11,0), endDate: dateFrom(9,5,2023,12,00), title: "Event 3"),
            Event(startDate: dateFrom(9,5,2023,13,0), endDate: dateFrom(9,5,2023,14,45), title: "Event 4"),
            Event(startDate: dateFrom(9,5,2023,15,0), endDate: dateFrom(9,5,2023,15,45), title: "Event 5")
        ],
        // Add events for other dates as needed
        [Event(startDate: dateFrom(10,5,2023,7,0), endDate: dateFrom(11,5,2023,8,0), title: "Event 1"),], // Empty array for the second date
        [Event(startDate: dateFrom(11,5,2023,9,0), endDate: dateFrom(11,5,2023,10,0), title: "Event 2"),
         Event(startDate: dateFrom(11,5,2023,9,0), endDate: dateFrom(11,5,2023,12,00), title: "Event 3"),],
        [],
        [Event(startDate: dateFrom(13,5,2023,13,0), endDate: dateFrom(13,5,2023,14,45), title: "Event 4"),],
        [Event(startDate: dateFrom(14,5,2023,15,0), endDate: dateFrom(14,5,2023,15,45), title: "Event 5"),]// Empty array for the third date
    ]
    
    let days = ["01/01/2023", "02/01/2023", "03/01/2023", "04/01/2023", "05/01/2023", "06/01/2023", "07/01/2023", "08/01/2023", "09/01/2023", "10/01/2023", "11/01/2023", "12/01/2023", ]

    let hourHeight = 50.0
    
    @State private var scrollViewState = ScrollViewState()
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(days, id:\.self) { day in
                    Text(day)
                }
            }
            
        }
        ScrollViewReader { scrollViewProxy in
            ScrollView(.horizontal) {
                ScrollView {
                    HStack(spacing: 0) {
                        
                        ForEach(dates.indices) { index in
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(dates[index].formatted(.dateTime.day().month()))
                                        .bold()
                                    Text(dates[index].formatted(.dateTime.year()))
                                }
                                .font(.title)
                                Text(dates[index].formatted(.dateTime.weekday(.wide)))
                                
                                
                                ZStack(alignment: .topLeading) {
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        ForEach(0..<24) { hour in
                                            HStack {
                                                Text("\(hour)")
                                                    .font(.caption)
                                                    .frame(width: 20, alignment: .trailing)
                                                Color.gray
                                                    .frame(height: 1)
                                            }
                                            .frame(height: hourHeight)
                                        }
                                    }
                                    HStack {
                                        ForEach(events.indices.contains(index) ? events[index] : []) { event in
                                            
                                            eventCell(event)
                                        }
                                        
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            .onChange(of: scrollViewState.selectedDateIndex) { oldValue, newValue in
                print("\(newValue)")
                
            }.onAppear {
                scrollViewState.selectedDateIndex = 0
            }.onDisappear {
                scrollViewState.selectedDateIndex = -1
            }.background(GeometryReader { geo in
                Color.clear.onAppear {
                    let offset = geo.frame(in: .global).minY
                    let index = Int(offset / 50)
                    scrollViewState.selectedDateIndex = index
                }
            })
        }
    }

    func eventCell(_ event: Event) -> some View {
        let duration = event.endDate.timeIntervalSince(event.startDate)
        let height = duration / 60 / 60 * hourHeight

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: event.startDate)
        let offset = Double(hour-7) * (hourHeight)

        return VStack(alignment: .leading) {
            Text(event.startDate.formatted(.dateTime.hour().minute()))
            Text(event.title).bold()
        }
        .font(.caption)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(4)
        .frame(height: height, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.teal)
                .opacity(0.5)
        )
        .padding(.trailing, 30)
        .offset(x: 30, y: offset + 24)
    }
}

func dateFrom(_ day: Int, _ month: Int, _ year: Int, _ hour: Int = 0, _ minute: Int = 0) -> Date {
    let calendar = Calendar.current
    let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
    return calendar.date(from: dateComponents) ?? .now
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

*/
