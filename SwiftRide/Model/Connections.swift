import Foundation
import SwiftData

@Model
class Connection {
    @Relationship var origin: Stop
    @Relationship var destination: Stop
    @Relationship var route: Route
    
    init(origin: Stop, destination: Stop, route: Route) {
        self.origin = origin
        self.destination = destination
        self.route = route
    }
}
