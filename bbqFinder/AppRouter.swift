//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation



typealias RouterAreaSelectionAction = (_ area:BBQArea) -> Void

typealias RouterBBQSelectionAction = (_ coordinate:CLLocationCoordinate2D, _ title: String, _ facilities:String, _ address:String) -> Void


struct AppRouter {

    let window: UIWindow
    let viewControllerFactory: ViewControllerFactory
    let navigationController: UINavigationController
    let wireframe: Wireframe
    let appleRouter: AppleRouter


    func showRootViewController() {

        let action = makeRouterAreaSelectionAction()
        let dataSource = TableViewDataSource<AreasViewController>()
        let controller = viewControllerFactory.makeAreasViewController(dataSource: dataSource)
        
        wireframe.wireUpAreasViewController(controller: controller, action: action)

        navigationController.setViewControllers([controller], animated: false)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }


    fileprivate func showAreaMapViewController(_ area: BBQArea) {

        let action = makeRouterBBQSelectionAction()

        let controller = viewControllerFactory.makeBbqMapArea()

        wireframe.wireUpBbqMapViewController(controller: controller, bbqArea: area, action: action)

        navigationController.pushViewController(controller, animated: true)
    }


    fileprivate func showBBQDetailsViewController(_ coordinate: CLLocationCoordinate2D, title: String, facilities: String, address: String) {

        let directionsAction = appleRouter.makeRouterDirectionAction()
        let sharingAction = appleRouter.makeRouterShareBBQAction()

        let controller = viewControllerFactory.makeBbqDetails()

        wireframe.wireUpBbqDetailsViewController(controller: controller, coordinate: coordinate, title: title, facilities: facilities, address: address, directionsAction: directionsAction, sharingAction: sharingAction)
        
        navigationController.pushViewController(controller, animated: true)
    }
}


// candidate for factory
extension AppRouter {

    fileprivate func makeRouterAreaSelectionAction() -> RouterAreaSelectionAction {

        let action: RouterAreaSelectionAction = { area in self.showAreaMapViewController(area) }
        return action
    }


    fileprivate func makeRouterBBQSelectionAction() -> RouterBBQSelectionAction {

        let action: RouterBBQSelectionAction = { coordinate, title, facilities, address in self.showBBQDetailsViewController(coordinate, title: title, facilities: facilities, address: address) }
        return action
    }

}


