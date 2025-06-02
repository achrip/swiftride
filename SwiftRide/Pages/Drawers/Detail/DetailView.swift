import SwiftUI

struct DetailView: View {

    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: DetailViewModel = DetailViewModel()
    @State var showRoutesView: Bool = false
    @State var showBusRouteView: Bool = false
    @State var sheetDetent: PresentationDetent = .medium
    @State var selectedBus: Bus = Bus(name: "", number: 0)

    let stop: Stop?

    var body: some View {
        VStack {
            HStack {
                if let stop = stop {
                    Text(stop.name)
                        .font(.title)
                }

                Button {

                } label: {
                    Image(systemName: "star.fill")
                        .imageScale(.large)
                        .foregroundStyle(Color(.systemGray3))
                }

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(Color(.secondaryLabel))
                }
            }

            Button {
                showRoutesView.toggle()
            } label: {
                HStack {
                    Image(systemName: "arrow.trianglehead.turn.up.right.diamond.fill")
                        .font(.title2)
                    Text("Get directions")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)

            content()
                .padding(.top, 12)

            Spacer()
        }
        .padding()
        .onChange(of: stop) { _, newStop in
            Task { await viewModel.fetchDetails(for: newStop) }
            viewModel.startAutoRefresh(for: newStop)
        }
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchData()
                } catch {
                    fatalError("Failed to fetch data. \(error)")
                }
                await viewModel.fetchDetails(for: stop)
                viewModel.startAutoRefresh(for: stop)
            }
        }
        .sheet(isPresented: $showRoutesView) {
            RoutesDrawer()
                .presentationBackgroundInteraction(.enabled)
                .presentationDetents(
                    [.fraction(0.3), .medium, .fraction(0.9)], selection: $sheetDetent)
        }
    }
}

extension DetailView {

    @ViewBuilder
    func content() -> some View {
        VStack(alignment: .leading) {
            Text("Available Buse(s)")
                .font(.headline)

            // Maybe this should be a navigation stack idk..
            List(viewModel.upcomingSchedules, id: \.0.id) { tuple in
                Button {
                    print("Navigating to route view...")
                } label: {
                    HStack {
                        Image(systemName: "bus")
                            .imageScale(.large)
                        VStack(alignment: .leading) {
                            Text("Bus \(tuple.0.busNumber)")
                                .font(.title3)

                            Text("Will be arriving in approximately \(tuple.1) minutes.")
                                .font(.caption)
                                .foregroundStyle(Color(.secondaryLabel))
                        }
                    }
                }
            }
            .listStyle(.plain)
            .sheet(isPresented: $showBusRouteView) {
                BusRouteView(selectedBus: $selectedBus)
                    .presentationBackgroundInteraction(.enabled)
                    .presentationDetents(
                        [.fraction(0.3), .medium, .fraction(0.9)], selection: $sheetDetent)
            }
        }

    }
}

#Preview {
//    DetailView(stop: nil)
}
