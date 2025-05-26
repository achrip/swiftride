import CoreLocation
import MapKit
import SwiftUI

struct MapView: View, Sendable {
    var body: some View {
        Map {
            UserAnnotation()
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
