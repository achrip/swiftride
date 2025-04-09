import SwiftUI
import SwiftData
import MapKit

enum SheetContentType {
    case defaultView
    case busStopDetailView
    case routeDetailView
}

struct MapView: View {
    @State var defaultPosition =  MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -6.302793115915458, longitude: 106.65204508592274),
        latitudinalMeters: CLLocationDistance(1000),
        longitudinalMeters: CLLocationDistance(1000)
    ))
    
    @State var searchText: String = ""
    @State var isSheetShown: Bool = true
    @State var showDefaultSheet: Bool = true

    @State var showStopDetailSheet: Bool = false
    @State var showRouteDetailSheet: Bool = false
  
    @State var presentationDetent: PresentationDetent = .fraction(0.1)
    @State var selectedSheet: SheetContentType = .defaultView
    
    @State var busStops: [BusStop] = loadBusStops()
    @State var selectedBusStop: BusStop = BusStop()
    @State var selectedBusNumber: Int = 0
    
    var body: some View {
        ZStack {
            Map(position: $defaultPosition) {
                UserAnnotation()
                ForEach(busStops) { stop in
                    Annotation(stop.name, coordinate: stop.coordinate) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundStyle(.teal)
                            .onTapGesture {
                                selectedBusStop = stop
                                showDefaultSheet = false
                                withAnimation(.easeInOut(duration: 0.7)){
                                    selectedSheet = .busStopDetailView
                                    showStopDetailSheet = true
                                    presentationDetent = .medium
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
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $isSheetShown, onDismiss: resetSheet) {
                switch selectedSheet {
                    case .defaultView:
                    DefaultSheetView(
                        busStops: $busStops,
                        searchText: $searchText,
                        selectionDetent: $presentationDetent,
                        selectedSheet: $selectedSheet,
                        showDefaultSheet: $showDefaultSheet,
                        showStopDetailSheet: $showStopDetailSheet,
                        showRouteDetailSheet: $showRouteDetailSheet,
                        selectedBusStop: $selectedBusStop,
                        selectedBusNumber: $selectedBusNumber
                    )
                    .presentationDetents([.fraction(0.1), .medium ], selection: $presentationDetent)
                    .presentationDragIndicator(.visible)
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
                    
                case .busStopDetailView:
                    BusStopDetailView(currentBusStop: $selectedBusStop, showRouteDetailSheet: $showRouteDetailSheet,
                        selectedBusNumber: $selectedBusNumber,
                        selectedSheet: $selectedSheet)
                    .presentationDetents([.medium, .fraction(0.99)])
                    .presentationDragIndicator(.visible)
                    .presentationBackgroundInteraction(.enabled)
                    
                case .routeDetailView:
                    BusRoute(busNumber: selectedBusNumber)
                        .presentationDetents([.fraction(0.99)])
                        .presentationDragIndicator(.visible)
                        .presentationBackgroundInteraction(.enabled)
                }
            }
        }
    }
    
    private func resetSheet() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isSheetShown = true
            showDefaultSheet = true
            showStopDetailSheet = false
            showRouteDetailSheet = false
            presentationDetent = .fraction(0.1)
            selectedSheet = .defaultView
        }
    }
}

#Preview {
    MapView()
}
