import GameplayKit
import SwiftData

class RouteGraphBuilder {
    var stopNodes: [UUID: StopGraphNode] = [:]
    var graph: GKGraph = GKGraph()

    func buildGraph(from context: ModelContext) {
        // Fetch all stops once
        let stopsFetch = FetchDescriptor<Stop>()
        let stops = (try? context.fetch(stopsFetch)) ?? []

        // Create a node for each stop
        for stop in stops {
            let node = StopGraphNode(stop: stop)
            stopNodes[stop.id] = node
            graph.add([node])
        }

        // Fetch all schedules in one go, sorted by route + stopOrder
        let schedulesFetch = FetchDescriptor<Schedule>(
            sortBy: [
                SortDescriptor(\.route.name, order: .forward),
                SortDescriptor(\.stopOrder, order: .forward),
            ]
        )
        let schedules = (try? context.fetch(schedulesFetch)) ?? []

        // Group schedules by Route name
        let schedulesByRoute = Dictionary(grouping: schedules, by: { $0.route.name })

        // For each route group, connect consecutive stops
        for (_, routeSchedules) in schedulesByRoute {
            for pair in zip(routeSchedules, routeSchedules.dropFirst()) {
                let fromStop = pair.0.stop
                let toStop = pair.1.stop

                if let fromNode = stopNodes[fromStop.id],
                    let toNode = stopNodes[toStop.id]
                {
                    fromNode.addConnections(to: [toNode], bidirectional: false)
                }
            }
        }
    }

    func findPath(from startStop: Stop, to endStop: Stop, context: ModelContext) -> [Stop]? {
        guard let startNode = stopNodes[startStop.id],
            let endNode = stopNodes[endStop.id]
        else {
            print("Start or end stop not found in graph.")
            return nil
        }

        // Find the path using GameplayKit
        let pathNodes = graph.findPath(from: startNode, to: endNode)

        // Convert path nodes back to Stop model objects
        let stopsPath = pathNodes.compactMap { node in
            (node as? StopGraphNode).flatMap { graphNode in
                // Fetch actual Stop model object from context using stopID
                let stopID = graphNode.stopID
                let descriptor = FetchDescriptor<Stop>(
                    predicate: #Predicate { $0.id == stopID }
                )
                return try? context.fetch(descriptor).first
            }
        }

        return stopsPath
    }

}

