import SwiftUI

enum StopStatus {
    case passed, current, upcoming
}

struct BusRoute: View {
    private let buses: [Bus] = loadBuses()
    private let busSchedule: [BusSchedule] = loadBusSchedules()
    let name: String
    let busNumber: Int
    
    private var selectedBus: Bus? {
        buses.first { $0.name == name }
    }

    // Filtered to only include the current session
    private var currentSessionSchedule: [(session: Int, stops: [BusSchedule])] {
        let calendar = Calendar.current
        let now = Date()

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let filtered = busSchedule.filter { $0.busNumber == busNumber }

        let grouped = Dictionary(grouping: filtered, by: { $0.session })
        

        // Find the session where the current time fits in the time range
        for (session, stops) in grouped {
            // Parse all arrival times as today's Date
            let arrivalDates: [Date] = stops.compactMap { stop in
                guard let timeOnly = formatter.date(from: stop.timeOfArrival) else { return nil }
                var components = calendar.dateComponents([.year, .month, .day], from: now)
                let timeComponents = calendar.dateComponents([.hour, .minute], from: timeOnly)
                components.hour = timeComponents.hour
                components.minute = timeComponents.minute
                return calendar.date(from: components)
            }.sorted()

            guard let first = arrivalDates.first, let last = arrivalDates.last else { continue }

            // Check if current time falls within this session's range
            if now >= first && now <= last {
                let sortedStops = stops.sorted { $0.timeOfArrival < $1.timeOfArrival }
                return [(session: session, stops: sortedStops)]
            }
        }

        // Fallback: return nothing
        return []
    }

    private func stopStatus(for timeString: String) -> StopStatus {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        let now = formatter.string(from: Date())

        guard let currentTime = formatter.date(from: now),
              let stopTime = formatter.date(from: timeString.replacingOccurrences(of: ":", with: ".")) else {
            return .upcoming
        }

        if stopTime < currentTime {
            return .passed
        } else if Calendar.current.isDate(stopTime, equalTo: currentTime, toGranularity: .minute) {
            return .current
        } else {
            return .upcoming
        }
    }

    private func description(for status: StopStatus) -> String {
        switch status {
        case .passed: return "The bus has already passed this stop."
        case .current: return "The bus is currently at this stop."
        case .upcoming: return "The bus will pass this stop soon."
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    if currentSessionSchedule.isEmpty {
                        Text("There is no running session currently.")
                            .foregroundStyle(.gray)
                            .padding()
                        
                    } else {
                        ForEach(currentSessionSchedule, id: \.session) { group in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(name)
                                        .font(.title.bold())
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 10)
                                        .padding(.bottom, 10)
                                }

                                ForEach(Array(group.stops.enumerated()), id: \.offset) { index, stop in
                                    let status = stopStatus(for: stop.timeOfArrival)

                                    HStack(alignment: .top) {
                                        VStack {
                                            Circle()
                                                .fill(status == .passed ? Color.gray :
                                                      status == .current ? Color.orange : Color.yellow)
                                                .frame(width: 12, height: 12)

                                            if index < group.stops.count - 1 {
                                                Rectangle()
                                                    .fill(Color.gray.opacity(0.5))
                                                    .frame(width: 2, height: 30)
                                            }
                                        }
                                        .padding(.horizontal, 10)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(stop.busStopName)
                                                .font(status == .current ? .body.bold() : .body)
                                                .foregroundColor(status == .passed ? .gray : .primary)
                                            Text(description(for: status))
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Text(stop.timeOfArrival)
                                            .font(.body)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(status == .passed ? Color.gray : Color.black)
                                            .cornerRadius(5)
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
        }
    }
}

#Preview {
    BusRoute(name: "Intermoda - Sektor 1.3", busNumber: 2)
}
