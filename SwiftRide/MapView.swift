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
    @State private var defaultPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -6.302793115915458, longitude: 106.65204508592274),
        latitudinalMeters: CLLocationDistance(1000),
        longitudinalMeters: CLLocationDistance(1000)
    ))
    
    @State private var searchText: String = ""
    @State var isSheetShown: Bool = true
    private let busStops: [BusStop] = loadBusStops()
    let columns = Array(repeating: GridItem(.flexible(), spacing: 3), count: 3)
    
    var body: some View {
        Map(position: $defaultPosition) {
            ForEach(busStops) { stop in
                Annotation(stop.name, coordinate: stop.coordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundStyle(.teal)
                        .onTapGesture {
                           print("Tapped")
                        }
                }
                UserAnnotation()
            }
        }
        .onAppear() {
            CLLocationManager().requestWhenInUseAuthorization()
        }
        .mapControls({
            MapUserLocationButton()
        })
        .sheet(isPresented: $isSheetShown) {
            NavigationStack {
                ScrollView{
                        ForEach(busStops) { stop in
                            if stop.name.localizedCaseInsensitiveContains(searchText) || searchText.isEmpty {
                                HStack{
                                    Circle()
                                        .frame(width: 30, height: 30)
                                        .padding(.horizontal, 10)
                                    VStack(alignment: .leading){
                                        Text(stop.name)
                                            .padding(.horizontal, 10)
                                    }
                                    Spacer()
                                }
                        }
                    }
                        .padding()
                }
                .searchable(text: $searchText,
                            placement: .navigationBarDrawer(displayMode: .always))
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
