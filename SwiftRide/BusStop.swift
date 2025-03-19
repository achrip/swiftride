import SwiftData

struct BusStop {
    let _id: Int64
    var _name: String
    var _latitude: Double
    var _longitude: Double
    
    init(_id: Int64, _name: String, _latitude: Double, _longitude: Double) {
        self._id = _id
        self._name = _name
        self._latitude = _latitude
        self._longitude = _longitude
    }
}
