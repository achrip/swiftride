import SwiftUI

struct ExploreView: View {

    @StateObject var viewModel = ExploreViewModel()
    @State var showDetailView = false
    @State private var sheetDetent: PresentationDetent = .medium
    @State private var selectedStop: Stop?

    @FocusState var focus

    var body: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchText, focus: $focus)

            ContentSelection()

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showDetailView) {
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
                    DispatchQueue.main.async {
                        showDetailView = true
                    }
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
    ExploreView()
}
