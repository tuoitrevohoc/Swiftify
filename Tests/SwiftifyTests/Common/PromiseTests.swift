//
//  PromiseTests.swift
//  SwiftifyTests
//
//  Created by Tran Thien Khiem on 9/6/18.
//

import XCTest
import Swiftify

class PromiseTests: XCTestCase {
    
    enum TestError: Error {
        case executeError
    }

    /// Test execution of a promise
    func testExecution() {
        let expectation = XCTestExpectation(description: "Expect promise to be execute")
        
        let promise = Promise<String>({ resolve, reject in
            resolve("Hello World!")
        })
        .then({ result in
            XCTAssertEqual("Hello World!", result)
            expectation.fulfill()
        })
        
        promise.execute();
        wait(for: [expectation], timeout: 1.0)
    }
    
    /// Test execution of a promise
    func testExecution_Error() {
        let expectation = XCTestExpectation(description: "Expect promise to be execute")
        
        let promise = Promise<String>({ resolve, reject in
            reject(TestError.executeError)
        })
        .onError({ error in
            expectation.fulfill()
        })
        
        promise.execute();
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testExecution_ChainPromise() {
        let expectation = XCTestExpectation(description: "Expect promise to be execute")
        
        let promise = Promise<String>({ resolve, reject in
            resolve("Hello ")
        }).then({ result in
            return Promise<Int>({ resolve, reject in
                resolve(15)
            })
        }).then({ result in
            XCTAssertEqual(15, result)
            expectation.fulfill()
        })
        
        promise.execute()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testExecution_ChainPromiseWithError() {
        let expectation = XCTestExpectation(description: "Expect promise to be execute")
        
        let promise = Promise<String>({ resolve, reject in
            resolve("Hello ")
        }).then({ result in
            return Promise<Int>({ resolve, reject in
                reject(TestError.executeError)
            })
        }).onError({ error in
            expectation.fulfill()
        })
        
        promise.execute()
        wait(for: [expectation], timeout: 1.0)
    }

}
