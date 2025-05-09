import SwiftUI

struct RouteSelectionView: View {

    @State var points = ["origin", "destination"]

    var body: some View {
        TitleCard(title: .constant("Directions"))

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
