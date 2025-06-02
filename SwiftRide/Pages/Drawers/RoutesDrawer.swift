import SwiftUI

struct RoutesDrawer: View, Sendable {

    @Environment(\.dismiss) var dismiss

    @State private var stops: [Stop?] = [nil, nil]
    @State private var showSelectorSheet: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text("Route Selection")
                    .font(.title)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(Color(.secondaryLabel))
                }
            }

            List {
                ForEach(0..<2, id: \.self) { index in
                    StopSelector(index: index)
                        .sheet(isPresented: $showSelectorSheet) {
                            Button {
                                showSelectorSheet = false
                            } label: {
                                Text("Show stops here")
                            }
                        }
                }
                .onMove(perform: move)
            }
            .environment(\.editMode, .constant(.active))
            .padding(.horizontal, 0)
        }
        .padding()
    }
}

extension RoutesDrawer {
    func move(source: IndexSet, destination: Int) {
        self.stops.move(fromOffsets: source, toOffset: destination)
    }

    @ViewBuilder
    func StopSelector(index: Int) -> some View {
        HStack {
            Image(systemName: "location.circle.fill")
                .foregroundStyle(Color(.systemBlue))

            Text(
                stops[index]?.name
                    ?? (index == 0
                        ? "Select origin stop..." : "Select destination stop...")
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .foregroundStyle(
                stops[index] == nil ? Color(.secondaryLabel) : .primary
            )
            .onTapGesture {
                showSelectorSheet = true
            }
        }
    }
}

struct BusRouteView: View, Sendable {

    @Binding var selectedBus: Bus

    var orderedStops: [Schedule] = []

    var body: some View {
        ScrollView {
            ForEach(orderedStops, id: \.id) { stop in
                HStack {
                    Circle()

                    Text(stop.stopName)

                    Spacer()

                    Text("\(stop.time)")
                }
            }
        }
        .navigationTitle("Route for <Route Name>")
        .padding()
        .onAppear {
            fetchRoute(for: self.selectedBus)
        }
    }

    func fetchRoute(for bus: Bus) {
        var schedules: [Schedule] = []
        do {
            schedules = try DataLoader().loadData(for: .schedule, as: [Schedule].self)
        } catch {
            fatalError("Failed to fetch schedules. \(error)")
        }

        let orderedStops = schedules.filter { $0.busNumber == bus.number }
            .sorted { $0.stopOrder < $1.stopOrder }

        print(orderedStops)
    }
}

#Preview {
    RoutesDrawer()
}
