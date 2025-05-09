import SwiftUI

struct RouteDetailView: View {

    @State var items = ["a", "b", "c"]

    var body: some View {
        TitleCard(title: .constant("Destination"))
            List {
                ForEach(items, id: \.self) { i in
                    HStack {
                        Image(systemName: "person.circle")
                            .font(.largeTitle)
                            .imageScale(.large)

                        VStack(alignment: .leading) {
                            Text("Instruction")
                                .font(.title3)

                            Text("Caption")
                                .foregroundStyle(Color.secondary)
                        }
                    }
                }
                .padding()
                .listSectionSeparator(.hidden, edges: .top)
            }
            .listStyle(.plain)
        }
    }

#Preview {
    RouteDetailView()
}
