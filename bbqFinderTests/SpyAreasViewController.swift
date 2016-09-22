//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
@testable import bbqFinder


class SpyAreasViewController: AreasViewController {

    var didReceivePresenterUpdate: ((_ areas: [[AreaDataModel]]) -> Void)?

    override func presenterUpdate(_ response:AreasMapPresenterResponse) {

        super.presenterUpdate(response)

        switch response {
        case .updateAreas(let areas):
            didReceivePresenterUpdate?(areas)
            break
        }
    }
}
