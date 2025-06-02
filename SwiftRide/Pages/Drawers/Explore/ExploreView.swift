import SwiftUI

struct ExploreView: View, Sendable {

    @Binding var selectedStopID: UUID?

    @StateObject var viewModel = ExploreViewModel()

    @FocusState var focus

    var showDetailView: Binding<Bool> {
        Binding(
            get: { selectedStopID != nil },
            set: { newValue in
                if !newValue { selectedStopID = nil }
            }
        )
    }

    var body: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchText, focus: $focus)

            ContentSelection()

            Spacer()
        }
        .padding()
        .sheet(isPresented: showDetailView, onDismiss: { selectedStopID = nil }) {
            DetailView(stop: viewModel.stops.first(where: { $0.id == selectedStopID }))
                .presentationBackgroundInteraction(.enabled)
                .presentationDetents(
                    [.fraction(0.3), .medium, .fraction(0.9)], selection: $viewModel.sheetDetent)
        }
    }
}

extension ExploreView {

    @ViewBuilder
    func ContentSelection() -> some View {
        if !viewModel.searchText.isEmpty {
            List(viewModel.filteredStops, id: \.id) { stop in
                Button {
                    self.selectedStopID = stop.id
                    focus = false
                } label: {
                    HStack {
                        Image(systemName: "bus.fill")
                            .font(.headline)
                            .imageScale(.large)
                            .clipShape(Circle())

                        Text("\(stop.name)")
                            .font(.body)
                    }
                }
            }
            .listStyle(.plain)
        } else {
            // TODO: Show favorites and nearby stops
        }
    }

}

#Preview {
    let dummyStop = Stop(name: "Title", latitude: 0, longitude: 0)
    ExploreView(selectedStopID: .constant(dummyStop.id))
}
