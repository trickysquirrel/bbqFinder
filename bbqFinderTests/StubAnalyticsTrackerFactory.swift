//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
@testable import bbqFinder


class StubAnalyticsTrackerFactory: AnalyticsTrackerFactoryProtocol {

    func makeAreasTracker() -> AnalyticsTracker {
        let appearanceAction = makeScreenAppearanceAction()
        return AreaTracker(name: "Areas", screenApperanceAction: appearanceAction)
    }

    func makeMapTracker() -> MapAnalyticsTracker {
        let appearanceAction = makeScreenAppearanceAction()
        let eventAction = makeAnalyticsEventAction()
        return MapAnalyticsTracker(screenApperanceAction: appearanceAction, eventAction: eventAction)
    }

    func makeBBQDetailsTracker() -> BBQDetailsAnalyticsTracker {
        let appearanceAction = makeScreenAppearanceAction()
        let eventAction = makeAnalyticsEventAction()
        return BBQDetailsAnalyticsTracker(screenApperanceAction: appearanceAction, eventAction: eventAction)
    }

    private func makeScreenAppearanceAction() -> AnalyticsScreenAppearanceAction {
        let action: AnalyticsScreenAppearanceAction = { _ in }
        return action
    }

    private func makeAnalyticsEventAction() -> AnalyticsEventAction {
        let action: AnalyticsEventAction = { _ in }
        return action
    }
}
