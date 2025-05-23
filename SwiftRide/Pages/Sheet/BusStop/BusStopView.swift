import SwiftData
import SwiftUI

struct TitleCard: View {
    @EnvironmentObject var mapService: MapService
    @Environment(\.dismiss) var dismiss

    @Binding var title: String?

    var body: some View {
        HStack {
            Text(title ?? "Unknown")
                .font(.title.bold())

            if SheetService.shared.currentPage == .detail {
                Image(systemName: "star.fill")
                    .imageScale(.large)
                    .foregroundStyle(Color(.secondarySystemFill))
            }

            Spacer()
            Spacer()
            Spacer()

            Image(systemName: "xmark.circle.fill")
                .imageScale(.large)
                .onTapGesture {
                    dismiss()
                    
                    if SheetService.shared.currentPage == .detail {
                       mapService.selectedStop = nil
                    }
                }
        }
        .background(Color(.systemBackground).opacity(0.1))
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
    @EnvironmentObject var mapService: MapService
    @EnvironmentObject var sheetService: SheetService

    @Query var schedules: [Schedule]
    
    @State private var isShowingPopOver: Bool = false

    @State private var isShowingPopOver: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            TitleCard(title: .constant(mapService.selectedStop?.name))

            Spacer()
            Spacer()

            Button(action: {
                isShowingPopOver.toggle()
                sheetService.currentPage = .routeSelect
            }) {
                HStack {
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
                Dictionary(
                    grouping: schedules.filter { $0.stop == mapService.selectedStop },
                    by: { $0.route }
                )
                .compactMap { $0.value.first?.route }
            ) { route in
                RouteCard(name: route.name, id: route.id)
            }
            .listStyle(.plain)

        }
        .padding()
        .sheet(isPresented: $isShowingPopOver, onDismiss: {sheetService.currentPage = .detail}) {
            RouteSelectionView()
                .padding()
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium, .fraction(0.7), .fraction(0.9)])
        }
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
        //StopView(selectedStop: .constant(s))
    }
    .modelContainer(container)
}
