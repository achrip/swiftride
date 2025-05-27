import Foundation

struct Schedule: Codable {
    let id: UUID
    let time: Date
    let session: Int
    let busNumber: Int
    let stopName: String
    let stopOrder: Int

    init(
        id: UUID = UUID(), time: Date = .now, session: Int, busNumber: Int, stopName: String,
        stopOrder: Int
    ) {
        self.id = id
        self.time = time
        self.session = session
        self.busNumber = busNumber
        self.stopName = stopName
        self.stopOrder = stopOrder
    }

    // MARK: -- Codable Conformance

    enum CodingKeys: String, CodingKey {
        case time = "arrival_time"
        case busNumber = "bus_number"
        case stopName = "stop_name"
        case stopOrder = "stop_order"
        case session
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.time = try container.decode(Date.self, forKey: .time)
        self.busNumber = try container.decode(Int.self, forKey: .busNumber)
        self.stopName = try container.decode(String.self, forKey: .stopName)
        self.session = try container.decode(Int.self, forKey: .session)
        self.stopOrder = try container.decode(Int.self, forKey: .stopOrder)
        self.id = UUID()
    }

}
