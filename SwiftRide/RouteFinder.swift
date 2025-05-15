import Foundation
import SwiftData

//@Observable
//class RouteFinder {
//    let modelContext: ModelContext
//
//    init(modelContext: ModelContext) {
//        self.modelContext = modelContext
//    }
//
//    struct RouteSegment: Identifiable, Hashable {
//        let id = UUID()
//        let stop: Stop
//        let route: Route
//        let departureTime: Date
//        let arrivalTime: Date
//        let isTransfer: Bool
//    }
//
//    struct FoundRoute: Identifiable, Hashable {
//        let id = UUID()
//        let segments: [RouteSegment]
//        var arrivalTime: Date {
//            segments.last?.arrivalTime ?? .distantFuture
//        }
//        var numberOfTransfers: Int {
//            segments.filter(\.isTransfer).count
//        }
//    }
//
//    /// Finds possible routes from a start stop to an end stop after a specific time
//    func findRoutes(from startStop: Stop, to endStop: Stop, startingAt startTime: Date) async throws
//        -> [FoundRoute]
//    {
//        var pathsToExplore:
//            [(segments: [RouteSegment], currentStop: Stop, arrivalTime: Date, currentRoute: Route?)] =
//                []
//        var foundRoutes: [FoundRoute] = []
//
//        // Seed initial paths from starting stop
//        let startSchedules = try fetchSchedules(at: startStop, after: startTime)
//
//        for schedule in startSchedules {
//            if let nextStopSchedule = try nextStopSchedule(after: schedule) {
//                let segment = RouteSegment(
//                    stop: schedule.stop,
//                    route: schedule.route,
//                    departureTime: schedule.time,
//                    arrivalTime: nextStopSchedule.time,
//                    isTransfer: false
//                )
//                pathsToExplore.append(
//                    ([segment], nextStopSchedule.stop, nextStopSchedule.time, schedule.route))
//            }
//        }
//
//        while !pathsToExplore.isEmpty {
//            let (segments, currentStop, arrivalTime, currentRoute) = pathsToExplore.removeFirst()
//
//            if currentStop.id == endStop.id {
//                foundRoutes.append(FoundRoute(segments: segments))
//                continue
//            }
//
//            // Continue along same route if possible
//            let sameRouteSchedules = try fetchSchedules(
//                on: currentRoute, from: currentStop, after: arrivalTime)
//            for schedule in sameRouteSchedules {
//                if let nextStopSchedule = try nextStopSchedule(after: schedule) {
//                    let segment = RouteSegment(
//                        stop: schedule.stop,
//                        route: schedule.route,
//                        departureTime: schedule.time,
//                        arrivalTime: nextStopSchedule.time,
//                        isTransfer: false
//                    )
//                    pathsToExplore.append(
//                        (
//                            segments + [segment], nextStopSchedule.stop, nextStopSchedule.time,
//                            schedule.route
//                        ))
//                }
//            }
//
//            // Check for transfers (other routes from current stop)
//            let transferSchedules = try fetchSchedules(
//                at: currentStop, after: arrivalTime, excluding: currentRoute)
//
//            for schedule in transferSchedules {
//                if let nextStopSchedule = try nextStopSchedule(after: schedule) {
//                    let segment = RouteSegment(
//                        stop: schedule.stop,
//                        route: schedule.route,
//                        departureTime: schedule.time,
//                        arrivalTime: nextStopSchedule.time,
//                        isTransfer: true
//                    )
//                    pathsToExplore.append(
//                        (
//                            segments + [segment], nextStopSchedule.stop, nextStopSchedule.time,
//                            schedule.route
//                        ))
//                }
//            }
//        }
//
//        return foundRoutes.sorted { $0.arrivalTime < $1.arrivalTime }
//    }
//
//    // MARK: - Schedule Fetch Helpers
//
//    private func fetchSchedules(at stop: Stop, after time: Date, excluding route: Route? = nil)
//        throws -> [Schedule]
//    {
//        let excludedRouteID = route?.persistentModelID
//
//        let predicate = #Predicate<Schedule> { schedule in
//            schedule.stop.persistentModelID == stop.persistentModelID && schedule.time > time
//                && (excludedRouteID == nil || schedule.route.persistentModelID != excludedRouteID)
//        }
//
//        let descriptor = FetchDescriptor<Schedule>(
//            predicate: predicate, sortBy: [SortDescriptor(\.time)]
//        )
//        return try modelContext.fetch(descriptor)
//    }
//
//    private func fetchSchedules(on route: Route?, from stop: Stop, after time: Date) throws
//        -> [Schedule]
//    {
//        guard let routeID = route?.persistentModelID else { return [] }
//
//        let predicate = #Predicate<Schedule> { schedule in
//            schedule.stop.persistentModelID == stop.persistentModelID
//                && schedule.route.persistentModelID == routeID
//                && schedule.time > time
//        }
//
//        let descriptor = FetchDescriptor<Schedule>(
//            predicate: predicate, sortBy: [SortDescriptor(\.time)])
//        return try modelContext.fetch(descriptor)
//    }
//
//    private func nextStopSchedule(after schedule: Schedule) throws -> Schedule? {
//        let routeID = schedule.route.persistentModelID
//        let stopOrder = schedule.stopOrder
//
//        let predicate = #Predicate<Schedule> { s in
//            s.route.persistentModelID == routeID
//                && s.stopOrder == stopOrder + 1
//        }
//
//        let descriptor = FetchDescriptor<Schedule>(
//            predicate: predicate, sortBy: [SortDescriptor(\.time)])
//        return try modelContext.fetch(descriptor).first
//    }
//}
//
//extension RouteFinder {
//    /// Test function to query routes and print results to console
//    func testFindRoutes(from startStop: Stop, to endStop: Stop, at startTime: Date) {
//        Task {
//            do {
//                let routes = try await findRoutes(
//                    from: startStop, to: endStop, startingAt: startTime)
//
//                if routes.isEmpty {
//                    print(
//                        "No routes found from \(startStop.name) to \(endStop.name) after \(startTime)."
//                    )
//                } else {
//                    for (index, route) in routes.enumerated() {
//                        print("Route Option \(index + 1):")
//                        for segment in route.segments {
//                            let transferNote = segment.isTransfer ? " (Transfer)" : ""
//                            print(
//                                " - \(segment.route.name) from \(segment.stop.name) at \(segment.departureTime.formatted(date: .omitted, time: .shortened)) to arrival at \(segment.arrivalTime.formatted(date: .omitted, time: .shortened))\(transferNote)"
//                            )
//                        }
//                        print(
//                            "   → Estimated arrival: \(route.arrivalTime.formatted(date: .omitted, time: .shortened))"
//                        )
//                        print("   → Transfers: \(route.numberOfTransfers)\n")
//                    }
//                }
//            } catch {
//                print("Error finding routes: \(error.localizedDescription)")
//            }
//        }
//    }
//}

