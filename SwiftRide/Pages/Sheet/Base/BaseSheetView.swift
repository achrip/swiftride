import SwiftData
import SwiftUI

final class SheetService: ObservableObject {
    static let shared = SheetService()

    @Published var searchText: String
    @Published var detent: PresentationDetent
    @Published var showDetailSheet: Bool

    private init() {
        self.searchText = ""
        self.detent = .fraction(0.1)
        self.showDetailSheet = false
    }
}

struct BaseSheetView: View {
    @EnvironmentObject var mapService: MapService
    @EnvironmentObject var sheetService: SheetService

    @Query var stops: [Stop]

    var filteredStops: [Stop] {
        stops.filter { $0.name.localizedCaseInsensitiveContains(sheetService.searchText) }
    }

    var body: some View {
        VStack(spacing: 5) {
            SearchBar(searchText: $sheetService.searchText)
                .padding()
                .padding(.top, 8)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if sheetService.searchText.isEmpty {
                        Section {
                            Text("Favorites")
                                .font(.headline.bold())
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(
                                    rows: [GridItem(.fixed(100))],
                                    spacing: 10
                                ) {
                                    ForEach(0..<5, id: \.self) { _ in
                                        Rectangle()
                                            .frame(width: 100, height: 100)
                                            .foregroundColor(.blue)
                                            .cornerRadius(10)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        Spacer()

                        Section {
                            Text("Nearby Stops")
                                .font(.headline.bold())
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(
                                    rows: [GridItem(.fixed(100))],
                                    spacing: 10
                                ) {
                                    ForEach(0..<5, id: \.self) { _ in
                                        Rectangle()
                                            .frame(width: 100, height: 100)
                                            .foregroundColor(.blue)
                                            .cornerRadius(10)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    } else {
                        ForEach(filteredStops.indices, id: \.self) { index in
                            let stop = filteredStops[index]
                            VStack(alignment: .leading, spacing: 0) {
                                SheetItemCard(title: stop.name)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        mapService.selectedStop = stop
                                    }

                                if index < filteredStops.count - 1 {
                                    Divider()
                                        .padding(.leading, 50)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
        }
        .sheet(isPresented: .constant(mapService.selectedStop != nil), onDismiss: { mapService.selectedStop = nil }) {
            StopView()
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.6), .fraction(0.9)])
                .presentationBackgroundInteraction(.enabled)
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
