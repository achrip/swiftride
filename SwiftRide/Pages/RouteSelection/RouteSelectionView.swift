import Foundation
import SwiftUI

struct RouteSelectionView: View {

    @State var points = ["origin", "destination"]

    var body: some View {
        TitleCard(title: .constant("Route Selection"))
            .background(Color(.systemBackground))

        List {
            ForEach(points, id: \.self) { p in
                HStack {
                    Image(systemName: "person.circle.fill")
                    Text("\(p)")
                }
            }
            .onMove(perform: self.move)
        }
        .environment(\.editMode, .constant(.active))
        .scrollContentBackground(.hidden)
        .sheet(isPresented: .constant(false)) {
            RouteDetailView()
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.6), .fraction(0.9)])
        }
    }
}

extension RouteSelectionView {
    func move(source: IndexSet, destination: Int) {
        self.points.move(fromOffsets: source, toOffset: destination)
    }
}

#Preview {
    RouteSelectionView()
}
