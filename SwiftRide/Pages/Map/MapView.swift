import CoreLocation
import MapKit
import SwiftUI

struct MapView: View, Sendable {
    @State var stops: [Stop] = []
    var body: some View {
        Map {
            UserAnnotation()

            ForEach(stops, id: \.id) { stop in
                Annotation(
                    stop.name,
                    coordinate: CLLocationCoordinate2D(
                        latitude: stop.latitude, longitude: stop.longitude)
                ) {
                    StopAnnotation()
                }
            }
        }
        .mapControls({
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        })
        .onAppear { CLLocationManager().requestWhenInUseAuthorization() }
    }
}

#Preview {
    MapView()
}
