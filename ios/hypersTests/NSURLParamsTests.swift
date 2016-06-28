//
//  hypersTests.swift
//  hypersTests
//
//  Created by Matthew Wo on 6/28/16.
//  Copyright © 2016 hypers. All rights reserved.
//

import XCTest

class NSURLParamsTests: XCTestCase {
    var subject = NSURL()

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func setupSubject(singular singular: Bool) {
        if singular {
            subject = NSURL(string: "https://localhost:1234/ccc?key1=a")!
        } else {
            subject = NSURL(string: "https://localhost:1234/ccc?key1=a&key2=b")!
        }
    }

    func testSingularParamWithValidKey() {
        self.setupSubject(singular: true)
        XCTAssert(subject.params["key1"] == "a", "Got \(subject.params["key1"]) but expecting a")
    }

    func testSingularParamWithInvalidKey() {
        self.setupSubject(singular: true)
        XCTAssertNil(subject.params["invalid_key"], "Got \(subject.params["invalid_key"]) but expecting nil")
    }

    func testMultipleParamsWithValidKey() {
        self.setupSubject(singular: false)
        XCTAssert(subject.params["key2"] == "b", "Got \(subject.params["key2"]) but expecting b")
    }

    func testMultipleParamsWithInvalidKey() {
        self.setupSubject(singular: false)
        XCTAssertNil(subject.params["invalid_key"], "Got \(subject.params["invalid_key"]) but expecting nil")
    }

    func testInvalidURL() {
        let cases = ["http:/invalidURL", "http", "://?&", "://", "invalid.com?&"]
        for currentCase in cases {
            let currentCase = NSURL(string: currentCase)
            print("=== Testing case: \(currentCase) ===")
            if let result = currentCase?.params {
                XCTAssert(result.isEmpty, "\(currentCase) yields non-nil dict: \(result)")
            }
        }
    }
}
