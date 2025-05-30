import MapKit
import SwiftUI

struct StopAnnotation: View {
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
    }
}

#Preview {
    //StopAnnotation(stop: Stop(name: "", latitude: 0, longitude: 0))
}
