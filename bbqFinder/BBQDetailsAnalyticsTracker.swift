//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


class BBQDetailsAnalyticsTracker: NSObject {

    private let screenApperanceAction: AnalyticsScreenAppearanceAction
    private let eventAction: AnalyticsEventAction
    private let screenName = "Details"
    private let locationAction = "user location"
    private let directionAction = "directions"
    private let shareAction = "share"
    private let showLabel = "show"
    private let deniedLabel = "denied"


    required init(screenApperanceAction: @escaping AnalyticsScreenAppearanceAction, eventAction: @escaping AnalyticsEventAction) {

        self.screenApperanceAction = screenApperanceAction
        self.eventAction = eventAction
    }


    func trackScreenAppearance() {
        screenApperanceAction(screenName)
    }


    func trackDirectionSelection() {
        eventAction(screenName, directionAction, showLabel)
    }


    func trackShareSelection() {
        eventAction(screenName, shareAction, showLabel)
    }


    func trackUserLocationDenied() {
        eventAction(screenName, locationAction, deniedLabel)
    }
}
