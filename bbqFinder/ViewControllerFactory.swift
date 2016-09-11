//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import Foundation
import MapKit


extension UIStoryboard {

    func instantiateViewControllerWithIdentifier(identifier: ViewControllersIDs) -> UIViewController {
        return self.instantiateViewControllerWithIdentifier(identifier.rawValue)
    }
}


enum ViewControllersIDs : String {
    case areas = "AreasViewControllerStoryboardID"
    case bbqMap = "BBQMapViewControllerID"
    case bbqDetails = "BBQDetailsViewControllerStoryboardID"
}


class ViewControllerFactory: NSObject {

    private let storyboard: UIStoryboard?

    
    override init() {
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
    }

    func makeAreasViewController(action action: AreaSelectionAction) -> AreasViewController {

        let controller = storyboard?.instantiateViewControllerWithIdentifier(.areas) as! AreasViewController

        controller.title = "Areas"
        controller.dataSource = TableViewDataSource()
        controller.dataSource.delegate = controller

        let presenter = AreasPresenter(interface: controller, action: action)

        let interactor = AreasInteractor(output: presenter)
        controller.interactor = interactor

        return controller
    }


    func makeBbqMapArea(area: BBQArea, action: BBQSelectionAction) -> BBQMapViewController {

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


    func makeBbqDetails(coordinate: CLLocationCoordinate2D) -> BBQDetailsTableViewController {

        let controller = storyboard?.instantiateViewControllerWithIdentifier(.bbqDetails) as! BBQDetailsTableViewController

        let locationManager = UserLocationStatus()
        let presenter = BBQDetailsPresenter(output: controller)
        let interactor = BBQDetailsInteractor(output: presenter, coordinate: coordinate, locationStatus: locationManager)
        controller.interactor = interactor

        return controller
    }

    // MARK: private

    private func makeUserLocationInteractor(output: UserLocationPresenterOutput) -> UserLocationInteractor {

        let locationManager = UserLocationStatus()
        let userLocationPresenter = UserLocationPresenter(output: output)
        let userLocationInteractor = UserLocationInteractor(output: userLocationPresenter, locationManagerStatus: locationManager)
        return userLocationInteractor
    }

}
