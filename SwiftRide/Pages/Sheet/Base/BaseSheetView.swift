import SwiftUI

struct BaseSheetView: View {
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
                Text("Nearest Bus Stops...?")
                Text("Still cooking... 🍳")
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

