import SwiftUI
import SwiftData
import MapKit

enum SheetContentType {
    case defaultView
    case busStopDetailView
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
    @State var showDetailSheet: Bool = false
//    @State var showBusStopDetail: Bool = false
    @State var presentationDetent: PresentationDetent = .fraction(0.1)
    @State var selectedSheet: SheetContentType = .defaultView
    
    @State var busStops: [BusStop] = loadBusStops()
    @State var selectedBusStop: BusStop = BusStop()
    
    var body: some View {
        NavigationStack {
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
                                    showDetailSheet = true
                                    presentationDetent = .medium
                                }
//
//                                if isSheetShown {
//                                    restoreSheet = isSheetShown
//                                    isSheetShown = false
//                                }
//                                
//                                showBusStopDetail = true
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
//            .navigationDestination(isPresented: $showBusStopDetail)
//            {
//                BusStopDetailView(currentBusStop: $selectedBusStop)
//                    .onDisappear() {
//                        showBusStopDetail = false
//                        
//                        if restoreSheet {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                isSheetShown = true
//                                restoreSheet = false
//                            }
//                        }
//                    }
//            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showDefaultSheet) {
                DefaultSheetView(busStops: $busStops, searchText: $searchText,
                                 selectionDetent: $presentationDetent,
                                 showDefaultSheet: $showDefaultSheet,
                                 showDetailSheet: $showDetailSheet,
                                 selectedBusStop: $selectedBusStop)
                .presentationDetents([.fraction(0.1), .medium, .large], selection: $presentationDetent)
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
                    
            }
            .sheet(isPresented: $showDetailSheet, onDismiss: resetSheet) {
                BusStopDetailView(currentBusStop: $selectedBusStop)
                    .presentationDetents([.fraction(0.1), .medium], selection: $presentationDetent)
                    .presentationDragIndicator(.visible)
                    .presentationBackgroundInteraction(.enabled)
            }
        }
    }
    
    private func resetSheet() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            presentationDetent = .fraction(0.1)
            showDefaultSheet = true
        }
    }
}

#Preview {
    MapView()
}
