import Foundation

extension Date {
    
    /// Converts a UTC+7 datetime string to a Date in system UTC
    static func fromUTCPlus7String(_ dateString: String, format: String = "yyyy-MM-dd'T'HH:mm:ss")
    -> Date?
    {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "Asia/Jakarta")
        return formatter.date(from: dateString)
    }
    
    /// Converts a Date (in UTC) to a UTC+7 formatted string
    func toUTCPlus7String(format: String = "yyyy-MM-dd'T'HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(secondsFromGMT: 7 * 3600)
        return formatter.string(from: self)
    }
    
    // Converts a Date (in UTC) to UTC+7
    func toUTCPlus7() -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(byAdding: .hour, value: 7, to: self)
    }
}

