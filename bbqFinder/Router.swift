//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import Foundation
import MapKit


typealias AreaSelectionAction = (_ area:BBQArea) -> Void
typealias BBQSelectionAction = (_ coordinate:CLLocationCoordinate2D, _ title: String, _ facilities:String, _ address:String) -> Void


struct Router {

    let window: UIWindow
    let viewControllerFactory: ViewControllerFactory
    let navigationController: UINavigationController
    let wireframe: Wireframe



    func showRootViewController() {

        let action: AreaSelectionAction = { area in self.showAreaMapViewController(area) }

        let dataSource = TableViewDataSource<AreasViewController>()
        let controller = viewControllerFactory.makeAreasViewController(dataSource: dataSource)
        
        wireframe.wireUpAreasViewController(controller: controller, action: action)

        navigationController.setViewControllers([controller], animated: false)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }


    fileprivate func showAreaMapViewController(_ area: BBQArea) {

        let action: BBQSelectionAction = { coordinate, title, facilities, address in self.showBBQDetailsViewController(coordinate, title: title, facilities: facilities, address: address) }

        let alerter = Alerter()

        let controller = viewControllerFactory.makeBbqMapArea(alerter: alerter)

        wireframe.wireUpBbqMapViewController(controller: controller, bbqArea: area, action: action)

        navigationController.pushViewController(controller, animated: true)
    }


    fileprivate func showBBQDetailsViewController(_ coordinate: CLLocationCoordinate2D, title: String, facilities: String, address: String) {

        let controller = viewControllerFactory.makeBbqDetails(coordinate, title: title, facilities: facilities, address: address)
        
        navigationController.pushViewController(controller, animated: true)
    }

}
