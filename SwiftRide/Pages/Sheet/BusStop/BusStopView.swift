import SwiftUI

struct BusStopDetailView: View {
    @Binding var currentBusStop: BusStop
    @Binding var selectedSheet: SheetContentType
    
    var body: some View {
        VStack {
            TitleCard(title: $currentBusStop.name)
            Text("Available Buses")
                .font(.title.bold())
        }
        .padding(.top, 20)
        ScrollView {
            BusCard(
                currentBusStop: $currentBusStop,
                selectedSheet: $selectedSheet
            )
        }
    }
}

struct BusCard: View {
    @Binding var currentBusStop: BusStop
    @Binding var selectedSheet: SheetContentType
    
    @State var timerTick: Date = Date()
    
    private let buses: [Bus]
    
    init(currentBusStop: Binding<BusStop>, selectedSheet: Binding<SheetContentType>) {
        self._currentBusStop = currentBusStop
        self._selectedSheet = selectedSheet
        let rawBuses = loadBuses()
        let schedules = loadBusSchedules()
        self.buses = rawBuses.map { $0.assignSchedule(schedules: schedules) }
    }
    
    // Precomputed upcoming bus and ETA pairs
    private var upcomingBuses: [(bus: Bus, etaMinutes: Int)] {
        buses.compactMap { bus in
            guard let nextSchedule = nextSchedule(for: bus, now: timerTick),
                  let eta = bus.getClosestArrivalTime(from: nextSchedule.timeOfArrival) else {
                return nil
            }
            
            if eta <= 0 {
                return nil
            }
            return (bus, Int(eta / 60))
        }
        .sorted { $0.etaMinutes < $1.etaMinutes }
    }
    
    // Helper to get the next schedule for the current stop
    private func nextSchedule(for bus: Bus, now: Date) -> BusSchedule? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX") // Safe default
        let calendar = Calendar.current
        
        let matchingSchedules = bus.schedule
            .filter { $0.busStopName == currentBusStop.name }
            .compactMap { schedule -> (BusSchedule, Date)? in
                guard let timeOnly = formatter.date(from: schedule.timeOfArrival) else {
                    return nil
                }
                
                // Merge "today" with the time from the schedule
                var components = calendar.dateComponents([.year, .month, .day], from: now)
                let timeComponents = calendar.dateComponents([.hour, .minute], from: timeOnly)
                components.hour = timeComponents.hour
                components.minute = timeComponents.minute
                
                guard let fullDate = calendar.date(from: components) else { return nil }
                
                return fullDate >= now ? (schedule, fullDate) : nil
            }
            .sorted { $0.1 < $1.1 }
        
        if let next = matchingSchedules.first?.0 { return next } else {
            return nil
        }
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(upcomingBuses, id: \.bus.id) { pair in
                BusRow(bus: pair.bus, etaMinutes: pair.etaMinutes)
            }
        }
        .padding()
        .onReceive(Timer.publish(every: 5, on: .main, in: .common).autoconnect()) { now in
            timerTick = now
        }
    }
}

struct BusRow: View {
    let bus: Bus
    let etaMinutes: Int
//    let onTap: (Int) -> Void
    var body: some View {
        HStack {
            Image(systemName: "bus")
                .foregroundStyle(bus.color)
                .font(.system(size: 40))

            VStack(alignment: .leading, spacing: 4) {
                Text(bus.name)
                    .font(.headline)

                Text("Will be arriving \(etaMinutes == 0 ? "soon" : "in \(etaMinutes) \(etaMinutes == 1 ? "minute" : "minutes" )")")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
//        .onTapGesture {
//            onTap(bus.number)
//        }
    }
}

struct TitleCard: View {
    @Binding var title: String
    
    var body: some View {
        Text(title)
            .font(.title.bold())
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 15)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
