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

    
    func makeAreasViewController(dataSource: TableViewDataSource<AreasViewController>) -> AreasViewController {

        return AreasViewController(dataSource: dataSource)
    }


    func makeBbqMapArea(alerter: Alerter) -> BBQMapViewController {

        return BBQMapViewController(alerter: alerter)
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


}
