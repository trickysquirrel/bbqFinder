//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import Foundation

struct Router {

    let window: UIWindow
    let viewControllerFactory: ViewControllerFactory
    let navigationController: UINavigationController


    func showRootViewController() {

        let action: AreaSelectionAction = { area in self.showAreaMapViewController(area) }

        let controller = viewControllerFactory.makeAreasViewController(action: action)

        navigationController.setViewControllers([controller], animated: false)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }


    private func showAreaMapViewController(area: BBQArea) {

        let controller = viewControllerFactory.makeBbqMapArea(area)
        navigationController.pushViewController(controller, animated: true)
    }
}
