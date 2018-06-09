import XCTest
@testable import Swiftify

final class SwiftifyTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Swiftify().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
