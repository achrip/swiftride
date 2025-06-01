import SwiftUI

struct ExploreView: View, Sendable {

    @Binding var selectedStop: Stop?

    @StateObject var viewModel = ExploreViewModel()
    @State private var sheetDetent: PresentationDetent = .medium

    @FocusState var focus

    var showDetailView: Binding<Bool> {
        Binding(
            get: { selectedStop != nil },
            set: { newValue in
                if !newValue { selectedStop = nil }
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
        .sheet(isPresented: showDetailView, onDismiss: { selectedStop = nil }) {
            DetailView(stop: selectedStop)
                .presentationBackgroundInteraction(.enabled)
                .presentationDetents(
                    [.fraction(0.3), .medium, .fraction(0.9)], selection: $sheetDetent)
        }
    }
}

extension ExploreView {

    @ViewBuilder
    func ContentSelection() -> some View {
        if !viewModel.searchText.isEmpty {
            List(viewModel.filteredStops, id: \.id) { stop in
                Button {
                    self.selectedStop = stop
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
    ExploreView(selectedStop: .constant(dummyStop))
}
