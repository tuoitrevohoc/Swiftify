//
//  StoreTests.swift
//  SwiftifyTests
//
//  Created by Tran Thien Khiem on 10/6/18.
//

import XCTest
import Swiftify

enum State: Equatable {
    case on
    case off
}

enum Action {
    case toggle
}

class StoreTests: XCTestCase {

    func testDispatch() {
        
        let expectation = XCTestExpectation()
        
        let store = Store<State, Action>(initialState: .on) { state, action in
            var newState = state
            switch state {
            case .on:
               newState = .off
            case .off:
                newState = .on
            }
            
            return newState
        }
        
        store.subscribe(as: self) { newState in
            XCTAssertEqual(.off, newState)
            expectation.fulfill()
        }
        
        store.dispatch(action: .toggle)
        wait(for: [expectation], timeout: 1.0)
        
        store.unsubscribe(as: self)
    }

}
