import Drawer
import SwiftUI

struct DetailView: View, Sendable {

    @State var restingHeight: [CGFloat] = drawerSecondary
    @State var currentDrawerHeight: CGFloat = drawerSecondary[0]
    
    @StateObject var viewModel: DetailViewModel = DetailViewModel()

    #if DEBUG
    let buses = ["123", "456", "789"]
    @State var cs: Stop = .init(name: "Terminal Intermoda", latitude: -6.321395070998093, longitude: 106.64347051762091)
#endif

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

                    HStack {
                        Text("Stoppu")
                            .font(.title)

                        Button {

                        } label: {
                            Image(systemName: "star.fill")
                                .imageScale(.large)
                                .foregroundStyle(Color(.systemGray3))
                        }

                        Spacer()

                        Button {

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
                    .padding(.top, 12)

                    content()
                        .padding(.top, 12)

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
        .onAppear {
            do {
                try viewModel.fetchData()
            } catch {
                fatalError("Failed to fetch data: \(error)")
            }
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
    DetailView()
}
