import SwiftUI

struct DefaultSheetView: View {
    @Binding var busStops: [BusStop]
    @Binding var searchText: String
    @Binding var selectionDetent: PresentationDetent
    @Binding var isSheetShown: Bool
    @Binding var showBusStopDetail: Bool
    @Binding var selectedBusStop: BusStop
    @Binding var restoreSheet: Bool
    
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
                                            
                                            if isSheetShown {
                                                restoreSheet = isSheetShown
                                                isSheetShown = false
                                            }
                                            
                                            showBusStopDetail = true
                                            
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
        .presentationDetents([.fraction(0.1), .medium, .large])
        .presentationDragIndicator(.visible)
        .presentationBackgroundInteraction(.enabled)
        .interactiveDismissDisabled()
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
        ScrollView {
            BusCard(currentBusStop: $currentBusStop)
        }
    }
}

struct BusCard: View {
    @State var buses: [Bus] = loadBuses()
    @Binding var currentBusStop: BusStop
    
    var body: some View {
        VStack {
            ForEach(buses) { bus in
                HStack {
                    Image(systemName: "bus")
                        .foregroundStyle(Color.orange)
                        .font(.system(size: 40))
                    VStack(alignment: .leading) {
                        Text(bus.name)
                            .font(.headline)
                        Text("Bus No. \(bus.number)")
                            .font(.caption)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    print("YES")
                }
            }
        }
    }
}

struct TitleCard: View {
    @Binding var title: String
    
    var body: some View {
        Text(title)
            .font(.title.bold())
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .padding(.vertical, 15)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
