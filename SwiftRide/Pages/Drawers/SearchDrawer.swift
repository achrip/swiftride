import Drawer
import SwiftUI

struct SearchDrawer: View, Sendable {
    //    @Binding var setDrawerHeight: DrawerType
    @Binding var showFavoritesView: Bool

    @State private var restingHeight: [CGFloat] = drawerDefault
    @State private var currentDrawerHeight: CGFloat = drawerDefault[1]

    @State private var searchText: String = ""

    /// Haptics
    let impactGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    let dislodgeGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        Drawer {
            ZStack {
                RoundedRectangle(cornerRadius: CGFloat(19.0), style: .continuous)
                    .foregroundColor(Color(.systemBackground))
                    .shadow(radius: 25)

                VStack {
                    Spacer()
                        .frame(height: 8.0)

                    RoundedRectangle(cornerRadius: 3.0)
                        .foregroundColor(Color(.systemGray5))
                        .frame(width: 36.0, height: 5.0)

                    SearchBar(searchText: $searchText)

                    Spacer()
                }
                .padding(.horizontal, 15)
            }
        }
        .impact(.medium)
        .spring(0)
        .rest(at: self.$restingHeight)
        .onRest { restingHeight in
            self.currentDrawerHeight = restingHeight
        }
        .onChange(of: self.showFavoritesView) { _, showView in
            if showView == false {
                self.restingHeight = [-10]
                DispatchQueue.main.async {
                    self.dislodgeGenerator.impactOccurred()
                }
            } else if showView == true {
                self.restingHeight = drawerDefault
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.impactGenerator.impactOccurred()
                }
            }
        }
        .ignoresSafeArea()
    }
}

extension SearchDrawer {}

#Preview {
    SearchDrawer(showFavoritesView: .constant(true))
}
