//
//  MapView.swift
//  SwiftRide
//
//  Created by Ashraf Alif Adillah on 19/03/25.
//

import SwiftUI
import SwiftData
import MapKit

struct MapView: View {
    @State private var position =  MapCameraPosition.region(MKCoordinateRegion (
        center: CLLocationCoordinate2D(latitude: -6.302793115915458, longitude: 106.65204508592274),
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    ))
    
    @State private var userPosition = MapCameraPosition.region(MKCoordinateRegion (
        center: CLLocationCoordinate2D(),
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    ))
    
    var body: some View {
        Map(position: $position) {
            // Add annotations here
            Marker("Green Office Park 9", coordinate: CLLocationCoordinate2D(latitude: -6.302793115915458, longitude: 106.65204508592274)).tint(.brown)
        }
    }
}

#Preview {
    MapView()
}
