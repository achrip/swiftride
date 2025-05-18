import GameplayKit
import SwiftData
import SwiftUI

struct PathFinderView: View {
    @Environment(\.modelContext) private var context

    @State private var stops: [Stop] = []
    @State private var selectedStart: Stop?
    @State private var selectedEnd: Stop?
    @State private var pathResult: [Stop] = []

    // Local graph and stopNodes
    @State private var graph = GKGraph()
    @State private var stopNodes: [UUID: StopGraphNode] = [:]

    var body: some View {
        NavigationStack {
            Form {
                Section("Select Stops") {
                    Picker("Start Stop", selection: $selectedStart) {
                        ForEach(stops, id: \.id) { stop in
                            Text(stop.name).tag(Optional(stop))
                        }
                    }

                    Picker("End Stop", selection: $selectedEnd) {
                        ForEach(stops, id: \.id) { stop in
                            Text(stop.name).tag(Optional(stop))
                        }
                    }

                    Button("Find Path") {
                        if let start = selectedStart, let end = selectedEnd {
                            pathResult = findPath(from: start, to: end)
                        }
                    }
                    .disabled(selectedStart == nil || selectedEnd == nil)
                }

                if !pathResult.isEmpty {
                    Section("Path Result") {
                        ForEach(pathResult, id: \.id) { stop in
                            Text(stop.name)
                        }
                    }
                }
            }
            .navigationTitle("Transit Path Finder")
            .onAppear {
                loadStops()
            }
        }
    }

    // Load stops and build graph
    private func loadStops() {
        let descriptor = FetchDescriptor<Stop>(sortBy: [SortDescriptor(\.name)])
        stops = (try? context.fetch(descriptor)) ?? []

        buildGraph()
    }

    // Build graph locally after stops loaded
    private func buildGraph() {
        stopNodes = [:]
        graph = GKGraph()

        for stop in stops {
            let node = StopGraphNode(stop: stop)
            stopNodes[stop.id] = node
            graph.add([node])
        }

        // Connect nodes based on Schedule data
        let scheduleDescriptor = FetchDescriptor<Schedule>()
        let schedules = (try? context.fetch(scheduleDescriptor)) ?? []

        for schedule in schedules {
            guard let fromNode = stopNodes[schedule.stop.id] else { continue }

            // Find next stop on the same route
            let routeID = schedule.route.persistentModelID
            let stopOrder = schedule.stopOrder
            let nextStopDescriptor = FetchDescriptor<Schedule>(
                predicate: #Predicate {
                    $0.route.persistentModelID == routeID && $0.stopOrder == stopOrder + 1
                }
            )
            if let nextSchedule = try? context.fetch(nextStopDescriptor).first,
                let toNode = stopNodes[nextSchedule.stop.id]
            {
                fromNode.addConnections(to: [toNode], bidirectional: false)
            }
        }
    }

    // Pathfinding call
    private func findPath(from start: Stop, to end: Stop) -> [Stop] {
        guard let startNode = stopNodes[start.id],
            let endNode = stopNodes[end.id]
        else {
            return []
        }

        let pathNodes = graph.findPath(from: startNode, to: endNode)

        let stopsPath = pathNodes.compactMap { node in
            (node as? StopGraphNode).flatMap { graphNode in
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
