import Foundation

public extension Calendar {
    
    init(in timeZone: TimeZone) {
        self.init(identifier: .gregorian)
        self.timeZone = timeZone
    }
}

/// Time and timezone-agnostic date representation that can be easily converted to a `Date` object.
public struct DateOnly: Codable, Hashable, CustomStringConvertible, Sendable {
    public let year: Int
    public let month: Int
    public let day: Int
    
    public var description: String {
        return String(format: "%04d-%02d-%02d", year, month, day)
    }

    public init?(year: Int, month: Int, day: Int) {
        guard year > 1969,
              month > 0 && month <= 12,
              day > 0 && day <= 31 else {
            return nil
        }
        
        if (month == 4 || month == 6 || month == 9 || month == 11) && day > 30 {
            return nil
        }
        
        if year % 4 != 0 && month == 2 && day > 28
            || year % 4 == 0 && month == 2 && day > 29 {
            return nil
        }
        
        self.year = year
        self.month = month
        self.day = day
    }
    
    public init?(from date: Date,
                 in timeZone: TimeZone = .current) {
        let calendar = Calendar(in: timeZone)
        let dc = calendar.dateComponents([.year, .month, .day], from: date)
        guard let year = dc.year,
              let month = dc.month,
              let day = dc.day else {
            return nil
        }
        self.year = year
        self.month = month
        self.day = day
    }
    
    public func toDate(in timeZone: TimeZone) -> Date? {
        let calendar = Calendar(in: timeZone)
        return DateComponents(calendar: calendar, year: year, month: month, day: day).date
    }
}


/// Date-agnositc 24-hour time representation that can be easily converted to a `Date` object.
public struct TimeOnly: Codable, Hashable, CustomStringConvertible, Sendable {
    public let hours: Int
    public let minutes: Int
    public let seconds: Int
    
    public var description: String {
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    public init?(withoutValidation timeString: String) {
        let a = timeString.components(separatedBy: ":")
        if a.count >= 2,
           a[0].count == 2, let hours = Int(a[0]),
           a[1].count == 2, let minutes = Int(a[1]) {
            
            self.hours = hours
            self.minutes = minutes
            self.seconds = 0
            return
        }
        return nil
    }
    
    public init?(_ timeString: String) {
        let a = timeString.components(separatedBy: ":")
        if a.count >= 2,
           a[0].count == 2, let hours = Int(a[0]), hours < 24, hours >= 0,
           a[1].count == 2, let minutes = Int(a[1]), minutes < 60, minutes >= 0 {
            
            self.hours = hours
            self.minutes = minutes
            self.seconds = 0
            return
        }
        return nil
    }
    
    public init?(hours: Int, minutes: Int, seconds: Int) {
        guard hours >= 0 && hours < 24,
              minutes >= 0 && minutes < 60,
              seconds >= 0 && seconds < 61 /* allow leap second */ else {
            return nil
        }
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
    
    public init?(from date: Date,
                 in timeZone: TimeZone = .current) {
        let calendar = Calendar(in: timeZone)
        let dc = calendar.dateComponents([.hour, .minute, .second], from: date)
        guard let hours = dc.hour,
              let minutes = dc.minute,
              let seconds = dc.second else {
            return nil
        }
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
    
    public func toDate(at date: Date = .now,
                       in timeZone: TimeZone = .current) -> Date? {
        return date.adjusting(hours: self.hours,
                              minutes: self.minutes,
                              seconds: self.seconds,
                              in: timeZone)
    }
}
