import SwiftData
import SwiftUI

@main
struct SwiftRideApp: App {
    let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            MapView()
        }
        .environmentObject(MapService.shared)
        .environmentObject(SheetService.shared)
        .modelContainer(container)
    }

    init() {
        // 1. Locate the bundled SQLite file
        guard
            let bundledURL = Bundle.main.url(forResource: "SwiftRideData", withExtension: "sqlite")
        else {
            fatalError("❌ Could not find bundled SwiftRideData.sqlite file in app resources.")
        }

        // 2. Destination URL in app's Documents directory
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!
        let destinationURL = documentsURL.appendingPathComponent("Schedules.sqlite")

        // 3. Copy the file if it doesn't already exist there
        if !FileManager.default.fileExists(atPath: destinationURL.path) {
            do {
                try FileManager.default.copyItem(at: bundledURL, to: destinationURL)
                print("✅ Copied bundled database to: \(destinationURL.path)")
            } catch {
                fatalError("❌ Failed to copy database file to documents directory: \(error)")
            }
        }

        // 4. Create ModelConfiguration using the destinationURL
        let config = ModelConfiguration(url: destinationURL)

        // 5. Initialize the ModelContainer
        do {
            self.container = try ModelContainer(
                for: Schedule.self, Route.self, Stop.self, Connection.self,
                configurations: config
            )
        } catch {
            fatalError("❌ Unable to initialize ModelContainer: \(error)")
        }
        
        // -- MARK: Graph Initialization
        RouteGraph.shared.configure(with: container.mainContext)
        RouteGraph.shared.buildGraph()
    }

}
