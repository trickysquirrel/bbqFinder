
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


class ViewControllerFactory: NSObject {

    fileprivate var storyboard: UIStoryboard?

    
    override init() {
        super.init()
        self.storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    }

    
    func makeAreasViewController(dataSource: TableViewDataSource<AreasViewController>) -> AreasViewController {

        return AreasViewController(dataSource: dataSource)
    }


    func makeBbqMapArea() -> BBQMapViewController {

        let alerter = Alerter()
        return BBQMapViewController(alerter: alerter)
    }


    func makeBbqDetails() -> BBQDetailsTableViewController {

        return storyboard?.instantiateViewControllerWithIdentifier(.bbqDetails) as! BBQDetailsTableViewController
    }


}
