import Foundation
import SwiftData

@Model
class Schedule {
    @Attribute var time: Date
    @Attribute var stopOrder: Int

    @Relationship(deleteRule: .cascade) var route: Route
    @Relationship(deleteRule: .cascade) var stop: Stop

    init(time: Date = .now, stopOrder: Int = 0, route: Route, stop: Stop) {
        self.time = time
        self.stopOrder = stopOrder
        self.route = route
        self.stop = stop
    }

}
