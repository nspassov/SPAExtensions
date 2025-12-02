import XCTest
@testable import SPAExtensions

final class ColorTests: XCTestCase {
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    func test1() throws {
        XCTAssertEqual(UIColor(from: 0xff0000), UIColor.red)
        XCTAssertEqual(UIColor(from: 0x00ff00), UIColor.green)
        XCTAssertEqual(UIColor(from: 0x0000ff), UIColor.blue)
    }
    
    func test2() throws {
        XCTAssertEqual(UIColor(from: "#ff0000"), UIColor.red)
        XCTAssertEqual(UIColor(from: "#00ff00"), UIColor.green)
        XCTAssertEqual(UIColor(from: "#0000ff"), UIColor.blue)
    }
    
    func test3() throws {
        XCTAssertEqual(UIColor(from: "ff0000"), UIColor.red)
        XCTAssertEqual(UIColor(from: "00ff00"), UIColor.green)
        XCTAssertEqual(UIColor(from: "0000ff"), UIColor.blue)
    }
}
