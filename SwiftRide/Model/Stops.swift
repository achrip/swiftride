import CoreLocation
import SwiftData

@Model
class Stop {
    @Attribute var id: UUID
    @Attribute var name: String
    @Attribute var latitude: Double
    @Attribute var longitude: Double

    //@Relationship(inverse: \Schedule.stop) var schedule: Schedule

    init(name: String, latitude: Double, longitude: Double) {
        self.id = UUID()
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
