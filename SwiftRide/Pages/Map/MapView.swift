import CoreLocation
import MapKit
import SwiftUI

struct MapView: View, Sendable {
    var body: some View {
        Map {
            UserAnnotation()
        }
        .mapControlVisibility(.visible)
        .onAppear { CLLocationManager().requestWhenInUseAuthorization() }
    }
}

#Preview {
    MapView()
}
