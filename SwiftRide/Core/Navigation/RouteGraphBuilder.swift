import GameplayKit
import SwiftData

class RouteGraph {
    static let shared = RouteGraph()
    
    var stopNodes: [UUID: StopGraphNode] = [:]
    var graph: GKGraph = GKGraph()

    private var context: ModelContext!

    init() { }
    
    func configure(with context: ModelContext) {
        self.context = context
    }

    func buildGraph() {
        stopNodes = [:]
        graph = GKGraph()

        // Fetch all stops
        let stopDescriptor = FetchDescriptor<Stop>()
        let stops = (try? context.fetch(stopDescriptor)) ?? []

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

    /// Finds path and returns a list of (Stop, Route?) pairs for the path
    func findPath(from start: Stop, to end: Stop) -> [(stop: Stop, route: Route?)] {
        guard let startNode = stopNodes[start.id],
            let endNode = stopNodes[end.id]
        else {
            return []
        }

        // Find the path using GameplayKit
        let pathNodes = graph.findPath(from: startNode, to: endNode)

        var result: [(Stop, Route?)] = []
        var lastRoute: Route? = nil

        for i in 0..<pathNodes.count {
            guard let node = pathNodes[i] as? StopGraphNode else { continue }

            let nodeStopID = node.stopID
            let stopDescriptor = FetchDescriptor<Stop>(
                predicate: #Predicate { $0.id == nodeStopID }
            )
            guard let stop = try? context.fetch(stopDescriptor).first else { continue }

            var currentRoute: Route? = nil

            if i > 0, let prevNode = pathNodes[i - 1] as? StopGraphNode {
                let prevStopID = prevNode.stopID

                // First try to continue on lastRoute if possible
                if let lastRouteID = lastRoute?.persistentModelID {
                    let nextStopDescriptor = FetchDescriptor<Schedule>(
                        predicate: #Predicate {
                            $0.route.persistentModelID == lastRouteID && $0.stop.id == prevStopID
                        }
                    )
                    if let schedule = try? context.fetch(nextStopDescriptor).first {
                        let nextStopOrder = schedule.stopOrder + 1

                        let continuationDescriptor = FetchDescriptor<Schedule>(
                            predicate: #Predicate {
                                $0.route.persistentModelID == lastRouteID
                                    && $0.stopOrder == nextStopOrder && $0.stop.id == nodeStopID
                            }
                        )
                        if (try? context.fetch(continuationDescriptor).first) != nil {
                            currentRoute = lastRoute
                        }
                    }
                }

                // If not, find any valid route between prev and current
                if currentRoute == nil {
                    let routeDescriptor = FetchDescriptor<Schedule>(
                        predicate: #Predicate {
                            ($0.stop.id == prevStopID || $0.stop.id == nodeStopID)
                                && $0.stopOrder >= 0
                        }
                    )
                    let schedules = (try? context.fetch(routeDescriptor)) ?? []

                    for schedule in schedules {
                        let routeID = schedule.route.persistentModelID
                        let nextStopOrder = schedule.stopOrder + 1

                        let nextStopDescriptor = FetchDescriptor<Schedule>(
                            predicate: #Predicate {
                                $0.route.persistentModelID == routeID
                                    && $0.stopOrder == nextStopOrder && $0.stop.id == nodeStopID
                            }
                        )
                        if (try? context.fetch(nextStopDescriptor).first) != nil {
                            currentRoute = schedule.route
                            break
                        }
                    }
                }
            }

            result.append((stop, currentRoute))
            lastRoute = currentRoute
        }

        return result
    }
//    
//    func computeEstimatedTravelTime(for path: [(stop: Stop, route: Route?)]) -> TimeInterval {
//        var totalTime: TimeInterval = 0
//
//        for i in 1..<path.count {
//            let fromStop = path[i - 1].stop
//            let toStop = path[i].stop
//            let route = path[i].route
//
//            // Fetch schedule for fromStop
//            let fromDescriptor = FetchDescriptor<Schedule>(
//                predicate: #Predicate {
//                    $0.stop.id == fromStop.id &&
//                    $0.route == route
//                }
//            )
//            guard let fromSchedule = try? context.fetch(fromDescriptor).first else { continue }
//
//            // Fetch schedule for toStop
//            let toDescriptor = FetchDescriptor<Schedule>(
//                predicate: #Predicate {
//                    $0.stop.id == toStop.id &&
//                    $0.route == route
//                }
//            )
//            guard let toSchedule = try? context.fetch(toDescriptor).first else { continue }
//
//            // Calculate time difference
//            let timeDifference = toSchedule.time.timeIntervalSince(fromSchedule.time)
//            totalTime += timeDifference
//        }
//
//        return totalTime
//    }
}
