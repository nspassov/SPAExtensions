import XCTest
@testable import SPAExtensions

extension XCTestCase {
    
    static let nycTimeZone = TimeZone(identifier: "America/New_York")!
    static let ldnTimeZone = TimeZone(identifier: "Europe/London")!
    
    func adjustTimeZone(_ timeZone: TimeZone? = nil) {
        if let timeZone = timeZone {
            setenv("TZ", timeZone.identifier, 1)
        }
        CFTimeZoneResetSystem()
        
        print(">>> System TimeZone is \(TimeZone.current)")
        print(">>> System Locale is \(Locale.current)")
    }
}

extension Locale {
    static let us = Locale(identifier: "en_US")
    static let bg = Locale(identifier: "bg_BG")
}


final class DateConversionTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test11() throws {
        adjustTimeZone(Self.nycTimeZone)
        let dateString = "Aug 12, 2024 at 4:13 AM" // non-breaking space before AM
        
        let dateObject = Date.fromUITimestamp(dateString, locale: Locale.us, 
                                              timeZone: Self.ldnTimeZone)
        XCTAssertNotNil(dateObject)
        
        let reversedDateString = dateObject?.toUITimestamp(locale: Locale.us, 
                                                           timeZone: Self.ldnTimeZone)
        XCTAssertEqual(reversedDateString, dateString)
    }
    
    func test12() throws {
        adjustTimeZone(Self.ldnTimeZone)
        let dateString = "12.08.2024 г., 9:14"
        
        let dateObject = Date.fromUITimestamp(dateString, locale: Locale.bg)
        XCTAssertNotNil(dateObject)
        
        let reversedDateString = dateObject?.toUITimestamp(locale: Locale.bg)
        XCTAssertEqual(reversedDateString, dateString)
    }
    
    
    func test21() throws {
        adjustTimeZone(Self.nycTimeZone)
        let date = Date.now.operationalDayStart()
        let dc = Calendar.current.dateComponents(in: .current, from: date)
        
        XCTAssertEqual(dc.hour, 3)
    }
    
    func test22() throws {
        adjustTimeZone(Self.ldnTimeZone)
        let date = Date.now.operationalDayStart(in: Self.nycTimeZone)
        let dc = Calendar.current.dateComponents(in: Self.nycTimeZone, from: date)
        
        XCTAssertEqual(dc.hour, 3)
        XCTAssertEqual(dc.minute, 0)
        XCTAssertEqual(dc.second, 0)
    }
    
    
    func test31() throws {
        adjustTimeZone(Self.nycTimeZone)
        
        let date = Date.fromComponents(year: 2024,
                                       month: 10,
                                       day: 15,
                                       hours: 20,
                                       minutes: 12,
                                       seconds: 59)
        XCTAssertNotNil(date)
        
        let dateString = date!.timestampForRequest()
        XCTAssertEqual(dateString, "2024-10-15 20:12:59")
    }
    
    func test41() throws {
        adjustTimeZone(Self.ldnTimeZone)
        
        let date = Date.fromComponents(year: 2024,
                                       month: 10,
                                       day: 15,
                                       hours: 20,
                                       minutes: 12,
                                       seconds: 59)
        XCTAssertNotNil(date)
        
        let dateString = date!.timestampForDepartures()
        XCTAssertEqual(dateString, "2024-10-15")
    }
    
    
    func test51() throws {
        adjustTimeZone(Self.ldnTimeZone)
        
        let date = Date.fromComponents(year: 2024,
                                       month: 10,
                                       day: 15,
                                       hours: 20,
                                       minutes: 12,
                                       seconds: 59)
        XCTAssertNotNil(date)
        
        let dateOffset = date!.adjustedBy(days: 2)
        let dc = Calendar.current.dateComponents(in: .current, from: dateOffset)
        XCTAssertEqual(dc.year, 2024)
        XCTAssertEqual(dc.month, 10)
        XCTAssertEqual(dc.day, 17)
        XCTAssertEqual(dc.hour, 20)
        XCTAssertEqual(dc.minute, 12)
        XCTAssertEqual(dc.second, 59)
    }
    
    func test52() throws {
        adjustTimeZone(Self.ldnTimeZone)
        
        let date = Date.fromComponents(year: 2024,
                                       month: 10,
                                       day: 15,
                                       hours: 20,
                                       minutes: 12,
                                       seconds: 59)
        XCTAssertNotNil(date)
        
        let dateString = date!.toUITimestamp(locale: Locale.us)
        XCTAssertEqual(dateString, "Oct 15, 2024 at 8:12 PM") // non-breaking space before PM
    }
    
    
    func test71() throws {
        adjustTimeZone()
        
        let date = Date.fromComponents(year: 2024,
                                       month: 10,
                                       day: 15,
                                       hours: 20,
                                       minutes: 12,
                                       seconds: 59)
        XCTAssertNotNil(date)
        
        XCTAssertEqual(date!.timestampForRequest(), "2024-10-15 20:12:59")
        XCTAssertEqual(date!.timeForRequest(), "20:12")
    }
    
    
    func test81() throws {
        let d1 = Date.fromJSONResponse("2023-12-20T13:14:15.123")
        XCTAssertNotNil(d1)
        
        let d2 = Date.fromJSONResponse("2023-12-20T13:14:15")
        XCTAssertNotNil(d2)
        
        XCTAssertEqual(d1, d2)
    }
    
    func testDateAdjusting1() throws {
        let d1 = Date.fromJSONResponse("2012-12-20T13:14:15.123")!
        
        XCTAssertEqual(d1.timestampForRequest(), "2012-12-20 13:14:15")
        
        XCTAssertEqual(d1.adjusting(year: 2020, month: 12, day: 31, in: .current)?.timestampForRequest(), "2020-12-31 13:14:15")
        XCTAssertEqual(d1.adjusting(hours: 0, minutes: 0, seconds: 0, in: .current)?.timestampForRequest(), "2012-12-20 00:00:00")
    }
    
    func testDateOnly() throws {
        let d = DateOnly(year: 2024, month: 2, day: 4)
        XCTAssertNotNil(d)
        XCTAssertEqual(d!.description, "2024-02-04")
        
        let d1 = d!.toDate(in: Self.nycTimeZone)
        let d2 = DateComponents(calendar: Calendar(in: Self.nycTimeZone), year: 2024, month: 2, day: 4).date
        XCTAssertNotNil(d1)
        XCTAssertNotNil(d2)
        
        XCTAssertEqual(d1!, d2!)
        XCTAssertEqual(d1!.timestampForRequest(in: Self.nycTimeZone), d2!.timestampForRequest(in: Self.nycTimeZone))
        
        var c2 = Calendar(identifier: .gregorian)
        c2.timeZone = Self.ldnTimeZone
        let d3 = DateComponents(calendar: c2, year: 2024, month: 2, day: 4).date
        XCTAssertNotNil(d3)
        XCTAssertEqual(d!.toDate(in: Self.ldnTimeZone), d3!)
        print(d!.toDate(in: Self.nycTimeZone)!)
        print(d!.toDate(in: Self.ldnTimeZone)!)
        
        XCTAssertNil(DateOnly(year: 2024, month: 2, day: 30))
        XCTAssertNotNil(DateOnly(year: 2020, month: 2, day: 29))
        XCTAssertNotNil(DateOnly(year: 2024, month: 3, day: 31))
        XCTAssertNotNil(DateOnly(year: 2024, month: 4, day: 30))
        XCTAssertNotNil(DateOnly(year: 2024, month: 7, day: 31))
        XCTAssertNil(DateOnly(year: 2024, month: 9, day: 31))
    }
    
    func testDateTimeOnly() throws {
        
        XCTAssertNotNil(DateOnly(from: .now))
        XCTAssertNotNil(TimeOnly(from: .now))
        
        XCTAssertEqual(DateOnly(from: .now)?.description, Date.now.timestampForDepartures())
        XCTAssertEqual(TimeOnly(from: .now)?.description, Date.now.timeForRequest())
        
        XCTAssertEqual(DateOnly(from: .now)?.toDate(in: .current)?.timestampForDepartures(), Date.now.timestampForDepartures())
        XCTAssertEqual(TimeOnly(from: .now)?.toDate(at: .now, in: .current)?.timestampForRequest(), Date.now.timestampForRequest())
    }
}
