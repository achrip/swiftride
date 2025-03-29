//
//  ScheduleButton.swift
//  Page3
//
//  Created by Ferdinand Lunardy on 26/03/25.
//

import SwiftUI
struct BusScheduleP3: Identifiable, Equatable, Hashable {
    var id = UUID()
    var schedule: String
    var status: ScheduleButtonStatusP3
}

enum ScheduleButtonStatusP3 {
    case available, unavailable
}

struct ScheduleButtonP3: View {
    let busSchedulesP3 = [
        BusScheduleP3(schedule: "07:30", status: .unavailable),
        BusScheduleP3(schedule: "08:00", status: .unavailable),
        BusScheduleP3(schedule: "09:00", status: .unavailable),
        BusScheduleP3(schedule: "09:30", status: .unavailable),
        BusScheduleP3(schedule: "15:00", status: .available),
        BusScheduleP3(schedule: "16:30", status: .available),
        BusScheduleP3(schedule: "17:00", status: .available),
        BusScheduleP3(schedule: "17:15", status: .available),
        BusScheduleP3(schedule: "17:45", status: .available)
    ]
    
    @Binding var isNavToPage4: Bool
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                        ForEach(busSchedulesP3, id: \.self) { schedule in
                            Text(schedule.schedule)
                                .frame(width: 80, height: 40)
                                .background(schedule.status == .unavailable ? Color.gray :
                                                Color.black)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 2)
                                .onTapGesture{
                                    isNavToPage4 = true
                                }
                        }
                    }
    }
}

#Preview {
    ScheduleButtonP3(isNavToPage4: .constant(false))
}
