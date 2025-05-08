import SwiftData
import SwiftUI

extension Color {
    static func color(for id: PersistentIdentifier) -> Color {
        let hashValue = abs(id.hashValue)
        let hue = Double((hashValue % 256)) / 255.0
        return Color(hue: hue, saturation: 0.9, brightness: 0.9)
    }
}