class RouteFinder {
    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func findRoutes(from fromStop: Stop, to toStop: Stop) -> [[Route]] {
        var possibleRoutes: [[Route]] = []

        // 1. Find all schedules for fromStop
        let fromSchedules = fetchSchedules(for: fromStop)

        // 2. Direct routes
        for fromSchedule in fromSchedules {
            let route = fromSchedule.route
            let fromOrder = fromSchedule.stopOrder

            // See if toStop exists on this route after fromStop
            if let toSchedule = fetchSchedule(for: toStop, on: route),
                toSchedule.stopOrder > fromOrder
            {
                possibleRoutes.append([route])
            }
        }

        // 3. Indirect (transfer) routes
        // Find transfer stops connected from fromStop
        for fromSchedule in fromSchedules {
            let route = fromSchedule.route
            let fromOrder = fromSchedule.stopOrder

            let possibleTransferSchedules = fetchSchedules(after: fromOrder, on: route)

            for transferSchedule in possibleTransferSchedules {
                let transferStop = transferSchedule.stop

                // Find routes from this transfer stop to toStop
                let transferSchedules = fetchSchedules(for: transferStop)
                for transferSchedule in transferSchedules {
                    let transferRoute = transferSchedule.route

                    if let toSchedule = fetchSchedule(for: toStop, on: transferRoute),
                        toSchedule.stopOrder > transferSchedule.stopOrder
                    {
                        possibleRoutes.append([route, transferRoute])
                    }
                }
            }
        }

        return possibleRoutes
    }

    // MARK: - Helper Queries

    private func fetchSchedules(for stop: Stop) -> [Schedule] {
        let stopID = stop.persistentModelID
        let descriptor = FetchDescriptor<Schedule>(
            predicate: #Predicate { $0.stop.persistentModelID == stopID }
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    private func fetchSchedule(for stop: Stop, on route: Route) -> Schedule? {
        let stopID = stop.persistentModelID
        let routeID = route.persistentModelID
        let descriptor = FetchDescriptor<Schedule>(
            predicate: #Predicate { $0.stop.persistentModelID == stopID && $0.route.persistentModelID == routeID }
        )
        return try? context.fetch(descriptor).first
    }

    private func fetchSchedules(after order: Int, on route: Route) -> [Schedule] {
        let routeID = route.persistentModelID
        let descriptor = FetchDescriptor<Schedule>(
            predicate: #Predicate { $0.route.persistentModelID == routeID && $0.stopOrder > order }
        )
        return (try? context.fetch(descriptor)) ?? []
    }
}
