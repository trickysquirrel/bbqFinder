
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

// change the first 2 into xib to see what the advantage of testing is?
enum ViewControllersIDs : String {
//    case areas = "AreasViewControllerStoryboardID"
//    case bbqMap = "BBQMapViewControllerID"
    case bbqDetails = "BBQDetailsViewControllerStoryboardID"
}


protocol ViewControllerFactoryProtocol {

    func makeAreasViewController(dataSource: TableViewDataSource<AreasViewController>) -> AreasViewController
    func makeBbqMapArea() -> BBQMapViewController
    func makeBbqDetails() -> BBQDetailsTableViewController
}


class ViewControllerFactory: ViewControllerFactoryProtocol {

    private var storyboard: UIStoryboard?
    private var analyticsTrackerFactory: AnalyticsTrackerFactoryProtocol

    
    required init(analyticsTrackerFactory: AnalyticsTrackerFactoryProtocol) {
        self.analyticsTrackerFactory = analyticsTrackerFactory
        self.storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    }

    
    func makeAreasViewController(dataSource: TableViewDataSource<AreasViewController>) -> AreasViewController {

        let analyticsTracker = analyticsTrackerFactory.makeAreasTracker()
        return AreasViewController(dataSource: dataSource, analyticsTracker: analyticsTracker )
    }


    func makeBbqMapArea() -> BBQMapViewController {

        let alerter = Alerter()
        let analyticsTracker = analyticsTrackerFactory.makeMapTracker()
        return BBQMapViewController(alerter: alerter, analyticsTracker: analyticsTracker)
    }


    func makeBbqDetails() -> BBQDetailsTableViewController {

        let analytics = analyticsTrackerFactory.makeBBQDetailsTracker()
        let controller = storyboard?.instantiateViewControllerWithIdentifier(.bbqDetails) as! BBQDetailsTableViewController
        controller.analytics = analytics
        return controller
    }


}
