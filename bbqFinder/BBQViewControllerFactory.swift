
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
    case bbqDetails = "BBQDetailsViewControllerStoryboardID"
    case bbqDetailsPopover = "BBQDetailsPopoverViewControllerId"
}



struct BBQViewControllerFactory: ViewControllerFactory {

    private var storyboard: UIStoryboard?
    private var analyticsTrackerFactory: AnalyticsTrackerFactoryProtocol
    
    init(analyticsTrackerFactory: AnalyticsTrackerFactoryProtocol) {
        self.analyticsTrackerFactory = analyticsTrackerFactory
        self.storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    }

    
    func makeAreasViewController(dataSource: TableViewDataSource<AreasViewController>, addBbqAction: @escaping RouterAddBbqAction) -> AreasViewController {

        let analyticsTracker = analyticsTrackerFactory.makeAreasTracker()
        return AreasViewController(tableViewDataSource: dataSource, analyticsTracker: analyticsTracker, addBbqAction: addBbqAction )
    }


    func makeBBQAddViewController() -> BBQAddViewController {

        let alerter = Alerter()
        let analytics = analyticsTrackerFactory.makeAddBBQMapTracker()
        return BBQAddViewController(alerter: alerter, analytics: analytics)
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


    func makeBbqDetailsPopover() -> BBQDetailsPopoverViewController {

        return storyboard?.instantiateViewControllerWithIdentifier(.bbqDetailsPopover) as! BBQDetailsPopoverViewController
    }

}
