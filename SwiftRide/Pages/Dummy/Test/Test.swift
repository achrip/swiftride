import SwiftData
import SwiftUI

struct TestView: View {
    @Query var routes: [Route]

    var body: some View {
        ForEach(routes) { route in
            
            Text("\(route.name)")
        }
    }
}

struct RouteTestView: View {
    @Query var routes: [Route]
    
    var body: some View {
        ForEach(routes) { route in
            Text("\(route.persistentModelID)")
        }
    }
}

// MARK: - Directions View

struct DirectionStep: Identifiable {
    let id = UUID()
    let instruction: String
    let distance: String
    let systemImage: String
}

struct DirectionsView: View {
    var steps: [DirectionStep]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text("Route to Central Park")
                        .font(.headline)
                    Text("12 min • 3.5 km")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)
            
            Divider()
            
            // Steps List
            List(steps) { step in
                HStack(alignment: .top, spacing: 16) {
                    Image(systemName: step.systemImage)
                        .font(.title2)
                        .frame(width: 30)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.instruction)
                            .font(.body)
                        if !step.distance.isEmpty {
                            Text(step.distance)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            .listStyle(.plain)
            
            // Optional bottom buttons
            HStack {
                Button("End") {
                    // End action
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Route Planner

enum TravelMethod: String, CaseIterable {
    case car = "Drive"
    case walk = "Walk"
    case bike = "Bike"
    case transit = "Transit"

    var iconName: String {
        switch self {
        case .car: return "car.fill"
        case .walk: return "figure.walk"
        case .bike: return "bicycle"
        case .transit: return "tram.fill"
        }
    }
}

struct RoutePlannerView: View {
    @State private var origin: String = ""
    @State private var destination: String = ""
    @State private var selectedMethod: TravelMethod = .car

    var body: some View {
        VStack(spacing: 24) {
            // Origin
            VStack(alignment: .leading, spacing: 8) {
                Text("From")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("Enter starting point", text: $origin)
                    .textFieldStyle(.roundedBorder)
            }

            // Destination
            VStack(alignment: .leading, spacing: 8) {
                Text("To")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("Enter destination", text: $destination)
                    .textFieldStyle(.roundedBorder)
            }

            // Travel Method Picker
            HStack(spacing: 16) {
                ForEach(TravelMethod.allCases, id: \.self) { method in
                    Button(action: {
                        selectedMethod = method
                    }) {
                        VStack {
                            Image(systemName: method.iconName)
                                .font(.title2)
                            Text(method.rawValue)
                                .font(.caption)
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(selectedMethod == method ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
            }

            Spacer()

            // Show Directions Button
            Button(action: {
                print("Get directions from \(origin) to \(destination) via \(selectedMethod.rawValue)")
            }) {
                Text("Show Directions")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .navigationTitle("Plan Your Route")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Movable Destinations

struct MovableRoutePlannerView: View {
    @State private var stops: [Stop] = [
        Stop(name: "My Location", latitude: 0, longitude: 0),
        Stop(name: "Central Park", latitude: 0, longitude: 0)
    ]
    
    @State private var selectedMethod: TravelMethod = .car
    @State private var isEditing = false

    var body: some View {
        NavigationStack {
            List {
                // Stops list
                ForEach(stops) { stop in
                    Text(stop.name)
                }
                .onMove(perform: moveStop)
                
                // Travel method selector
                Section {
                    HStack(spacing: 16) {
                        ForEach(TravelMethod.allCases, id: \.self) { method in
                            Button(action: {
                                selectedMethod = method
                            }) {
                                VStack {
                                    Image(systemName: method.iconName)
                                        .font(.title2)
                                    Text(method.rawValue)
                                        .font(.caption)
                                }
                                .padding(8)
                                .frame(maxWidth: .infinity)
                                .background(selectedMethod == method ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Plan Your Route")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }

            // Show Directions button
            VStack {
                Button(action: {
                    print("Get directions for \(stops.map(\.name)) via \(selectedMethod.rawValue)")
                }) {
                    Text("Show Directions")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding()
            }
        }
    }
    
    // Move stop logic
    private func moveStop(from source: IndexSet, to destination: Int) {
        stops.move(fromOffsets: source, toOffset: destination)
    }
}



#Preview {
    let sampleSteps = [
        DirectionStep(instruction: "Head north on Main St", distance: "200m", systemImage: "arrow.up"),
        DirectionStep(instruction: "Turn right onto 5th Ave", distance: "400m", systemImage: "arrow.turn.right.up"),
        DirectionStep(instruction: "Your destination is on the left", distance: "", systemImage: "mappin.and.ellipse")
    ]
    Group {
        NavigationStack() {
            DirectionsView(steps: sampleSteps)
        }
        
        NavigationStack() {
            RoutePlannerView()
        }
    }
}

#Preview {
    MovableRoutePlannerView()
}
