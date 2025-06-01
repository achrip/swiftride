import SwiftUI

struct DetailView: View {

    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: DetailViewModel = DetailViewModel()

    let stop: Stop?

    var body: some View {
        VStack {
            HStack {
                if let stop = stop {
                    Text(stop.name)
                        .font(.title)
                }

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
        .onAppear {
            do {
                try viewModel.fetchData()
            } catch {
                fatalError("Failed to fetch data. \(error)")
            }

            if let stop { viewModel.fetchDetails(for: stop) }
        }
    }
}

extension DetailView {

    @ViewBuilder
    func content() -> some View {
        VStack(alignment: .leading) {
            Text("Available Buse(s)")
                .font(.headline)

            // Maybe this should be a navigation stack idk..
            List(viewModel.upcomingSchedules, id: \.0.id) { tuple in
                HStack {
                    Image(systemName: "bus")
                        .imageScale(.large)
                    VStack(alignment: .leading) {
                        Text("Bus \(tuple.0.busNumber)")
                            .font(.title3)

                        Text("Will be arriving in approximately \(tuple.1) minutes.")
                            .font(.caption)
                    }
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
