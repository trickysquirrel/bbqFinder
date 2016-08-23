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

        let controller = viewControllerFactory.makeAreasViewController()

        navigationController.setViewControllers([controller], animated: false)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
