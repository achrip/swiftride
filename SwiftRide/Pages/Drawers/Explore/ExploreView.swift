import Drawer
import SwiftUI

//struct ExploreView: View, Sendable {
//    //    @Binding var setDrawerHeight: DrawerType
//    @Binding var showFavoritesView: Bool
//
//    @State private var restingHeight: [CGFloat] = drawerDefault
//    @State private var currentDrawerHeight: CGFloat = drawerDefault[1]
//
//    @StateObject private var viewModel: ExploreViewModel = ExploreViewModel()
//
//    /// Haptics
//    let impactGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
//    let dislodgeGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
//
//    var body: some View {
//        Drawer {
//            ZStack {
//                RoundedRectangle(cornerRadius: CGFloat(19.0), style: .continuous)
//                    .foregroundColor(Color(.systemBackground))
//                    .shadow(radius: 25)
//
//                VStack {
//                    Spacer()
//                        .frame(height: 8.0)
//
//                    RoundedRectangle(cornerRadius: 3.0)
//                        .foregroundColor(Color(.systemGray5))
//                        .frame(width: 36.0, height: 5.0)
//
//                    SearchBar(searchText: $viewModel.searchText)
//
//                    ContentSelection()
//
//                    Spacer()
//                }
//                .padding(.horizontal, 15)
//            }
//        }
//        .impact(.medium)
//        .spring(0)
//        .rest(at: self.$restingHeight)
//        .onRest { restingHeight in
//            self.currentDrawerHeight = restingHeight
//        }
//        .onChange(of: self.showFavoritesView) { _, showView in
//            if showView == false {
//                self.restingHeight = [-10]
//                DispatchQueue.main.async {
//                    self.dislodgeGenerator.impactOccurred()
//                }
//            } else if showView == true {
//                self.restingHeight = drawerDefault
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    self.impactGenerator.impactOccurred()
//                }
//            }
//        }
//        .ignoresSafeArea()
//    }
//}

struct ExploreView: View, Sendable {

    @StateObject var viewModel = ExploreViewModel()
    @State var showDetailView = false
    @State private var sheetDetent: PresentationDetent = .medium
    
    @FocusState var focus

    var body: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchText, focus: $focus)

            ContentSelection()

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showDetailView, onDismiss: { self.focus.toggle() }) {
            DetailView()
                .presentationBackgroundInteraction(.enabled)
                .presentationDetents([.fraction(0.3), .medium, .fraction(0.9)], selection: $sheetDetent)
        }
    }
}

extension ExploreView {

    @ViewBuilder
    func ContentSelection() -> some View {
        if !viewModel.searchText.isEmpty {
            List(viewModel.filteredStops, id: \.id) { stop in
                Button {
                    DispatchQueue.main.async {
                        showDetailView.toggle()
                        focus.toggle()
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
