import Foundation
import SwiftData
import SwiftUI

struct RouteSelectionView: View {

    @Environment(\.modelContext) private var context

    @State var points = ["origin", "destination"]

    var body: some View {
        TitleCard(title: .constant("Route Selection"))

        Button(action: getRoutes) {
            Text("get routes")
        }

        List {
            Section {
                ForEach(points, id: \.self) { p in
                    HStack {
                        Image(systemName: "person.circle.fill")
                        Text("\(p)")
                    }
                }
                .onMove(perform: self.move)
            }

            Section {
                ForEach(0..<3, id: \.self) { _ in
                    HStack {
                        Image(systemName: "person")

                        Text("Destination")

                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
        }
        .environment(\.editMode, .constant(.active))
        .sheet(isPresented: .constant(false)) {
            RouteDetailView()
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.6), .fraction(0.9)])
        }
    }
}

extension RouteSelectionView {
    func move(source: IndexSet, destination: Int) {
        self.points.move(fromOffsets: source, toOffset: destination)
    }

    func getRoutes() {
        let finder = RouteFinder(context: self.context)
        let fromStopDescriptor = FetchDescriptor<Stop>(
            predicate: #Predicate { $0.name == "Ruko Madrid" }
        )
        let toStopDescriptor = FetchDescriptor<Stop>(
            predicate: #Predicate { $0.name == "Xtreme Park" }
        )

        guard let fromStop = try? context.fetch(fromStopDescriptor).first,
            let toStop = try? context.fetch(toStopDescriptor).first
        else {
            print("Could not find one or both stops")
            return
        }

        // Find possible routes
        let possibleRoutes = finder.findRoutes(from: fromStop, to: toStop)

        // Print the results
        for (index, routeChain) in possibleRoutes.enumerated() {
            print("Option \(index + 1):")
            for route in routeChain {
                print("- Route: \(route.name)")
            }
        }
    }
}

#Preview {
    RouteSelectionView()
}
