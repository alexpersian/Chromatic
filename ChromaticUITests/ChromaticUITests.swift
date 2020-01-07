//
//  ChromaticUITests.swift
//  ChromaticUITests
//
//  Created by Alex Persian on 9/13/15.
//  Copyright © 2015 alexpersian. All rights reserved.
//

import XCTest

class ChromaticUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        setupSnapshot(app)
        app.launch()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testExample() {
        snapshot("01MainScreen")
        app.buttons["Gear"].tap()
        snapshot("02SettingsPage")
        app.scrollViews.otherElements.buttons["  Cupertino"].tap()
        app.keys["L"].tap()
        app.keys["o"].tap()
        app.keys["n"].tap()
        snapshot("03GoogleSearch")
    }
}
