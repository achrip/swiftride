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
    @State var showBusStopDetail: Bool = false
    @State var presentationDetent: PresentationDetent = .fraction(0.15)
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
                                withAnimation(.easeInOut(duration: 0.7)){
                                    selectedSheet = .busStopDetailView
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
            .sheet(isPresented: $isSheetShown, onDismiss: resetSheet) {
                switch selectedSheet {
                    case .defaultView:
                    DefaultSheetView(busStops: $busStops, searchText: $searchText,
                                     selectionDetent: $presentationDetent,
                                     selectedSheet: $selectedSheet,
                                     selectedBusStop: $selectedBusStop)
                    .presentationDetents([.fraction(0.1), .medium, .large], selection: $presentationDetent)
                    .presentationDragIndicator(.visible)
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
                    
                case .busStopDetailView:
                    BusStopDetailView(currentBusStop: $selectedBusStop)
                        .presentationDetents([.medium], selection: $presentationDetent)
                        .presentationDragIndicator(.visible)
                        .presentationBackgroundInteraction(.enabled)
                        .onDisappear(perform: resetSheet)
                }
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
}

#Preview {
    MapView()
}
