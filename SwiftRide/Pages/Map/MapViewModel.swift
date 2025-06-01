import MapKit
import SwiftUI

final class MapViewModel: ObservableObject {

    @Published var mapCenter: MapCameraPosition
    @Published var stops: [Stop]
    @Published var sheetDetent: PresentationDetent
    @Published var selectedStop: Stop?

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
}
