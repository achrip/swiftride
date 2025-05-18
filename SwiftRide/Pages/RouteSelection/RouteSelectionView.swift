import Foundation
import SwiftData
import SwiftUI

struct RouteSelectionView: View {

    @Environment(\.modelContext) private var context
    @EnvironmentObject var mapService: MapService
    @Query var stops: [Stop]

    @State var stopSelectors: [Stop?] = [nil, nil]

    @State private var showingOriginSelector = false
    @State private var showingDestinationSelector = false

    @State private var pathResults: [(stop: Stop, route: Route?)] = []
    @State private var showingRouteDetail = false
    @State private var selectedPath: [(stop: Stop, route: Route?)] = []

    struct StopSelectorConfig: Identifiable {
        var id = UUID()
        var label: String
        var systemImage: String
        var binding: Binding<Stop?>
        var isPresented: Binding<Bool>
    }

    var body: some View {
        TitleCard(title: .constant("Route Selection"))

        List {
            Section {
                let selectorConfigs = [
                    StopSelectorConfig(label: "Select origin stop...",
                                       systemImage: "location.circle.fill",
                                       binding: $stopSelectors[0],
                                       isPresented: $showingOriginSelector),
                    StopSelectorConfig(label: "Select destination stop...",
                                       systemImage: "mappin.circle.fill",
                                       binding: $stopSelectors[1],
                                       isPresented: $showingDestinationSelector)
                ]

                ForEach(selectorConfigs) { config in
                    HStack {
                        Image(systemName: config.systemImage)
                        Text(config.binding.wrappedValue?.name ?? config.label)
                        Spacer()
                    }
                    .onTapGesture {
                        config.isPresented.wrappedValue = true
                    }
                    .sheet(isPresented: config.isPresented) {
                        StopSelectionView(stops: stops, selectedStop: config.binding)
                    }
                }
                .onMove(perform: self.move)
            }

            Section(header: Text("Possible Routes")) {
                switch (stopSelectors.first, stopSelectors.last, pathResults.isEmpty) {
                case (nil, _, _), (_, nil, _):
                    Text("Select an origin and destination to view possible routes.")
                        .foregroundStyle(.secondary)
                case (_, _, true):
                    Text("There are no possible routes at this time.")
                        .foregroundStyle(.secondary)
                case (_, _, false):
                    ForEach(0..<1, id: \.self) { index in
                        HStack {
                            Text("Option A")
                                .font(.headline)
                            Spacer()
                            Button(action: {
                                selectedPath = pathResults
                                showingRouteDetail = true
                            }) {
                                VStack {
                                    Image(systemName: "chevron.right.2")
                                        .foregroundStyle(Color(.systemBackground))
                                    Text("Go")
                                        .font(.title3)
                                        .foregroundStyle(Color(.systemBackground))
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
        }
        .environment(\.editMode, .constant(.active))
        .sheet(isPresented: $showingRouteDetail) {
            RouteDetailView(path: $selectedPath)
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.6), .fraction(0.9)])
        }
        .onAppear {
            self.stopSelectors[1] = mapService.selectedStop
        }
        .onChange(of: stopSelectors[0]) { _, _ in
            if let origin = stopSelectors[0], let destination = stopSelectors[1] {
                findPath(from: origin, to: destination)
                debugPrintPath(path: pathResults)
            }
        }
        .onChange(of: stopSelectors[1]) { _, _ in
            if let origin = stopSelectors[0], let destination = stopSelectors[1] {
                findPath(from: origin, to: destination)
                debugPrintPath(path: pathResults)
            }
        }
    }
}

extension RouteSelectionView {
    func move(source: IndexSet, destination: Int) {
        let temp = stopSelectors[0]
        stopSelectors[0] = self.stopSelectors[1]
        self.stopSelectors[1] = temp
        //        self.points.move(fromOffsets: source, toOffset: stopSelectors[1])
    }

    func findPath(from origin: Stop, to destination: Stop) {
        RouteGraph.shared.configure(with: context)
        pathResults = RouteGraph.shared.findPath(from: origin, to: destination)
    }

    func stopsScrollView(for path: [(stop: Stop, route: Route?)]) -> some View {
        HStack {
            Text("Stops:")
                .font(.subheadline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(path, id: \.stop.persistentModelID) { item in
                        Text(item.stop.name)
                            .padding(5)
                            .background(.blue.opacity(0.1))
                            .cornerRadius(5)
                    }
                }
            }
        }
    }
}

struct StopSelectionView: View {
    var stops: [Stop]
    @Binding var selectedStop: Stop?
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List(filteredStops, id: \.persistentModelID) { stop in
                Button(action: {
                    selectedStop = stop
                    dismiss()
                }) {
                    Text(stop.name)
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Label("Back", systemImage: "chevron.left")
                    }
                }
            }
            .navigationTitle("Select Stop")
        }
    }

    var filteredStops: [Stop] {
        if searchText.isEmpty {
            return stops
        } else {
            return stops.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
