import CoreLocation
import MapKit
import SwiftUI

struct MapView: View, Sendable {
    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        Map(
            position: $viewModel.mapCenter,
            bounds: viewModel.mapBounds,
            interactionModes: .all
        ) {
            UserAnnotation()

            ForEach(viewModel.stops, id: \.id) { stop in
                Annotation(
                    stop.name,
                    coordinate: CLLocationCoordinate2D(
                        latitude: stop.latitude, longitude: stop.longitude)
                ) {
                    StopAnnotation(stop: stop)
                }
            }
        }
        .mapControls({
            MapUserLocationButton()
            MapCompass()
        })
        .onAppear { CLLocationManager().requestWhenInUseAuthorization() }
    }
}

#Preview {
    MapView()
}
