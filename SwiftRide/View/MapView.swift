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
    @State private var defaultPosition =  MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -6.302793115915458, longitude: 106.65204508592274),
        latitudinalMeters: CLLocationDistance(1000),
        longitudinalMeters: CLLocationDistance(1000)
    ))

    @State private var searchText: String = ""
    @State private var isSheetShown: Bool = true
    @State private var isNavToPage2: Bool = false
    @State private var isNavToPage3: Bool = false
    @State private var isNavToPage4: Bool = false

    @State private var busStops: [BusStop] = loadBusStops()
    @State private var presentationDetent: PresentationDetent = .fraction(0.15)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Map(position: $defaultPosition) {
                    UserAnnotation()
                    ForEach(busStops) { stop in
                        Annotation(stop.name, coordinate: stop.coordinate) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundStyle(.teal)
                                .onTapGesture {
                                    isSheetShown = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        isNavToPage2 = true
                                    }
                                }
                        }
                    }
                }
                .onAppear {
                    CLLocationManager().requestWhenInUseAuthorization()
                }
                .mapControls {
                    MapUserLocationButton()
                }
                .navigationDestination(isPresented: $isNavToPage2)
                {
                    Page2(isNavToPage3: $isNavToPage3, isNavToPage4: $isNavToPage4, isSheetShown: $isSheetShown)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $isSheetShown) {
                DefaultSheetView(busStops: $busStops, searchText: $searchText, selectionDetent: $presentationDetent)
            }
            .onChange(of: isNavToPage2) {
                if (isNavToPage2 == false) {
                    isSheetShown = true
                }
            }
            .onChange(of: isNavToPage3) {
                if (isNavToPage3 == false) {
                    isSheetShown = true
                }
            }
            .onChange(of: isNavToPage4) {
                if (isNavToPage4 == false) {
                    isSheetShown = true
                }
            }
        }
    }
}



#Preview {
    MapView()
}
