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

    var body: some View {
        HStack {
            Image(systemName: "bus.fill")
                .font(.largeTitle)
                .foregroundStyle(Color.primary)

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
            Spacer()

            Text("Available Buses")
                .font(.title2)

            List(
                // Specific filtering with dictionary to get unique routes.
                Dictionary(grouping: schedules.filter { $0.stop == selectedStop }, by: { $0.route })
                    .compactMap { $0.value.first?.route }
            ) { route in
                RouteCard(name: route.name)
            }
            .listStyle(.plain)

        }
        .padding()
    }
}
