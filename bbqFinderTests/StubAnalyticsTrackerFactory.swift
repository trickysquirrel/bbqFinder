//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
@testable import bbqFinder


class StubAnalyticsTrackerFactory: AnalyticsTrackerFactoryProtocol {

    func makeAreasTracker() -> AreasTracker {
        return AreasTracker(screenApperanceAction: trackScreenAppearance)
    }

    func makeMapTracker() -> MapAnalyticsTracker {
        return MapAnalyticsTracker(screenApperanceAction: trackScreenAppearance, eventAction: trackEvent)
    }

    func makeBBQDetailsTracker() -> BBQDetailsAnalyticsTracker {
        return BBQDetailsAnalyticsTracker(screenApperanceAction: trackScreenAppearance, eventAction: trackEvent)
    }

    fileprivate func trackScreenAppearance(screenName: String) {}
    fileprivate func trackEvent(category: String, action: String, label: String) {}
}
