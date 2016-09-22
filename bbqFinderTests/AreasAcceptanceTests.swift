//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import XCTest
@testable import bbqFinder


class AreasAcceptanceTests: XCTestCase {

    let app = AreasAcceptanceTestsHelper()
    

    func test_onShowingRootViewController_oneSectionShownWithFiveAreas() {

        app.showRootViewController()

        let sections = app.numberOfAreaSections()
        let areasInFirstSection = app.areasInSection(section: 0)

        XCTAssertEqual(sections, 1)
        XCTAssertEqual(areasInFirstSection.count, 4)
    }

    
    func test_onShowingRootViewController_firstSectionShowsAreasInCorrectOrder() {

        app.showRootViewController()

        let areasInFirstSection = app.areasInSection(section: 0)

        XCTAssertEqual(areasInFirstSection[0].title, "Ballarat")
        XCTAssertEqual(areasInFirstSection[0].subtitle, "Victoria")

        XCTAssertEqual(areasInFirstSection[1].title, "Bright")
        XCTAssertEqual(areasInFirstSection[1].subtitle, "Victoria")

        XCTAssertEqual(areasInFirstSection[2].title, "Melbourne")
        XCTAssertEqual(areasInFirstSection[2].subtitle, "Victoria")

        XCTAssertEqual(areasInFirstSection[3].title, "Glenorchy")
        XCTAssertEqual(areasInFirstSection[3].subtitle, "Tasmania")
    }

}
