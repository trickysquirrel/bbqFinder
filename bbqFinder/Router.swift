//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import Foundation
import MapKit


typealias AreaSelectionAction = (_ area:BBQArea) -> Void
typealias BBQSelectionAction = (_ coordinate:CLLocationCoordinate2D, _ facilities:String) -> Void


struct Router {

    let window: UIWindow
    let viewControllerFactory: ViewControllerFactory
    let navigationController: UINavigationController
    let wireframe: Wireframe



    func showRootViewController() {

        let action: AreaSelectionAction = { area in self.showAreaMapViewController(area) }

        let controller = viewControllerFactory.makeAreasViewController()
        wireframe.wireUpAreasViewController(controller: controller, action: action)

        navigationController.setViewControllers([controller], animated: false)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }


    fileprivate func showAreaMapViewController(_ area: BBQArea) {

        let action: BBQSelectionAction = { coordinate, facilities in self.showBBQDetailsViewController(coordinate, facilities: facilities) }

        let controller = viewControllerFactory.makeBbqMapArea(area, action: action)

        navigationController.pushViewController(controller, animated: true)
    }


    fileprivate func showBBQDetailsViewController(_ coordinate: CLLocationCoordinate2D, facilities: String) {

        let controller = viewControllerFactory.makeBbqDetails(coordinate, facilities: facilities)
        
        navigationController.pushViewController(controller, animated: true)
    }

}
