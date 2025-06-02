import MapKit
import SwiftUI

final class MapViewModel: ObservableObject {

    @Published var mapCenter: MapCameraPosition
    @Published var stops: [Stop]
    @Published var sheetDetent: PresentationDetent
    @Published var selectedStopID: UUID?

    var mapBounds: MapCameraBounds

    init() {
        let defaultMapCenter = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: -6.302793115915458, longitude: 106.65204508592274),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )

        let bsdRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: -6.302793115915458, longitude: 106.65204508592274),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )

        do {
            self.stops = try DataLoader().loadData(for: .stop, as: [Stop].self)
        } catch {
            fatalError("Data Loading failed")
        }

        self.mapCenter = .region(defaultMapCenter)
        self.mapBounds = .init(centerCoordinateBounds: bsdRegion)
        self.sheetDetent = .fraction(0.4)
    }

    func recenterMap() {
        guard let stop = stops.first(where: { $0.id == selectedStopID }) else { return }

        let offset: Double
        switch sheetDetent {
        case .fraction(0.15): offset = 0.0005
        case .fraction(0.4): offset = 0.001
        case .fraction(0.6): offset = 0.0015
        case .fraction(0.9): offset = 0.002
        default: offset = 0.001
        }

        let newCenterRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: stop.latitude - offset, longitude: stop.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))

        withAnimation { self.mapCenter = .region(newCenterRegion) }
    }
}
