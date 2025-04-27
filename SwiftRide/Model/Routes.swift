import Foundation
import SwiftData

@Model
class Route {
    @Attribute var name: String

    //@Relationship(inverse: \Schedule.route) var schedule: Schedule

    init(name: String) {
        self.name = name
    }
}
