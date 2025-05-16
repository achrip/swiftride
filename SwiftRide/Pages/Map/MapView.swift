import MapKit
import SwiftData
import SwiftUI

final class MapService: ObservableObject {
    static let shared = MapService()

    @Published var selectedStop: Stop?
    @Published var mapCenter: MapCameraPosition
    @Published var region: MKCoordinateRegion
    @Published var boundaries: MapCameraBounds

    private init() {
        let defaultRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: -6.302793115915458, longitude: 106.65204508592274),
            latitudinalMeters: CLLocationDistance(1000),
            longitudinalMeters: CLLocationDistance(1000)
        )
        self.region = defaultRegion
        self.mapCenter = MapCameraPosition.region(defaultRegion)

        self.boundaries = MapCameraBounds(
            centerCoordinateBounds: defaultRegion, minimumDistance: 1, maximumDistance: 50 * 1000)
    }
}

struct MapView: View {
    @EnvironmentObject var mapService: MapService
    @Query var stops: [Stop]

    var body: some View {
        ZStack {
            Map(
                initialPosition: mapService.mapCenter, bounds: mapService.boundaries,
                interactionModes: .all
            ) {
                UserAnnotation()

                ForEach(stops, id: \.persistentModelID) { stop in
                    Annotation(
                        stop.name,
                        coordinate: CLLocationCoordinate2D(
                            latitude: stop.latitude, longitude: stop.longitude)
                    ) {
                        StopAnnotation(stop: stop)
                    }
                }
            }
            .onAppear {
                CLLocationManager().requestWhenInUseAuthorization()
            }
            .mapControls {
                MapUserLocationButton()
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: .constant(true)) {
                BaseSheetView()
                    .presentationBackgroundInteraction(.enabled)
                    .presentationDetents([.fraction(0.1), .medium, .fraction(0.9)])
                    .presentationDragIndicator(.visible)
                    .interactiveDismissDisabled()
                    .environmentObject(SheetService.shared)
            }
        }
    }
}

#Preview {
    MapView()
        .environmentObject(MapService.shared)
}
