//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import XCTest
@testable import bbqFinder


struct ACTAreas {
    let title: String
}


class AreasAcceptanceTestsHelper: NSObject {

    let testCase: XCTestCase
    let window: UIWindow
    let wireframe: Wireframe
    var spyAreasViewController: AreasViewController?

    var providedAreaDataModels = [[AreaDataModel]]()

    override init() {

        testCase = XCTestCase()
        window = UIWindow()
        wireframe = Wireframe()
        super.init()
        spyAreasViewController = makeSpyAreasViewController()
    }


    func showRootViewController() {

        let expectation = testCase.expectation(description: "waiting for presenter response")

//        spyAreasViewController?.didReceivePresenterUpdate = { areas in
//            self.providedAreaDataModels = areas
//            expectation.fulfill()
//        }

        let spyViewControllerFactory = SpyViewControllerFactory(spyAreasViewController: spyAreasViewController!)

        let router = Router(window: window, viewControllerFactory: spyViewControllerFactory, navigationController: UINavigationController(), wireframe: wireframe)
        router.showRootViewController()

        testCase.waitForExpectations(timeout: 1.0, handler: nil)
    }


    func numberOfAreaSections() -> Int {
        return providedAreaDataModels.count
    }


    func areasInSection(section: Int) -> [ACTAreas] {

        var areas = [ACTAreas]()

        if let section = providedAreaDataModels[safe: section] {
            areas = section.map { _ in ACTAreas(title:"bob") }
        }
        return areas
    }

    // MARK: Helpers

    private func makeSpyAreasViewController() -> AreasViewController {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(.areas) as! AreasViewController
        

        return controller
        //object_setClass(controller, SpyAreasViewController.self)
        //return (controller as? SpyAreasViewController)!
    }
    

}
