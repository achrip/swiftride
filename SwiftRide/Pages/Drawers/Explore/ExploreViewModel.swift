import SwiftUI

final class ExploreViewModel: ObservableObject {

    @Published var stops: [Stop]
    @Published var searchText: String

    var filteredStops: [Stop] { self.stops.filter { $0.name.localizedCaseInsensitiveContains(self.searchText) } }
    
    init() {
        do {
            self.stops = try DataLoader().loadData(for: .stop, as: [Stop].self)
        } catch {
            fatalError("Failed to fetch stops")
        }

        self.searchText = ""
    }
}
