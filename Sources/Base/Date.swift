import Foundation

public extension Date {
    
    /// Difference between device time and server time as reported in the last HTTP response.
    /// Negative value means server time is behind device time.
    @MainActor
    private(set) static var serverTimeDifference: TimeInterval = 0
    
    @MainActor @discardableResult func useForTimeAdjustment() -> TimeInterval {
        if abs(self.timeIntervalSinceNow) > 60 {
            Self.serverTimeDifference = self.timeIntervalSinceNow
        }
        return Self.serverTimeDifference
    }
    
    /// Negative value means server time is behind device time.
    @MainActor
    static var nowAdjusted: Date {
        return Date.now.addingTimeInterval(Self.serverTimeDifference)
    }
    
    private static let dateFormatter = DateFormatter()
    private static let relativeDateFormatter = DateFormatter()
    nonisolated(unsafe) private static let relativeDateTimeFormatter = RelativeDateTimeFormatter()
    
    static func fromHTTPResponse(_ s: String,
                                 timeZone: TimeZone = .current) -> Date? {
        Self.dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        Self.dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        Self.dateFormatter.timeZone = timeZone
        return Self.dateFormatter.date(from: s)
    }
    
    static func fromJSONResponse(_ s: String,
                                 timeZone: TimeZone = .current) -> Date? {
        let s = (s as NSString).deletingPathExtension // ensure milliseconds are removed
        Self.dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        Self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        Self.dateFormatter.timeZone = timeZone
        return Self.dateFormatter.date(from: s)
    }
    
    /// Return `yyyy-MM-dd HH:mm:ss` formatted string for form-urlencoded value.
    func timestampForRequest(in timeZone: TimeZone = .current) -> String {
        Self.dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        Self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        Self.dateFormatter.timeZone = timeZone
        return Self.dateFormatter.string(from: self)
    }
    
    /// Return `yyyy-MM-dd` formatted string.
    func timestampForDepartures() -> String {
        Self.dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        Self.dateFormatter.dateFormat = "yyyy-MM-dd"
        Self.dateFormatter.timeZone = TimeZone.current
        return Self.dateFormatter.string(from: self)
    }
    
    /// Return `HH:mm` formatted string for ticket scan.
    func timeForRequest() -> String {
        Self.dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        Self.dateFormatter.dateFormat = "HH:mm"
        Self.dateFormatter.timeZone = TimeZone.current
        return Self.dateFormatter.string(from: self)
    }
    
    static func fromUITimestamp(_ s: String,
                                locale: Locale = .current,
                                timeZone: TimeZone = .current) -> Date? {
        Self.dateFormatter.locale = locale
        Self.dateFormatter.dateStyle = .medium
        Self.dateFormatter.timeStyle = .short
        Self.dateFormatter.timeZone = timeZone
        return Self.dateFormatter.date(from: s)
    }
    
    static func fromUITime(_ s: String,
                           locale: Locale = .current,
                           timeZone: TimeZone = .current) -> Date? {
        Self.dateFormatter.locale = locale
        Self.dateFormatter.dateStyle = .none
        Self.dateFormatter.timeStyle = .short
        Self.dateFormatter.timeZone = timeZone
        return Self.dateFormatter.date(from: s)
    }
    
    func toUITimestamp(locale: Locale = .current,
                       timeZone: TimeZone = .current) -> String {
        Self.dateFormatter.locale = locale
        Self.dateFormatter.dateStyle = .medium
        Self.dateFormatter.timeStyle = .short
        Self.dateFormatter.timeZone = timeZone
        return Self.dateFormatter.string(from: self)
    }
    
    func toTime() -> TimeOnly? {
        return TimeOnly(from: self, in: .current)
    }
    
    func toUITime(locale: Locale = .current,
                  timeZone: TimeZone = .current) -> String {
        Self.dateFormatter.locale = locale
        Self.dateFormatter.dateStyle = .none
        Self.dateFormatter.timeStyle = .short
        Self.dateFormatter.timeZone = timeZone
        return Self.dateFormatter.string(from: self)
    }
    
    func toUITimeRelative(locale: Locale = .current,
                          timeZone: TimeZone = .current) -> String {
        Self.relativeDateFormatter.locale = locale
        Self.relativeDateFormatter.dateStyle = .medium
        Self.relativeDateFormatter.timeStyle = .short
        Self.relativeDateFormatter.timeZone = timeZone
        Self.relativeDateFormatter.doesRelativeDateFormatting = true
        return Self.relativeDateFormatter.string(from: self)
    }
    
    nonisolated func toUIDateRelative(locale: Locale = .current) -> String {
        Self.relativeDateTimeFormatter.locale = locale
        Self.relativeDateTimeFormatter.unitsStyle = .full
        Self.relativeDateTimeFormatter.dateTimeStyle = .numeric
        return Self.relativeDateTimeFormatter.localizedString(for: self, relativeTo: .now)
    }
    
    func operationalDayStart(in timeZone: TimeZone = .current) -> Date {
        var dc = Calendar(identifier: .gregorian).dateComponents(in: timeZone, from: self)
        dc.hour = 3
        dc.minute = 0
        dc.second = 0
        guard let date  = dc.date else {
            fatalError("Something went wrong with date conversion")
        }
        return date
    }
    
    func adjustedBy(days: Int,
                    for calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
    
    /// Return the result of adjusting `self` to the specified date/time unit(s) and value(s), or `nil` if adjustment has failed.
    func adjusting(year: Int? = nil,
                   month: Int? = nil,
                   day: Int? = nil,
                   hours: Int? = nil,
                   minutes: Int? = nil,
                   seconds: Int? = nil,
                   in timeZone: TimeZone) -> Date? {
        
        let calendar = Calendar(in: timeZone)
        var dc = calendar.dateComponents(in: timeZone, from: self)
        dc.year = year ?? dc.year
        dc.yearForWeekOfYear = year ?? dc.yearForWeekOfYear
        dc.month = month ?? dc.month
        dc.day = day ?? dc.day
        dc.hour = hours ?? dc.hour
        dc.minute = minutes ?? dc.minute
        dc.second = seconds ?? dc.second
        return dc.date
    }
    
    static func fromComponents(year: Int,
                               month: Int,
                               day: Int,
                               hours: Int = 0,
                               minutes: Int = 0,
                               seconds: Int = 0,
                               in timeZone: TimeZone = .current) -> Date? {
        
        return Date.now.adjusting(year: year,
                                  month: month,
                                  day: day,
                                  hours: hours,
                                  minutes: minutes,
                                  seconds: seconds,
                                  in: timeZone)
    }
}


public extension URLResponse {
    var serverTime: Date? {
        if let s = (self as? HTTPURLResponse)?.allHeaderFields["Date"] as? String,
           let d = Date.fromHTTPResponse(s) {
            return d
        }
        errorLog("Missing or invalid date header in server response")
        return nil
    }
}
