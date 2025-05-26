import Foundation

class Stop: ObservableObject, Codable {
    let id: UUID
    let name: String
    let latitude: Float
    let longitude: Float

    init(id: UUID = UUID(), name: String, latitude: Float, longitude: Float) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }

    // MARK: -- Codable Conformance
    enum CodingKeys: String, CodingKey {
        case name
        case latitude
        case longitude
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.latitude = try container.decode(Float.self, forKey: .latitude)
        self.longitude = try container.decode(Float.self, forKey: .longitude)
        self.id = UUID()
    }

}

extension Stop {
}
