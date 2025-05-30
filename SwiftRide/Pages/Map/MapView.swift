import CoreLocation
import MapKit
import SwiftUI

struct MapView: View {
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
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: .constant(true)) {
            ExploreView()
                .interactiveDismissDisabled()
                .presentationBackgroundInteraction(.enabled)
                .presentationDetents([
                    .fraction(0.15), .fraction(0.3), .fraction(0.6), .fraction(0.9),
                ])
        }
    }
}

#Preview {
    MapView()
}
