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

        let action: AreaSelectionAction = { title in self.showAreaMapViewController(title) }

        let controller = viewControllerFactory.makeAreasViewController(action: action)

        navigationController.setViewControllers([controller], animated: false)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }


    private func showAreaMapViewController(areaTitle: String) {

        let controller = viewControllerFactory.makeBbqSelectedArea()
        controller.title = areaTitle
        navigationController.pushViewController(controller, animated: true)
    }
}
