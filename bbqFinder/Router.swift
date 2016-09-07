//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import Foundation
import MapKit


typealias AreaSelectionAction = (area:BBQArea) -> Void
typealias BBQSelectionAction = (coordinate:CLLocationCoordinate2D) -> Void


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

        let action: BBQSelectionAction = { coordinate in self.showBBQDetailsViewController() }

        let controller = viewControllerFactory.makeBbqMapArea(area, action: action)

        navigationController.pushViewController(controller, animated: true)
    }


    private func showBBQDetailsViewController() {

        let controller = viewControllerFactory.makeBbqDetails()
        
        navigationController.pushViewController(controller, animated: true)
    }

}
