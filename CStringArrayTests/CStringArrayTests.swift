//
//  CStringArrayTests.swift
//  CStringArrayTests
//
//  Created by hnw on 2016/06/25.
//  Copyright © 2016年 hnw. All rights reserved.
//

import XCTest
@testable import CStringArray

class CStringArrayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmptyList() {
        let arr = CStringArray([])
        XCTAssertEqual(arr.pointers.count, 0)
    }

    func testListElements() {
        let arr = CStringArray(["foo", nil])
        XCTAssertEqual(arr.pointers.count, 2)
        XCTAssertEqual(strcmp(arr.pointers[0], "foo"), 0)
        XCTAssert(arr.pointers[1] == nil)
    }

    func testPrintable() {
        let arr = CStringArray(["foo", nil])
        XCTAssertEqual(arr.description, "CStringArray([\"foo\", NULL])")

    }
}
