import SwiftUI

struct RouteDetailView: View {
    @Binding var path: [(stop: Stop, route: Route?)]

    var body: some View {
        VStack {
            TitleCard(title: .constant("Directions"))
            
            List {
                ForEach(Array(path.enumerated()), id: \.element.stop.persistentModelID) { index, item in
                    HStack {
                        Image(systemName: "location.circle.fill")
                            .font(.title2)
                            .imageScale(.large)
                        VStack(alignment: .leading) {
                            Text("\(item.stop.name)")
                                .font(.title2)
                            if index != 0 {
                                Text("Arrive here via the route: \(item.route?.name ?? "N/A")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                    }
                }
            }
            .listStyle(.plain)
        }
        .safeAreaPadding()
        .onAppear {
            debugPrintPath(path: path)
        }
    }


}
func debugPrintPath(path: [(stop: Stop, route: Route?)]) {
        print("Route Path:")
        for (index, item) in path.enumerated() {
            let routeName = item.route?.name ?? "N/A"
            print("\(index + 1). Stop: \(item.stop.name), Route: \(routeName)")
        }
    }
