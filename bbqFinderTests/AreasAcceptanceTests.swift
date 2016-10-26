//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import XCTest
@testable import bbqFinder


class AreasAcceptanceTests: XCTestCase {

    let app = AreasAcceptanceTestsHelper()

    // todo these test should involve the data source not view controller
    // add in extra test to make sure data source works correctly with view controller
    // add in test to make sure the views got given the correct viewModels

    func test_onShowingRootViewController_oneSectionShownWithFiveAreas() {

        app.showRootViewController()

        let sections = app.numberOfAreaSections()
        let areasInFirstSection = app.areasInSection(section: 0)

        XCTAssertEqual(sections, 1)
        XCTAssertEqual(areasInFirstSection.count, 7)
    }

    
    func test_onShowingRootViewController_firstSectionShowsAreasInCorrectOrder() {

        app.showRootViewController()

        let areasInFirstSection = app.areasInSection(section: 0)

        XCTAssertEqual(areasInFirstSection[0].title, "Canberra")
        XCTAssertEqual(areasInFirstSection[0].subtitle, "ACT")

        XCTAssertEqual(areasInFirstSection[1].title, "Noosa")
        XCTAssertEqual(areasInFirstSection[1].subtitle, "Queensland")

        XCTAssertEqual(areasInFirstSection[2].title, "Glenorchy")
        XCTAssertEqual(areasInFirstSection[2].subtitle, "Tasmania")

        XCTAssertEqual(areasInFirstSection[3].title, "Ballarat")
        XCTAssertEqual(areasInFirstSection[3].subtitle, "Victoria")

        XCTAssertEqual(areasInFirstSection[4].title, "Bright")
        XCTAssertEqual(areasInFirstSection[4].subtitle, "Victoria")

        XCTAssertEqual(areasInFirstSection[5].title, "Melbourne")
        XCTAssertEqual(areasInFirstSection[5].subtitle, "Victoria")

        XCTAssertEqual(areasInFirstSection[6].title, "Melbourne SE")
        XCTAssertEqual(areasInFirstSection[6].subtitle, "Victoria")

    }

}
