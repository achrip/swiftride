import MapKit
import SwiftUI

struct StopAnnotation: View {

    @Binding var selectedStop: Stop?

    let stop: Stop
    var isSelected: Bool { selectedStop == stop }

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
        .scaleEffect(isSelected ? 1.8 : 1.1, anchor: .bottom)
        .animation(.interpolatingSpring(stiffness: 300, damping: 20), value: isSelected)
        .onTapGesture {
            withAnimation(.interpolatingSpring(stiffness: 300, damping: 20)) {
                selectedStop = stop
            }
        }
    }
}

#Preview {
    let dummyStop = Stop(name: "Title", latitude: 0, longitude: 0)
    StopAnnotation(selectedStop: .constant(nil), stop: dummyStop)
}
