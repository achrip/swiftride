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
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        let bsdRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: -6.302793115915458, longitude: 106.65204508592274),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        self.region = defaultRegion
        self.mapCenter = MapCameraPosition.region(defaultRegion)

        self.boundaries = MapCameraBounds(centerCoordinateBounds: bsdRegion)
    }

    func centerMap(on stop: Stop, meters: CLLocationDistance = 500) {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude),
            latitudinalMeters: meters,
            longitudinalMeters: meters
        )
        withAnimation {
            self.mapCenter = .region(region)
        }
    }
}

struct MapView: View {
    @EnvironmentObject var mapService: MapService
    @Query var stops: [Stop]

    var body: some View {
        ZStack {
            Map(
                position: $mapService.mapCenter, bounds: mapService.boundaries,
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
            .onAppear {
                CLLocationManager().requestWhenInUseAuthorization()
            }
            .onChange(of: mapService.selectedStop) { _, newStop in
                guard let stop = newStop else { return }
                mapService.centerMap(on: stop)
            }
        }
    }
}

#Preview {
    MapView()
        .environmentObject(MapService.shared)
}
