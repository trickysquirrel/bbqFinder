//
//  BBQFinderUITests.swift
//  BBQFinderUITests
//
//  Created by Richard Moult on 30/10/2016.
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import XCTest

class BBQFinderUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        continueAfterFailure = false
        setupSnapshot(app)
        app.launch()
    }


    override func tearDown() {
        super.tearDown()
    }


    func test_snapShots() {

        // root view snapshot
        snapshot("0Launch")

        // user add bbq snapshot
        app.navigationBars["BBQ Areas"].buttons["Add"].tap()
        sleep(5)
        snapshot("1AddBBqMap")

        // backup to root view
        app.alerts["Add your own BBQ's"].buttons["OK"].tap()
        app.navigationBars["Added BBQs"].buttons["BBQ Areas"].tap()

        // select canberra
        app.tables.staticTexts["ACT"].tap()

        // select pin
        app.otherElements.containing(.navigationBar, identifier:"Canberra").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).matching(identifier: "GOOGONG").element(boundBy: 0).tap()

        sleep(20)
        snapshot("3MapWithSelectedPin")

        // showing details for pin
        app.buttons["More Info"].tap()
        sleep(10)
        snapshot("4Details")
    }

    
}
