//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
@testable import bbqFinder


class SpyViewControllerFactory: ViewControllerFactory {

    fileprivate let spyAreasViewController: SpyAreasViewController


    init(spyAreasViewController: SpyAreasViewController) {
        self.spyAreasViewController = spyAreasViewController
    }


    func makeAreasViewController(dataSource: TableViewDataSource<AreasViewController>) -> AreasViewController {
        return spyAreasViewController
    }

    // not ready to use yet
    func makeBbqMapArea() -> BBQMapViewController {
        print("makeBbqMapArea not ready to use")
        return UIViewController() as! BBQMapViewController
    }

    func makeBbqDetails() -> BBQDetailsTableViewController {
        print("makeBbqDetails not ready to use")
        return UIViewController() as! BBQDetailsTableViewController
    }

    func makeBbqDetailsPopover() -> BBQDetailsPopoverViewController {
        print("makeBbqDetailsPopover not ready to use")
        return UIViewController() as! BBQDetailsPopoverViewController
    }

}

