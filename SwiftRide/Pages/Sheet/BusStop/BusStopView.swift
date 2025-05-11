import SwiftData
import SwiftUI

struct TitleCard: View {
    @Environment(\.dismiss) private var dismiss

    @State private var isShowingPopOver: Bool = false
    @Binding var title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.title.bold())

            Image(systemName: "info.circle.fill")
                .font(.headline)
                .onTapGesture {
                    self.isShowingPopOver.toggle()
                }
                .popover(isPresented: $isShowingPopOver) {
                    Text("Still cooking... 🍳")
                        .padding()
                        .presentationCompactAdaptation(.none)
                }

            Spacer()
            Spacer()
            Spacer()

            Image(systemName: "xmark.circle.fill")
                .font(.headline)
                .onTapGesture {
                    dismiss()
                }
        }
    }
}

struct RouteCard: View {
    let name: String
    let id: PersistentIdentifier

    var body: some View {
        HStack {
            Image(systemName: "bus.fill")
                .font(.largeTitle)
                .foregroundStyle(Color.color(for: id))

            Text(name)
                .font(.title3)
        }
    }
}

struct StopView: View {

    @Binding var selectedStop: Stop

    @Query var schedules: [Schedule]

    var body: some View {
        VStack(alignment: .leading) {
            TitleCard(title: $selectedStop.name)

            Spacer()
            Spacer()

            Button(action: {}) {
                VStack {
                    Image(systemName: "arrow.trianglehead.turn.up.right.diamond.fill")
                        .font(.title2)
                    Text("Get directions")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .padding()

            Divider()

            Text("Available Buses")
                .font(.headline)

            List(
                // Specific filtering with dictionary to get unique routes.
                Dictionary(grouping: schedules.filter { $0.stop == selectedStop }, by: { $0.route })
                    .compactMap { $0.value.first?.route }
            ) { route in
                RouteCard(name: route.name, id: route.id)
            }
            .listStyle(.plain)

        }
        .padding()
    }
}

#Preview {
    let s = Stop(name: "Grand Central Terminal", latitude: 40.752778, longitude: -73.977222)

    let container = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Stop.self, Schedule.self, configurations: config)
        let context = container.mainContext
        context.insert(Stop(name: "My Location", latitude: 0, longitude: 0))
        context.insert(s)
        context.insert(Schedule(route: Route(name: "123"), stop: s))
        return container
    }()

    NavigationStack {
        StopView(selectedStop: .constant(s))
    }
    .modelContainer(container)
}
