//
//  BusRoute.swift
//  Page4
//
//  Created by Ferdinand Lunardy on 26/03/25.
//

import SwiftUI

struct Stop: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var time: String
    var status: StopStatus
}

enum StopStatus {
    case passed, current, upcoming
}

struct BusRouteP4: View {
    let stops: [Stop] = [
        Stop(name: "Lobby AEON", time: "16.45", status: .passed),
        Stop(name: "AEON Mall 2", time: "16.50", status: .passed),
        Stop(name: "GOP 1", time: "17.05", status: .upcoming),
        Stop(name: "SML Plaza\nAnda di sini!", time: "17.15", status: .current),
        Stop(name: "The Breeze", time: "17.20", status: .upcoming)
    ]
    private let busSchedule: [BusSchedule] = loadBusSchedules()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(stops) { stop in
                HStack(alignment: .top) {
                    VStack {
                        Circle()
                            .fill(stop.status == .passed ? Color.gray :
                                  stop.status == .current ? Color.orange : Color.yellow)
                            .frame(width: 12, height: 12)
                        if stop != stops.last {
                            Rectangle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 2, height: 30)
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(stop.name)
                            .font(stop.status == .current ? .body.bold() : .body)
                            .foregroundColor(stop.status == .passed ? .gray : .primary)
                        Text(description(for: stop.status))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text(stop.time)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(stop.status == .passed ? Color.gray : Color.black)
                        .cornerRadius(5)
                }
                .padding(.vertical, 5)
            }
        }
        .padding(.horizontal)
    }
    
    private func description(for status: StopStatus) -> String {
        switch status {
        case .passed: return "Bus telah melewati stop ini."
        case .current: return " "
        case .upcoming: return "Bus sedang dalam perjalanan."
        }
    }
}

#Preview {
    BusRouteP4()
}

//import SwiftUI
//
//struct BusRouteP4: View {
//    private let busSchedule: [BusSchedule] = loadBusSchedules()
//    var filteredSchedules: [BusSchedule] {
//        busSchedule.filter { $0.busStopName == "The Breeze" }
//                   .sorted { $0.session < $1.session }
//    }
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Bus Schedule")
//                .font(.title2)
//                .bold()
//                .padding(.bottom, 10)
//            
//            ForEach(filteredSchedules) { stop in
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text(stop.busStopName)
//                            .font(.headline)
//                        Text("Bus \(stop.busNumber)")
//                            .font(.headline)
//                        Text("Jam Tiba: \(stop.timeOfArrival)")
//                            .font(.subheadline)
//                        Text("Sesi: \(stop.session)")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                    Spacer()
//                }
//                .padding()
//                .background(Color.orange.opacity(0.1))
//                .cornerRadius(8)
//            }
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    BusRouteP4()
//}

