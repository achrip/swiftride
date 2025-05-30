import Foundation

struct Bus: Codable {
    let id: UUID
    let name: String
    let number: Int

    init(id: UUID = UUID(), name: String, number: Int) {
        self.id = id
        self.name = name
        self.number = number
    }

    // MARK: -- Codable Conformance

    enum Keys: String, CodingKey {
        case name = "bus_name"
        case number = "bus_number"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.number = try container.decode(Int.self, forKey: .number)
        self.id = UUID()
    }

}
