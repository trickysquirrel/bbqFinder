//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import CoreLocation


// todo: is this the correct name?

final class Wireframe: NSObject {

    private let appStyle: AppStyle


    override init() {
        self.appStyle = AppStyle()
    }


    func wireUpAreasViewController(controller: AreasViewController, action: @escaping RouterAreaSelectionAction) {

        controller.title = "Bbq Areas"

        let presenter = AreasPresenter(interface: controller, action: action)

        let interactor = AreasInteractor(output: presenter)
        controller.interactor = interactor

        let nibContents =  Bundle.main.loadNibNamed("AreasTableViewBackground", owner: nil, options: nil)
        if let view = nibContents?.first as? UIView {
            controller.tableView.backgroundView = view
        }
    }


    func wireUpBbqMapViewController(controller: BBQMapViewController, bbqArea: BBQArea, action: @escaping RouterBBQSelectionAction) {

        let locationStatus = UserLocationStatus()
        let requestUsersLocation = UserLocation(locationStatus: locationStatus)

        let presenter = BBQMapPresenter(output: controller, action: action)

        let bbqListProvider = BBQListProvider(area: bbqArea)

        let interactor = BBQMapInteractor(output: presenter, bbqListProvider: bbqListProvider, userLocation: requestUsersLocation)

        controller.title = bbqArea.title()
        controller.interactor = interactor
    }


    func wireUpBbqDetailsViewController(controller: BBQDetailsTableViewController, coordinate: CLLocationCoordinate2D, title: String, facilities: String, address: String, directionsAction: @escaping RouterDirectionAction, sharingAction: @escaping RouterShareBBQAction) {
        
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
    }


}
