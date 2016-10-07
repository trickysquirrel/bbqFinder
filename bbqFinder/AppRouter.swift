//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation


protocol ABConfiguration {
    func isFlagForDetailsPopeverOn() -> Bool
}


typealias RouterAreaSelectionAction = (_ area:BBQArea) -> Void

typealias RouterBBQSelectionAction = (_ coordinate:CLLocationCoordinate2D, _ title: String, _ facilities:String, _ address:String) -> Void


struct AppRouter {

    let window: UIWindow
    let viewControllerFactory: ViewControllerFactoryProtocol
    let navigationController: UINavigationController
    let wireframe: Wireframe
    let appleRouter: AppleRouter
    let abConfiguration: ABConfiguration


    func showRootViewController() {

        let dataSource = TableViewDataSource<AreasViewController>()
        let controller = viewControllerFactory.makeAreasViewController(dataSource: dataSource)
        
        wireframe.wireUpAreasViewController(controller: controller, action: showAreaMapViewController)

        navigationController.setViewControllers([controller], animated: false)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }


    fileprivate func showAreaMapViewController(area: BBQArea) {

        let controller = viewControllerFactory.makeBbqMapArea()

        wireframe.wireUpBbqMapViewController(controller: controller, bbqArea: area, action: showBBQDetailsViewController)

        navigationController.pushViewController(controller, animated: true)
    }


    fileprivate func showBBQDetailsViewController(coordinate: CLLocationCoordinate2D, title: String, facilities: String, address: String) {

        let directionsAction = appleRouter.makeRouterDirectionAction()
        let sharingAction = appleRouter.makeRouterShareBBQAction()

        if abConfiguration.isFlagForDetailsPopeverOn() {

            let controller = viewControllerFactory.makeBbqDetailsPopover()
            controller.modalPresentationStyle = .popover
            if let presentingViewController = navigationController.viewControllers.last {
                presentingViewController.present(controller, animated: true, completion: nil)
            }
        }
        else {

            let controller = viewControllerFactory.makeBbqDetails()

            wireframe.wireUpBbqDetailsViewController(controller: controller, coordinate: coordinate, title: title, facilities: facilities, address: address, directionsAction: directionsAction, sharingAction: sharingAction)
            
            navigationController.pushViewController(controller, animated: true)
        }
    }
}


