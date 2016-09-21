//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import Foundation
import MapKit


extension UIStoryboard {

    func instantiateViewControllerWithIdentifier(_ identifier: ViewControllersIDs) -> UIViewController {
        return self.instantiateViewController(withIdentifier: identifier.rawValue)
    }
}


enum ViewControllersIDs : String {
    case areas = "AreasViewControllerStoryboardID"
    case bbqMap = "BBQMapViewControllerID"
    case bbqDetails = "BBQDetailsViewControllerStoryboardID"
}


class ViewControllerFactory: NSObject {

    fileprivate var storyboard: UIStoryboard?
    fileprivate let appStyle: AppStyle

    
    override init() {
        self.appStyle = AppStyle()
        super.init()
        self.storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    }

    func makeAreasViewController() -> AreasViewController {

        let controller = storyboard?.instantiateViewControllerWithIdentifier(.areas) as! AreasViewController

        return controller
    }


    func makeBbqMapArea(_ area: BBQArea, action: @escaping BBQSelectionAction) -> BBQMapViewController {

        let controller = storyboard?.instantiateViewControllerWithIdentifier(.bbqMap) as! BBQMapViewController

        let alerter = Alerter()

        let presenter = BBQMapPresenter(output: controller, action: action)

        let bbqListProvider = BBQListProvider(area: area)

        let interactor = BBQMapInteractor(output: presenter, bbqListProvider: bbqListProvider)

        let userLocationInteractor = makeUserLocationInteractor(controller)

        controller.title = area.title()
        controller.interactor = interactor
        controller.userLocationInteractor = userLocationInteractor
        controller.alerter = alerter

        return controller
    }


    func makeBbqDetails(_ coordinate: CLLocationCoordinate2D, facilities: String) -> BBQDetailsTableViewController {

        let controller = storyboard?.instantiateViewControllerWithIdentifier(.bbqDetails) as! BBQDetailsTableViewController

        let appleMapsApp = AppleMapsAppDirection()
        let locationManager = UserLocationStatus()
        let requestUsersLocation = UserLocation(locationStatus: locationManager)
        let locationAddress = LocationAddress(locationStatus: locationManager)
        let alerter = Alerter()

        let presenter = BBQDetailsPresenter(output: controller, style: appStyle, appleMapsApp: appleMapsApp)
        
        let interactor = BBQDetailsInteractor(output: presenter, coordinate: coordinate, facilities: facilities, userLocation: requestUsersLocation, locationAddress: locationAddress)

        controller.interactor = interactor
        controller.alerter = alerter

        return controller
    }

    // MARK: private

    fileprivate func makeUserLocationInteractor(_ output: UserLocationPresenterOutput) -> UserLocationInteractor {

        let locationManager = UserLocationStatus()
        let userLocationPresenter = UserLocationPresenter(output: output)
        let userLocationInteractor = UserLocationInteractor(output: userLocationPresenter, locationManagerStatus: locationManager)
        return userLocationInteractor
    }

}
