//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation



protocol ABConfiguration {
    
    func isFlagForDetailsPopeverOn() -> Bool
}


protocol AppleRouterActionFactory {

    func makeRouterDirectionAction() -> RouterDirectionAction
    func makeRouterShareBBQAction() -> RouterShareBBQAction
}


protocol ModuleFactory {

    func makeAreasModuleAndReturnViewController(showMapAction: @escaping RouterAreaSelectionAction) -> AreasViewController

    func makeMapModuleAndReturnViewController(bbqArea: BBQArea, showDetailsAction: @escaping RouterBBQSelectionAction) -> BBQMapViewController

    func makeDetailsModuleAndReturnViewController(coordinate: CLLocationCoordinate2D, title: String, facilities: String, address: String, directionsAction: @escaping RouterDirectionAction, sharingAction: @escaping RouterShareBBQAction) -> BBQDetailsTableViewController
}


typealias RouterAreaSelectionAction = (_ area:BBQArea) -> Void

typealias RouterBBQSelectionAction = (_ coordinate:CLLocationCoordinate2D, _ title: String, _ facilities:String, _ address:String) -> Void


struct BBQAppRouter {

    private let window: UIWindow
    private let navigationController: UINavigationController
    private let moduleFactory: BBQModuleFactory
    private let appleRouterActionFactory: AppleRouterActionFactory
    private let abConfiguration: ABConfiguration

    init(window: UIWindow,
         navigationController: UINavigationController,
         moduleFactory: BBQModuleFactory,
         appleRouterActionFactory: AppleRouterActionFactory,
         abConfiguration: ABConfiguration) {

        self.window = window
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
        self.appleRouterActionFactory = appleRouterActionFactory
        self.abConfiguration = abConfiguration
    }


    func showRootViewController() {

        let controller = moduleFactory.makeAreasModuleAndReturnViewController(showMapAction: showAreaMapViewController)

        navigationController.setViewControllers([controller], animated: false)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }


    fileprivate func showAreaMapViewController(area: BBQArea) {

        let controller = moduleFactory.makeMapModuleAndReturnViewController(bbqArea: area, showDetailsAction: showBBQDetailsViewController)

        navigationController.pushViewController(controller, animated: true)
    }


    fileprivate func showBBQDetailsViewController(coordinate: CLLocationCoordinate2D, title: String, facilities: String, address: String) {

        let directionsAction = appleRouterActionFactory.makeRouterDirectionAction()
        let sharingAction = appleRouterActionFactory.makeRouterShareBBQAction()

        if abConfiguration.isFlagForDetailsPopeverOn() {

            let controller = moduleFactory.makeDetailsPopoverModuleAndReturnViewController()

            controller.modalPresentationStyle = .popover
            if let presentingViewController = navigationController.viewControllers.last {
                presentingViewController.present(controller, animated: true, completion: nil)
            }
        }
        else {

            let controller = moduleFactory.makeDetailsModuleAndReturnViewController(coordinate: coordinate, title: title, facilities: facilities, address: address, directionsAction: directionsAction, sharingAction: sharingAction)
            
            navigationController.pushViewController(controller, animated: true)
        }
    }
}


