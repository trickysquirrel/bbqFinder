//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

protocol AnalyticsTracker {
    func trackScreenAppearance()
}


final class AreaTracker: AnalyticsTracker {

    private let screenApperanceAction: AnalyticsScreenAppearanceAction
    private let screenName: String


    required init(name: String, screenApperanceAction: @escaping AnalyticsScreenAppearanceAction) {
        self.screenName = name
        self.screenApperanceAction = screenApperanceAction
    }


    func trackScreenAppearance() {
        screenApperanceAction(screenName)
    }
    
}
