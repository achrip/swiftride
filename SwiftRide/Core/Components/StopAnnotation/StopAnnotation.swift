import MapKit
import SwiftUI

struct StopAnnotation: View {
    @EnvironmentObject var mapService: MapService
    @State private var isSelected: Bool = false

    let stop: Stop

    init(stop: Stop) {
        self.stop = stop
    }

    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                Image(systemName: "bus")
                    .resizable()
                    .scaledToFill()
                    .foregroundStyle(.green)
                    .frame(width: 25, height: 25)
            }
            Image(systemName: "arrowtriangle.down.fill")
                .foregroundColor(.black)
                .font(.system(size: 10, weight: .black))
                .offset(x: 0, y: -5)
        }
        .compositingGroup()
        .scaleEffect(self.isSelected ? 1.5 : 1, anchor: .bottom)
        .onTapGesture {
            mapService.selectedStop = stop
            withAnimation(.interpolatingSpring(stiffness: 300, damping: 10)) {
                self.isSelected = true
            }
        }
        .onChange(of: mapService.selectedStop) { _, newValue in
            withAnimation() {
                if newValue != stop { self.isSelected = false } else { self.isSelected = true }
            }

        }
    }
}

#Preview {
    StopAnnotation(stop: Stop(name: "", latitude: 0, longitude: 0))
}
