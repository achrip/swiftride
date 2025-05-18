import AppIntents

struct AppIntentShortcutProvider: AppShortcutsProvider {
    
    
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: FindRouteIntent(),
            phrases: ["Find me BSD Link routes in \(.applicationName)"],
        shortTitle: "Get routes",
        systemImageName: "map.fill")
    }
}

struct FindRouteIntent: AppIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("Find routes")
    
    @Parameter(title: "From stop:") var origin: String
    @Parameter(title: "To stop:") var destination: String
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
