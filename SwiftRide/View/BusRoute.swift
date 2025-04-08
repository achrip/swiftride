import SwiftUI

enum StopStatus {
    case passed, current, upcoming 
}

struct BusRoute: View {
    private let busSchedule: [BusSchedule] = loadBusSchedules()
    let busNumber: Int
    // Group the schedule by session
    private var groupedSchedule: [(session: Int, stops: [BusSchedule])] {
        let filtered = busSchedule
            .filter { $0.busNumber == busNumber }

        let grouped = Dictionary(grouping: filtered, by: { $0.session })
        
        return grouped
            .sorted { $0.key < $1.key }
            .map { (session: $0.key, stops: $0.value.sorted { $0.timeOfArrival < $1.timeOfArrival }) }
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
        case .passed: return "Bus telah melewati stop ini."
        case .current: return "Anda di sini"
        case .upcoming: return "Bus sedang dalam perjalanan."
        }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(groupedSchedule, id: \.session) { group in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Session \(group.session)")
                            .font(.headline)
                            .padding(.bottom, 5)

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
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
}

#Preview {
    BusRoute(busNumber: 2)
}
