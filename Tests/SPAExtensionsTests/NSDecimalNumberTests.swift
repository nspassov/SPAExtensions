import XCTest
@testable import SPAExtensions

fileprivate extension Locale {
    static let us = Locale(identifier: "en_US")
    static let bg = Locale(identifier: "bg_BG")
}

final class NSDecimalNumberTests: XCTestCase {
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    func test1() throws {
        let n1 = NSDecimalNumber.from(string: ",0", locale: .bg)
        
        XCTAssertNotNil(n1)
        XCTAssertEqual(n1?.toString(locale: .bg), "0,00")
        
        
        let n2 = NSDecimalNumber.from(string: ".0", locale: .us)
        
        XCTAssertNotNil(n2)
        XCTAssertEqual(n2?.toString(locale: .us), "0.00")
    }
    
    func test2() throws {
        let n1 = NSDecimalNumber.from(string: ",", locale: .bg)
        
        XCTAssertNotNil(n1)
        XCTAssertEqual(n1?.toString(locale: .bg), "0,00")
        
        
        let n2 = NSDecimalNumber.from(string: ".", locale: .us)
        
        XCTAssertNotNil(n2)
        XCTAssertEqual(n2?.toString(locale: .us), "0.00")
    }
    
    func test3() throws {
        let n1 = NSDecimalNumber.from(string: "-1,2345", locale: .bg)
        
        XCTAssertNotNil(n1)
        XCTAssertEqual(n1?.toString(locale: .bg), "-1,23")
        
        
        let n2 = NSDecimalNumber.from(string: "-1.2345", locale: .us)
        
        XCTAssertNotNil(n2)
        XCTAssertEqual(n2?.toString(locale: .us), "-1.23")
    }
}
