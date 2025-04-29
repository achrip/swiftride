import MapKit
import SwiftUI

struct StopAnnotation: View {
    @State private var isSelected: Bool = false

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
                .font(.system(size: 10, weight: .black))
                .offset(x: 0, y: -5)
        }
        .compositingGroup()
        .scaleEffect(self.isSelected ? 1.5 : 1, anchor: .bottom)
        .onTapGesture {
            withAnimation(.interpolatingSpring(stiffness: 300, damping: 10)) {
                self.isSelected.toggle()
            }
        }
    }
}

#Preview {
    StopAnnotation()
}
