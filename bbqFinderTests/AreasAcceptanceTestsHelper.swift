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
        let spyAreasViewController = SpyAreasViewController(tableViewDataSource: dataSource, analyticsTracker: stubAnalyticsTracker, addBbqAction: {})

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

        let spyViewControllerFactory = SpyViewControllerFactory(spyAreasViewController: spyAreasViewController)

        let fakePersistentStorage = FakePersistenStorage()
        let bbqStorage = BBQPersistentStorage(persistentStorage: fakePersistentStorage)

        let moduleFactory = BBQModuleFactory(viewControllerFactory: spyViewControllerFactory, bbqStorage: bbqStorage)
        let appleMaps = AppleMapsAppDirection()
        let appleRouter = BBQAppleRouterActionFactory(appleMapsApp: appleMaps)
        let stubABConfig = StubABConfiguration()


        let navigationController = UINavigationController()

        let router = BBQAppRouter(window: window,
                                  navigationController: navigationController,
                                  moduleFactory: moduleFactory,
                                  appleRouterActionFactory: appleRouter,
                                  abConfiguration: stubABConfig)

        router.showRootViewController()

        navigationController.beginAppearanceTransition(true, animated: false)
        spyAreasViewController.beginAppearanceTransition(true, animated: false)
    }


}
