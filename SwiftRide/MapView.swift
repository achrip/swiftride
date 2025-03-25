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
    @State private var userPosition = MapCameraPosition.region(MKCoordinateRegion (
        center: CLLocationCoordinate2D(),
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    ))
    
    @State private var position = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -6.302793115915458, longitude: 106.65204508592274),
        latitudinalMeters: CLLocationDistance(1000),
        longitudinalMeters: CLLocationDistance(1000)
    ))
    private let busStops: [BusStop] = loadBusStops()
    @State private var searchText: String = ""
    @State var sliderValue: Double = 3
    @State var isSheetShown: Bool = true
    
    var body: some View {
        Map(position: $position) {
            ForEach(busStops) {stop in
                Marker(stop.name, coordinate: stop.coordinate)
            }
        }
        .sheet(isPresented: $isSheetShown) {
            NavigationStack {
                ScrollView{
                    ForEach(busStops) { stop in
                        if stop.name.lowercased().contains(searchText.lowercased()) || searchText.isEmpty {
                            HStack{
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .padding(.horizontal, 10)
                                Spacer()
                                Text(stop.name)
                                    .padding(.horizontal, 10)
                            }
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText,
                            placement: .navigationBarDrawer(displayMode: .always))
                .environment(\.defaultMinListRowHeight, 0)
            }
            .presentationDetents([.fraction(0.15), .medium])
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.enabled)
            .interactiveDismissDisabled()
        }
    }
}

#Preview {
    MapView()
}
