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
  
    @State var presentationDetent: PresentationDetent = .fraction(0.1)
    @State var selectedSheet: SheetContentType = .defaultView
    
    @State var busStops: [BusStop] = loadBusStops()
    @State var selectedBusStop: BusStop = BusStop()
    
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
                                withAnimation(.easeInOut(duration: 0.7)){
                                    selectedSheet = .busStopDetailView
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
            .sheet(isPresented: isSheetActive(for: selectedSheet, matching: .defaultView), onDismiss: resetSheet) {
                BaseSheetView(
                    busStops: $busStops,
                    searchText: $searchText,
                    selectionDetent: $presentationDetent,
                    selectedSheet: $selectedSheet,
                    selectedBusStop: $selectedBusStop,
                )
                .presentationDetents([.fraction(0.1), .medium ], selection: $presentationDetent)
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
            }
            .sheet(isPresented: isSheetActive(for: selectedSheet, matching: .busStopDetailView), onDismiss: resetSheet) {
                BusStopDetailView(currentBusStop: $selectedBusStop,
                                  selectedSheet: $selectedSheet)
                .presentationDetents([.medium, .fraction(0.99)])
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled)
            }
            .sheet(isPresented: isSheetActive(for: selectedSheet, matching: .routeDetailView), onDismiss: resetSheet) {
                BusRoute(busNumber: 3)
                    .presentationDetents([.fraction(0.99)])
                    .presentationDragIndicator(.visible)
                    .presentationBackgroundInteraction(.enabled)
            }
        }
    }
    
    private func resetSheet() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isSheetShown = true
            presentationDetent = .fraction(0.1)
            selectedSheet = .defaultView
        }
    }
    
    private func isSheetActive(for current: SheetContentType, matching expected: SheetContentType) -> Binding<Bool> {
        Binding.constant(current == expected)
    }
}

#Preview {
    MapView()
}
