import CoreLocation
import MapKit
import SwiftUI

struct MapView: View {

    @ObservedObject private var viewModel = MapViewModel()

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
                    StopAnnotation(selectedStopID: $viewModel.selectedStopID, stopID: stop.id)
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
            ExploreView(selectedStopID: $viewModel.selectedStopID)
                .interactiveDismissDisabled()
                .presentationBackgroundInteraction(.enabled)
                .presentationDetents(
                    [.fraction(0.15), .fraction(0.4), .fraction(0.6), .fraction(0.9)],
                    selection: $viewModel.sheetDetent)
        }
        .onChange(of: viewModel.selectedStopID) { _, _ in
            viewModel.recenterMap()
        }
    }
}

#Preview {
    MapView()
}
