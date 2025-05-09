import Foundation
import SwiftUI

struct RouteSelectionView: View {

    @State var points = ["origin", "destination"]

    var body: some View {
        NavigationStack {
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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TitleCard(title: .constant("Destinations"))
                }
            }
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
