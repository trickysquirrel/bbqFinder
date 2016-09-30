//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


class MapAnalyticsTracker: NSObject {

    // todo look at passing func instead so vars can be named
    private let screenApperanceAction: AnalyticsScreenAppearanceAction
    private let eventAction: AnalyticsEventAction
    private let screenName = "Map"
    private let locationAction = "user location"
    private let fetchLabel = "fetch"
    private let deniedLabel = "denied"


    required init(screenApperanceAction: @escaping AnalyticsScreenAppearanceAction, eventAction: @escaping AnalyticsEventAction) {

        self.screenApperanceAction = screenApperanceAction
        self.eventAction = eventAction
    }


    func trackScreenAppearance() {
        screenApperanceAction(screenName)
    }


    func trackUserLocationSelection() {
        eventAction(screenName, locationAction, fetchLabel)
    }


    func trackUserLocationDenied() {
        eventAction(screenName, locationAction, deniedLabel)

    }

}
