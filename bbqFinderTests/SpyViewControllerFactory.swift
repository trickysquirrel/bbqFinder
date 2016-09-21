//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
@testable import bbqFinder


class SpyViewControllerFactory: ViewControllerFactory {

    fileprivate let spyAreasViewController: AreasViewController

    init(spyAreasViewController: AreasViewController) {
        self.spyAreasViewController = spyAreasViewController
    }

    override func makeAreasViewController() -> AreasViewController {
        return spyAreasViewController
    }
}

