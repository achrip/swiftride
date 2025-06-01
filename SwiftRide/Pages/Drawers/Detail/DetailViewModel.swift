import SwiftUI

@MainActor
final class DetailViewModel: ObservableObject {

    @Published var upcomingSchedules: [(Schedule, Int)]

    var buses: [Bus]
    var schedules: [Schedule]
    var stops: [Stop]

    private var refreshTask: Task<Void, Never>?

    init() {
        self.schedules = []
        self.buses = []
        self.stops = []
        self.upcomingSchedules = []
    }
}

extension DetailViewModel {

    func fetchData() async throws {
        do {
            self.schedules = try DataLoader().loadData(for: .schedule, as: [Schedule].self)
            self.buses = try DataLoader().loadData(for: .bus, as: [Bus].self)
            self.stops = try DataLoader().loadData(for: .stop, as: [Stop].self)
        } catch {
            throw error
        }
    }

    func fetchDetails(for stop: Stop?) async {
        if let stop {
            let filteredSchedules = self.schedules.filter {
                $0.stopName.localizedCaseInsensitiveContains(stop.name)
            }
            let currentTime = Date()

            let uniqueRoutes = Set(filteredSchedules.map { $0.busNumber })
            let currentStopRoutes = uniqueRoutes.compactMap { busNumber -> Bus? in
                buses.first { $0.number == busNumber }
            }

            self.upcomingSchedules = currentStopRoutes.compactMap { bus in
                let scheduledForBus = filteredSchedules.filter {
                    $0.busNumber == bus.number && $0.time > currentTime
                }
                guard
                    let nextSchedule = scheduledForBus.min(by: { (date1, date2) -> Bool in
                        date1.time < date2.time
                    })
                else {
                    // no future schedules for this bus
                    return nil
                }

                let eta = calculateETA(for: nextSchedule)
                if eta >= 0 {
                    return (nextSchedule, eta)
                } else {
                    return nil
                }
            }
        }

        // sort ascending based on eta
        self.upcomingSchedules.sort { $0.1 < $1.1 }
    }

    func calculateETA(for schedule: Schedule) -> Int {
        let calendar = Calendar.current

        let scheduleComponents = calendar.dateComponents([.hour, .minute], from: schedule.time)
        let components = calendar.dateComponents([.hour, .minute], from: Date())

        let scheduleMinutes = scheduleComponents.hour! * 60 + scheduleComponents.minute!
        let currentMinutes = components.hour! * 60 + components.minute!

        return scheduleMinutes - currentMinutes

    }

    func startAutoRefresh(for stop: Stop?) {
        // Cancel any existing refresh task
        refreshTask?.cancel()

        // Start a new one
        refreshTask = Task {
            while !Task.isCancelled {
                if let stop { await fetchDetails(for: stop) }
                try? await Task.sleep(nanoseconds: 45 * 1_000_000_000)
            }
        }
    }

    func stopAutoRefresh() {
        refreshTask?.cancel()
        refreshTask = nil
    }
}
