import Foundation
import CoreLocation
import SwiftUI

struct BusStop: Identifiable, Decodable{
    let id: UUID
    var name: String
    let coordinate: CLLocationCoordinate2D
    let color: Color
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude, longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        name = try container.decode(String.self, forKey: .name)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if name.lowercased() == ".teal" {
            self.color = Color(white: 10.0/255.0)
        } else {
            self.color = Color.black
        }
    }
}

func loadBusStops() -> [BusStop] {
    guard let url = Bundle.main.url(forResource: "Stops", withExtension: "json") else {
        print("JSON file not found")
            return []
    }

    do {
        let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let stops = try decoder.decode([BusStop].self, from: data)
            return stops
    } catch {
        print("Error decoding JSON: \(error)")
            return []
    }
}

let busStops = loadBusStops()
for stops in busStops {
    print(stops.name)
    print(stops.color)
}
print(Color.teal)
