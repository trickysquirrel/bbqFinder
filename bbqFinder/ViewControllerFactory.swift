//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import Foundation


extension UIStoryboard {

    func instantiateViewControllerWithIdentifier(identifier: ViewControllersIDs) -> UIViewController {
        return self.instantiateViewControllerWithIdentifier(identifier.rawValue)
    }
}


enum ViewControllersIDs : String {
    case areas = "AreasViewControllerStoryboardID"
    case bbqMap = "BBQMapViewControllerID"
}


typealias AreaSelectionAction = (area:BBQArea) -> Void


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


    func makeBbqMapArea(area: BBQArea) -> BBQMapViewController {

        let controller = (storyboard?.instantiateViewControllerWithIdentifier(.bbqMap)) as! BBQMapViewController

        let locationManager = UserLocationStatus()

        let alerter = Alerter()

        let presenter = BBQMapPresenter(output: controller)

        let bbqListProvider = BBQListProvider(area: area)

        let interactor = BBQMapInteractor(output: presenter, bbqListProvider: bbqListProvider, locationManagerStatus: locationManager)

        controller.title = area.title()
        controller.interactor = interactor
        controller.alerter = alerter

        return controller
    }
}
