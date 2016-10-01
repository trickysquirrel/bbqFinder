//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit


final class AreasTracker {

    private let screenApperanceAction: AnalyticsScreenAppearanceAction
    private let screenName = "Areas"


    required init(screenApperanceAction: @escaping AnalyticsScreenAppearanceAction) {
        self.screenApperanceAction = screenApperanceAction
    }


    func trackScreenAppearance() {
        screenApperanceAction(screenName)
    }
}
