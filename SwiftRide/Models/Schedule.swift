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
        let now = Date()
        
        self.busNumber = try container.decode(Int.self, forKey: .busNumber)
        self.stopName = try container.decode(String.self, forKey: .stopName)
        self.session = try container.decode(Int.self, forKey: .session)
        self.stopOrder = try container.decode(Int.self, forKey: .stopOrder)
        self.id = UUID()
        
        
        let dateString = try container.decode(String.self, forKey: .time)
        let date = ISO8601DateFormatter().date(from: dateString)!

        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.year, .month, .day], from: now)

        var targetComponents = calendar.dateComponents([.hour, .minute, .second, .timeZone], from: date)

        targetComponents.year = currentComponents.year
        targetComponents.month = currentComponents.month
        targetComponents.day = currentComponents.day
        
        self.time = calendar.date(from: targetComponents) ?? now
        print(self.time)
    }
}
