//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import XCTest
@testable import bbqFinder


struct ACTAreas {
    let title: String
    let subtitle: String
}


class AreasAcceptanceTestsHelper: NSObject {

    let testCase: XCTestCase
    var providedAreaDataModels = [[AreaViewModel]]()


    override init() {
        
        testCase = XCTestCase()
        super.init()
    }


    func showRootViewController() {

        let expectation = testCase.expectation(description: "waiting for presenter response")

        let stubAnalyticsTracker = StubAnalyticsTrackerFactory().makeAreasTracker()
        let dataSource = TableViewDataSource<AreasViewController>()
        let spyAreasViewController = SpyAreasViewController(dataSource: dataSource, analyticsTracker: stubAnalyticsTracker)

        spyAreasViewController.didReceivePresenterUpdate = { areas in
            self.providedAreaDataModels = areas
            expectation.fulfill()
        }

        createRouterAndShowRootViewController(spyAreasViewController: spyAreasViewController)

        testCase.waitForExpectations(timeout: 1.0, handler: nil)
    }


    func numberOfAreaSections() -> Int {
        return providedAreaDataModels.count
    }


    func areasInSection(section: Int) -> [ACTAreas] {

        var areas = [ACTAreas]()

        if let section = providedAreaDataModels[safe: section] {

            areas = section.map { ACTAreas(title:$0.title,
                                           subtitle:$0.subtitle) }
        }
        return areas
    }

    // MARK: Helpers

    private func createRouterAndShowRootViewController(spyAreasViewController: SpyAreasViewController) {

        let window = UIWindow()
        let wireframe = Wireframe()
        let appleMaps = AppleMapsAppDirection()
        let appleRouter = AppleRouter(appleMapsApp: appleMaps)

        let spyViewControllerFactory = SpyViewControllerFactory(spyAreasViewController: spyAreasViewController)

        let router = AppRouter(window: window,
                               viewControllerFactory: spyViewControllerFactory,
                               navigationController: UINavigationController(),
                               wireframe: wireframe,
                               appleRouter: appleRouter)

        router.showRootViewController()
    }


}
