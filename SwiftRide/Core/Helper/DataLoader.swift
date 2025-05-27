import Foundation

protocol DataLoader {
    func loadData()

    //func loadData(from filename: String, with extension: String)
}

final class StopLoader: ObservableObject, DataLoader {

    @Published var stops: [Stop] = []

    let fileName: String = "BusStop"
    let fileExtension: String = "json"

    func loadData() {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            fatalError("Resource named " + fileName + "." + fileExtension + " not found.")
        }

        do {
            let data = try Data(contentsOf: url)
            let stops = try JSONDecoder().decode([Stop].self, from: data)
            self.stops = stops
        } catch {
            assertionFailure("Failed to fetch or read data from " + fileName + "." + fileExtension)
        }
    }
}

final class ScheduleLoader: ObservableObject, DataLoader {

    @Published var schedules: [Schedule] = []

    let fileName: String = "Schedule"
    let fileExtension: String = "json"

    func loadData() {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            fatalError("Resource named " + fileName + "." + fileExtension + " not found.")
        }

        do {
            let data = try Data(contentsOf: url)
            let schedules = try JSONDecoder().decode([Schedule].self, from: data)
            self.schedules = schedules
        } catch {
            assertionFailure("Failed to fetch or read data from " + fileName + "." + fileExtension)
        }

    }
}

final class BusLoader: ObservableObject, DataLoader {

    @Published var buses: [Bus] = []

    let fileName: String = "Bus"
    let fileExtension: String = "json"

    func loadData() {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            fatalError("Resource named " + fileName + "." + fileExtension + " not found.")
        }

        do {
            let data = try Data(contentsOf: url)
            let buses = try JSONDecoder().decode([Bus].self, from: data)
            self.buses = buses
        } catch {
            assertionFailure("Failed to fetch or read data from " + fileName + "." + fileExtension)
        }
    }

}
