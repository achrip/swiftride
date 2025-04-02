import SwiftUI

struct DefaultSheetView: View {
    @Binding var busStops: [BusStop]
    @Binding var searchText: String
    @Binding var selectionDetent: PresentationDetent
    
    var body: some View {
        SearchBar(searchText: $searchText, busStops: $busStops)
        ScrollView {
            switch searchText {
            case "":
                Text("Nearest Bus Stops...?")
                Text("Still cooking... 🍳")
                
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
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            .padding(.top, 25)
        }
        .frame( alignment: .top)
    }
}
