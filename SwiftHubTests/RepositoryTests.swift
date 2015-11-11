//
//  RepositoryTests.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 11/11/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import XCTest

class RepositoryTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRepositorySerializationIsLossless() {
        let original = Repository(name: "SwiftHub", owner: "Everybody", stars: 1000, description: "Hello, new and wonderful swift repositories", url: "http://www.github.com")
        let serialized = original.serialized
        do {
            let restored = try Repository(serialized: serialized)
            XCTAssertEqual(original, restored, "Repository serialization should be lossless")
        } catch {
            XCTFail("Failed to restore repository")
        }
    }
    
    func testRepositorySerializationDoesThrow() {
        let serialized = NSData()
        do {
            let _ = try Repository(serialized: serialized)
            XCTFail("Repository did not throw with bogus serialization data")
        } catch {
            
        }
    }

}
