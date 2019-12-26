//
//  ChromaticTests.swift
//  ChromaticTests
//
//  Created by Alex Persian on 9/13/15.
//  Copyright © 2015 alexpersian. All rights reserved.
//

import XCTest
@testable import Chromatic

class ChromaticTests: XCTestCase {

    let formatter = DateFormatter()
    let model = ColorModel()
    
    override func setUp() {
        super.setUp()

        // TODO: This should really be configurable on the model and not need to be hardcoded here.
        formatter.dateFormat = "HH : mm : ss"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func checkStringForDateWithOffset(_ offset: Int) {
        // given
        let date = Date()
        model.offset = offset
        formatter.timeZone = TimeZone(secondsFromGMT: offset)
        let expected = formatter.string(from: date)

        // when
        let result = model.stringForDate(date)

        // then
        XCTAssertEqual(result, expected)
    }

    func testStringForDate_shouldReturnAppropriatelyOffsetString() {
        checkStringForDateWithOffset(0)
        checkStringForDateWithOffset(-2000)
        checkStringForDateWithOffset(10)
        checkStringForDateWithOffset(25200)
        checkStringForDateWithOffset(-25200)
    }
    
    //TODO: Write a test for the date string -> hex string conversion
    func checkDateStringForHexStringEqual(_ dateString: String, _ expected: String) {
        // when
        let result = model.hexStringFromDateString(dateString)
        
        // then
        XCTAssertEqual(result, expected)
    }
    
    func checkDateStringForHexStringNotEqual(_ dateString: String, _ expected: String) {
        // when
        let result = model.hexStringFromDateString(dateString)
        
        // then
        XCTAssertNotEqual(result, expected)
    }
    
    func testDateStringForHexString_shouldReturnAppropriateHexString() {
        // given equal cases
        checkDateStringForHexStringEqual("08 : 10 : 54", "#08 : A0 : ED")
        checkDateStringForHexStringEqual("14 : 43 : 27", "#AD : DC : B7")
        checkDateStringForHexStringEqual("23 : 59 : 59", "#BC : E9 : E9")
        checkDateStringForHexStringEqual("01 : 01 : 01", "#0A : 0A : 0A")
        // given not-equal cases
        checkDateStringForHexStringNotEqual("08 : 10 : 54", "#0F : A0 : ED")
        checkDateStringForHexStringNotEqual("16 : 33 : 27", "#AD : DC : B7")
        checkDateStringForHexStringNotEqual("23 : 59 : 59", "#BC : E9 : A9")
        checkDateStringForHexStringNotEqual("01 : 01 : 01", "#1A : 0A : 0A")
    }
}
