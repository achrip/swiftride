import Foundation

final class DataLoader {
    enum UrlType {
        case stop, bus, schedule

        var url: URL? {
            switch self {
            case .stop:
                return Bundle.main.url(forResource: "Stops", withExtension: "json")
            case .bus:
                return Bundle.main.url(forResource: "Bus", withExtension: "json")
            case .schedule:
                return Bundle.main.url(forResource: "Schedule", withExtension: "json")
            }
        }
    }

    func loadData<T: Decodable>(for fileUrl: UrlType, as type: T.Type) throws -> T {
        guard let url = fileUrl.url else {
            throw NSError(domain: "Missing file", code: 404)
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try JSONDecoder().decode(T.self, from: data)
    }

    //    func loadData<T: Decodable>(for fileUrl: UrlType, as type: T.Type) -> T? {
    //        guard let url = fileUrl.url else {
    //            print("Missing file for: \(fileUrl)")
    //            return nil
    //        }
    //
    //        do {
    //            let data = try Data(contentsOf: url)
    //            let decoder = JSONDecoder()
    //            let result = try decoder.decode(T.self, from: data)
    //            return result
    //        } catch {
    //            print("Failed to load \(fileUrl) — \(error.localizedDescription)")
    //            return nil
    //        }
    //    }
}
