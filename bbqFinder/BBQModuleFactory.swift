//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import CoreLocation


protocol ViewControllerFactory {
    func makeAreasViewController(dataSource: TableViewDataSource<AreasViewController>) -> AreasViewController
    func makeBbqMapArea() -> BBQMapViewController
    func makeBbqDetails() -> BBQDetailsTableViewController
    func makeBbqDetailsPopover() -> BBQDetailsPopoverViewController
}


struct BBQModuleFactory: ModuleFactory {

    private let appStyle = AppStyle()
    let viewControllerFactory: ViewControllerFactory


    func makeAreasModuleAndReturnViewController(showMapAction: @escaping RouterAreaSelectionAction) -> AreasViewController {

        let dataSource = TableViewDataSource<AreasViewController>()
        let controller = viewControllerFactory.makeAreasViewController(dataSource: dataSource)

        controller.title = "Bbq Areas"

        let presenter = AreasPresenter(interface: controller, action: showMapAction)

        let interactor = AreasInteractor(output: presenter)
        controller.interactor = interactor

        let nibContents =  Bundle.main.loadNibNamed("AreasTableViewBackground", owner: nil, options: nil)
        if let view = nibContents?.first as? UIView {
            controller.tableView.backgroundView = view
        }

        return controller
    }


    func makeMapModuleAndReturnViewController(bbqArea: BBQArea, showDetailsAction: @escaping RouterBBQSelectionAction) -> BBQMapViewController {

        let controller = viewControllerFactory.makeBbqMapArea()

        let locationStatus = UserLocationStatus()
        let requestUsersLocation = UserLocation(locationStatus: locationStatus)

        let presenter = BBQMapPresenter(output: controller, action: showDetailsAction)

        let bbqListProvider = BBQListProvider(area: bbqArea)

        let interactor = BBQMapInteractor(output: presenter, bbqListProvider: bbqListProvider, userLocation: requestUsersLocation)

        controller.title = bbqArea.title()
        controller.interactor = interactor

        return controller
    }


    func makeDetailsModuleAndReturnViewController(coordinate: CLLocationCoordinate2D, title: String, facilities: String, address: String, directionsAction: @escaping RouterDirectionAction, sharingAction: @escaping RouterShareBBQAction) -> BBQDetailsTableViewController {

        let controller = viewControllerFactory.makeBbqDetails()

        let locationDistance = LocationDistance()
        let locationStatus = UserLocationStatus()
        let requestUsersLocation = UserLocation(locationStatus: locationStatus)
        let locationAddress = LocationAddress(locationStatus: locationStatus)
        let alerter = Alerter()

        let presenter = BBQDetailsPresenter(output: controller, style: appStyle, directionsAction: directionsAction, sharingAction: sharingAction)

        let interactor = BBQDetailsInteractor(output: presenter,
                                              bbqTitle:title,
                                              bbqLatitude: coordinate.latitude,
                                              bbqLongitude: coordinate.longitude,
                                              facilities: facilities,
                                              address: address,
                                              userLocation: requestUsersLocation,
                                              locationAddress: locationAddress,
                                              locationDistance: locationDistance)

        controller.interactor = interactor
        controller.alerter = alerter

        return controller
    }


    func makeDetailsPopoverModuleAndReturnViewController() -> BBQDetailsPopoverViewController {
        return viewControllerFactory.makeBbqDetailsPopover()
    }
}
