import SwiftUI

class DetailViewModel: ObservableObject {

    var buses: [Bus]
    var schedules: [Schedule]
    var stops: [Stop]
    var currentDate: Date

    init() {
        self.schedules = []
        self.buses = []
        self.stops = []
        self.currentDate = Date()
    }

    func fetchData() throws {
        do {
            self.schedules = try DataLoader().loadData(for: .schedule, as: [Schedule].self)
            self.buses = try DataLoader().loadData(for: .bus, as: [Bus].self)
            self.stops = try DataLoader().loadData(for: .stop, as: [Stop].self)
        } catch {
            throw error
        }
    }

    func fetchDetails(for stop: Stop) {
        let filteredSchedules = self.schedules.filter {
            $0.stopName.localizedCaseInsensitiveContains(stop.name)
        }
        let currentTime = Date()

//        let schedulesByBusNumber = Dictionary(grouping: filteredSchedules) { $0.busNumber }
//        
//        let upcomingSchedules = schedulesByBusNumber.values.compactMap{ schedules -> Schedule? in
//            return schedules.min(by: { a, b in
//                a.time > currentTime
//            })
//        }
//        
//        print(upcomingSchedules)
        
        // MARK: -- Returning an array of [String: UUID] for the upcoming schedules

        let uniqueRoutes = Set(filteredSchedules.map { $0.busNumber })
        let currentStopRoutes = uniqueRoutes.compactMap { busNumber -> Bus? in
            buses.first { $0.number == busNumber }
        }
        
//        let currentTime = Date().toUTCPlus7()!// Get the current system time
        
        let earliestETAs: [Int: UUID] = currentStopRoutes.reduce(into: [:]){ result, bus in
            let busSchedules = filteredSchedules.filter { $0.busNumber == bus.number}
            if let earliestTime = busSchedules.min(by: { (date1, date2) -> Bool in
                date1.time > currentTime // Compare with currentTime
            }) {
                result[bus.number] = earliestTime.id
            }
        }
       
        print(earliestETAs)
        
        
        // MARK: -- Return an array of Schedules
        let testETA: [Schedule] = currentStopRoutes.compactMap { bus in
            let scheduledForBus = filteredSchedules.filter { $0.busNumber == bus.number }
            return scheduledForBus.min(by: { (date1, date2) -> Bool in
                date1.time > currentTime
            })
        }
        
        print(testETA)
        
        // MARK: -- Return an array of Schedule IDs
        let idETA: [UUID] = currentStopRoutes.compactMap { bus in
            let scheduledForBus = filteredSchedules.filter { $0.busNumber == bus.number }
            return scheduledForBus.min(by: { (date1, date2) -> Bool in
                date1.time > currentTime 
            })?.id
        }
        
        print(idETA)
        
        // MARK: -- Debug
        for s in testETA {
            print(calculateETA(for: s))
        }
        
    }
    
    func calculateETA(for schedule: Schedule) -> Int{
        let calendar = Calendar.current
        
        let scheduleComponents = calendar.dateComponents([.hour, .minute], from: schedule.time)
        let components = calendar.dateComponents([.hour, .minute], from: Date())
        
        let scheduleMinutes = scheduleComponents.hour! * 60 + scheduleComponents.minute!
        let currentMinutes = components.hour! * 60 + components.minute!
        
        return scheduleMinutes - currentMinutes
        
    }
}
