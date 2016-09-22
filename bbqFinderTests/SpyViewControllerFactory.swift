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

    override func makeAreasViewController(dataSource: TableViewDataSource<AreasViewController>) -> AreasViewController {
        return spyAreasViewController
    }
}

