import MapKit
import SwiftData
import SwiftUI

enum SheetContentType {
    case defaultView
    case busStopDetailView
    case routeDetailView
}

struct MapView: View {
    let mapCenter: MapCameraPosition
    let region: MKCoordinateRegion
    let boundaries: MapCameraBounds

    @State var isOverlayShown: Bool = false
    @Query var stops: [Stop]

    init() {
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: -6.302793115915458, longitude: 106.65204508592274),
            latitudinalMeters: CLLocationDistance(1000),
            longitudinalMeters: CLLocationDistance(1000)
        )
        self.mapCenter = MapCameraPosition.region(self.region)

        self.boundaries = MapCameraBounds(
            centerCoordinateBounds: self.region, minimumDistance: 1, maximumDistance: 50 * 1000)
    }

    var body: some View {
        ZStack {
            Map(initialPosition: mapCenter, bounds: boundaries, interactionModes: .all) {
                UserAnnotation()

                ForEach(stops, id: \.persistentModelID) { stop in
                    Annotation(
                        stop.name,
                        coordinate: CLLocationCoordinate2D(
                            latitude: stop.latitude, longitude: stop.longitude)
                    ) {
                        StopAnnotation()
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
            }
        }
    }
}

#Preview {
    MapView()
}
