import Foundation

class Route {
    let name: String
    let number: Int
    let licensePlate: String
    let color: String

    enum Keys: String, CodingKey {
        case name = "bus_name"
        case number = "bus_number"
        case licensePlate = "license_plate"
        case color = "bus_color"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.number = try container.decode(Int.self, forKey: .number)
        self.licensePlate = try container.decode(String.self, forKey: .licensePlate)

        self.color = try container.decode(String.self, forKey: .color)
    }

}
