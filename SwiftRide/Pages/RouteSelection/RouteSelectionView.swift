import Foundation
import SwiftUI

struct RouteSelectionView: View {

    @State var points = ["origin", "destination"]

    var body: some View {
        TitleCard(title: .constant("Route Selection"))

        List {
            Section {
                ForEach(points, id: \.self) { p in
                    HStack {
                        Image(systemName: "person.circle.fill")
                        Text("\(p)")
                    }
                }
                .onMove(perform: self.move)
            }
            
            Section {
                ForEach(0..<3, id: \.self) { _ in
                    HStack {
                        Image(systemName: "person")
                        
                        Text("Destination")
                        
                        Spacer()
                        Button(action: {  }) {
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
        }
        .environment(\.editMode, .constant(.active))
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
