//
//  StringAttributesTests.swift
//  hypers
//
//  Created by Matthew Wo on 6/28/16.
//  Copyright © 2016 hypers. All rights reserved.
//

import XCTest

class StringAttributesTests: XCTestCase {
    var subject = String()

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func setupSubject(singular singular: Bool) {
        if singular {
            subject = "https://localhost:1234/ccc?key1=a"
        } else {
            subject = "https://localhost:1234/ccc?key1=a&key2=b"
        }
    }

    func testSingularParamWithValidKey() {
        self.setupSubject(singular: true)
        let result = subject.urlAPIComponents!["key1"]
        XCTAssert(result == "a", "Got \(result) but expecting a")
    }

    func testSingularParamWithInvalidKey() {
        self.setupSubject(singular: true)
        let result = subject.urlAPIComponents!["invalid_key"]
        XCTAssertNil(result, "Got \(result) but expecting nil")
    }

    func testMultipleParamsWithValidKey() {
        self.setupSubject(singular: false)
        let result = subject.urlAPIComponents!["key2"]
        XCTAssert(result == "b", "Got \(result) but expecting b")
    }

    func testMultipleParamsWithInvalidKey() {
        self.setupSubject(singular: false)
        let result = subject.urlAPIComponents!["invalid_key"]
        XCTAssertNil(result, "Got \(result) but expecting nil")
    }

    func testInvalidString() {
        let cases = ["http:/invalidURL", "http", "://?&", "://", "invalid.com?&"]
        for currentCase in cases {
            print("=== Testing case: \(currentCase) ===")
            let result = currentCase.urlAPIComponents
            XCTAssertNil(result, "\(currentCase) yields non-nil dict: \(result)")
        }
    }
}
