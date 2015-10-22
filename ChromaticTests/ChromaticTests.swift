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

    let formatter = NSDateFormatter()
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

    func checkStringForDateWithOffset(offset: Int) {
        // given
        let date = NSDate()
        model.offset = offset
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: offset)
        let expected = formatter.stringFromDate(date)

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
}
