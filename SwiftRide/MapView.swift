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

<<<<<<< HEAD:SwiftRide/MapView.swift
    private let busStops: [BusStop] = loadBusStops()
    let columns = Array(repeating: GridItem(.flexible(), spacing: 3), count: 3)

=======
    @State private var busStops: [BusStop] = loadBusStops()
    @State private var busSchedules: [BusSchedule] = loadBusSchedules()
    @State private var presentationDetent: PresentationDetent = .fraction(0.15)
    
>>>>>>> 4c8ca44 (restructure views and models):SwiftRide/View/MapView.swift
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
            .sheet(isPresented: $isSheetShown) {
                NavigationStack {
                    ScrollView {
                        ForEach(busStops) { stop in
                            if stop.name.localizedCaseInsensitiveContains(searchText) || searchText.isEmpty {
                                HStack {
                                    Circle()
                                        .frame(width: 30, height: 30)
                                        .padding(.horizontal, 10)
                                    VStack(alignment: .leading) {
                                        Text(stop.name)
                                            .padding(.horizontal, 10)
                                            .onTapGesture {
                                                isSheetShown = false
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                    isNavToPage2 = true
                                                }
                                            }
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                    }
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                }
                .presentationDetents([.fraction(0.15), .medium])
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
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
