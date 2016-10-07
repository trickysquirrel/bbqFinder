//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import XCTest
@testable import bbqFinder


struct ACTAreas {
    let title: String
    let subtitle: String
}


class StubABConfiguration: ABConfiguration {

    func isFlagForDetailsPopeverOn() -> Bool {
        return false
    }
}



class AreasAcceptanceTestsHelper: NSObject {

    var providedAreaDataModels = [[AreaViewModel]]()


    func showRootViewController() {

        let stubAnalyticsTracker = StubAnalyticsTrackerFactory().makeAreasTracker()
        let dataSource = TableViewDataSource<AreasViewController>()
        let spyAreasViewController = SpyAreasViewController(dataSource: dataSource, analyticsTracker: stubAnalyticsTracker)

        spyAreasViewController.didReceivePresenterUpdate = { areas in
            self.providedAreaDataModels = areas
        }

        createRouterAndShowRootViewController(spyAreasViewController: spyAreasViewController)
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
        let stubABConfig = StubABConfiguration()

        let spyViewControllerFactory = SpyViewControllerFactory(spyAreasViewController: spyAreasViewController)

        let navigationController = UINavigationController()

        let router = AppRouter(window: window,
                               viewControllerFactory: spyViewControllerFactory,
                               navigationController: navigationController,
                               wireframe: wireframe,
                               appleRouter: appleRouter,
                               abConfiguration: stubABConfig)

        router.showRootViewController()

        navigationController.beginAppearanceTransition(true, animated: false)
        spyAreasViewController.beginAppearanceTransition(true, animated: false)
    }


}
