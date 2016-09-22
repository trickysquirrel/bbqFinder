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
    var providedAreaDataModels = [[AreaDataModel]]()


    override init() {
        
        testCase = XCTestCase()
        super.init()
    }


    func showRootViewController() {

        let expectation = testCase.expectation(description: "waiting for presenter response")

        let dataSource = TableViewDataSource<AreasViewController>()
        let spyAreasViewController = SpyAreasViewController(dataSource: dataSource)

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

            areas = section.map { ACTAreas(title:$0.viewModel.title,
                                           subtitle:$0.viewModel.subtitle) }
        }
        return areas
    }

    // MARK: Helpers

    private func createRouterAndShowRootViewController(spyAreasViewController: SpyAreasViewController) {

        let window = UIWindow()
        let wireframe = Wireframe()

        let spyViewControllerFactory = SpyViewControllerFactory(spyAreasViewController: spyAreasViewController)

        let router = Router(window: window, viewControllerFactory: spyViewControllerFactory, navigationController: UINavigationController(), wireframe: wireframe)

        router.showRootViewController()
    }


}
