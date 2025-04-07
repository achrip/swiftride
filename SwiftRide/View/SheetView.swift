import SwiftUI

struct DefaultSheetView: View {
    @Binding var busStops: [BusStop]
    @Binding var searchText: String
    @Binding var selectionDetent: PresentationDetent
    @Binding var selectedSheet: SheetContentType
    @Binding var selectedBusStop: BusStop
    
    var body: some View {
        SearchBar(searchText: $searchText, busStops: $busStops)
        ScrollView {
            switch searchText {
            case "":
//                Text("Nearest Bus Stops...?")
//                Text("Still cooking... 🍳")
                Text("")
                
            default:
                VStack(spacing: 10) {
                    ForEach(busStops) { stop in
                        if stop.name.localizedCaseInsensitiveContains(searchText) || searchText.isEmpty {
                            HStack {
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .padding(.horizontal, 10)
                                VStack(alignment: .leading) {
                                    Text(stop.name)
                                        .padding(.horizontal, 10)
                                        .onTapGesture {
                                            selectedBusStop = stop
                                            withAnimation(.easeInOut(duration: 0.7)){
                                                selectedSheet = .busStopDetailView
                                                selectionDetent = .medium
                                            }
                                        }
                                }
                                Spacer()
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var busStops: [BusStop]
    
    var body: some View {
        VStack (spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search Bus Stop", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    
                }
            }
            .padding()
            .frame(height: 35)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            .padding(.top, 25)
        }
        .frame( alignment: .top)
    }
}

struct BusStopDetailView: View {
    @Binding var currentBusStop: BusStop
    
    var body: some View {
        VStack {
            TitleCard(title: $currentBusStop.name)
            Text("Available Buses")
                .font(.title.bold())
        }
        .padding(.top, 20)
        ScrollView {
            BusCard(currentBusStop: $currentBusStop)
        }
    }
}

struct BusCard: View {
    @Binding var currentBusStop: BusStop

    private let buses: [Bus]

    init(currentBusStop: Binding<BusStop>) {
        self._currentBusStop = currentBusStop

        let rawBuses = loadBuses()
        let schedules = loadBusSchedules()
        self.buses = rawBuses.map { $0.assignSchedule(schedules: schedules) }
    }

    // Precomputed upcoming bus and ETA pairs
    private var upcomingBuses: [(bus: Bus, etaMinutes: Int)] {
        buses.compactMap { bus in
            guard let nextSchedule = nextSchedule(for: bus),
                  let eta = bus.getClosestArrivalTime(from: nextSchedule.timeOfArrival),
                  eta > 0 else {
                return nil
            }
            return (bus, Int(eta / 60))
        }
    }

    // Helper to get the next schedule for the current stop
    private func nextSchedule(for bus: Bus) -> BusSchedule? {
        bus.schedule
            .filter { $0.busStopName == currentBusStop.name }
            .sorted { a, b in a.timeOfArrival < b.timeOfArrival }
            .first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(upcomingBuses, id: \.bus.id) { pair in
                BusRow(bus: pair.bus, etaMinutes: pair.etaMinutes)
            }
        }
        .padding()
    }
}

struct BusRow: View {
    let bus: Bus
    let etaMinutes: Int

    var body: some View {
        HStack {
            Image(systemName: "bus")
                .foregroundStyle(Color.orange)
                .font(.system(size: 40))

            VStack(alignment: .leading, spacing: 4) {
                Text(bus.name)
                    .font(.headline)

                Text("Will be arriving in \(etaMinutes) minute\(etaMinutes == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            // Handle tap if needed
        }
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
