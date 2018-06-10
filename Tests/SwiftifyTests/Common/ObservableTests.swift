//
//  ObservableTests.swift
//  SwiftifyTests
//
//  Created by Tran Thien Khiem on 10/6/18.
//

import XCTest
import Swiftify

class ObservableTests: XCTestCase {

    func testSubscribe() {
        let expectation = XCTestExpectation()
        var count = 0
        let observable = Observable<Int>()
        observable.subscribe(as: self) { data in
            count += data
            expectation.fulfill()
        }
        
        observable.next(15)
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(15, count)
    }
    
    func testUnsubscribe() {
        var count = 0
        let observable = Observable<Int>()
        observable.subscribe(as: self) { data in
            count += data
        }
        
        observable.unsubscribe(as: self)
        observable.next(15)
        XCTAssertEqual(0, count)
    }

}
