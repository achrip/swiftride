import Drawer
import SwiftUI

struct DetailView: View, Sendable {

    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: DetailViewModel = DetailViewModel()

    let stop: Stop?

    #if DEBUG
        let buses = ["123", "456", "789"]
        @State var cs: Stop = .init(
            name: "Terminal Intermoda", latitude: -6.321395070998093, longitude: 106.64347051762091)
    #endif

    var body: some View {
        VStack {
            HStack {
                Text(stop!.name)
                    .font(.title)

                Button {

                } label: {
                    Image(systemName: "star.fill")
                        .imageScale(.large)
                        .foregroundStyle(Color(.systemGray3))
                }

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(Color(.secondaryLabel))
                }
            }

            Button {
                #if DEBUG
                    viewModel.fetchDetails(for: cs)
                #endif
            } label: {
                HStack {
                    Image(systemName: "arrow.trianglehead.turn.up.right.diamond.fill")
                        .font(.title2)
                    Text("Get directions")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)

            content()
                .padding(.top, 12)

            Spacer()
        }
        .padding()
    }
}

extension DetailView {

    @ViewBuilder
    func content() -> some View {
        VStack(alignment: .leading) {
            Text("Available Buse(s)")
                .font(.headline)

            // Maybe this should be a navigation stack idk..
            List(buses, id: \.self) { bus in
                HStack {
                    Image(systemName: "bus")
                        .imageScale(.large)
                    Text(bus)
                        .font(.title3)
                }
                .padding(.vertical)
            }
            .listStyle(.plain)
        }

    }
}

#Preview {
    DetailView(stop: nil)
}
