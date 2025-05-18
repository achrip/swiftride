import GameplayKit

class StopGraphNode: GKGraphNode2D {
    let stopID: UUID

    init(stop: Stop) {
        let position = vector_float2(Float(stop.latitude), Float(stop.longitude))
        self.stopID = stop.id
        super.init(point: position)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
}
