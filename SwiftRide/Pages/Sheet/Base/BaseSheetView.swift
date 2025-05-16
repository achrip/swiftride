import SwiftData
import SwiftUI

struct BaseSheetView: View {
    @EnvironmentObject var mapService: MapService
    @State private var selectedStop: Stop
    @State private var searchText: String
    @State private var showSheet: Bool

    @Query var stops: [Stop]

    init() {
        self.searchText = ""
        self.selectedStop = .init(name: "", latitude: 0, longitude: 0)
        self.showSheet = false
    }

    var body: some View {
        VStack {
            SearchBar(searchText: $searchText)
            switch searchText {
            case "":
                VStack {
                }

            default:
                List(
                    stops.filter { $0.name.localizedCaseInsensitiveContains(searchText) }, id: \.id
                ) { stop in
                    SheetItemCard(title: stop.name)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedStop = stop
                            mapService.selectedStop = stop
                            showSheet.toggle()
                        }
                }
                .listStyle(PlainListStyle())
            }

            Spacer()
        }
        .sheet(isPresented: $showSheet) {
            StopView()
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.6), .fraction(0.9)])

        }
    }
}

struct SheetItemCard: View {
    let title: String

    var body: some View {
        HStack {
            Circle()
                .frame(width: 30, height: 30)
                .padding(.horizontal, 10)
            VStack(alignment: .leading) {
                Text(title)
                    .padding(.horizontal, 10)
            }
            Spacer()
        }
    }
}

#Preview {
    BaseSheetView()
}
