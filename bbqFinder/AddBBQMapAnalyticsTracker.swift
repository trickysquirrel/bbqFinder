//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


final class AddBBQMapAnalyticsTracker: NSObject {

    private let screenApperanceAction: AnalyticsScreenAppearanceAction
    private let eventAction: AnalyticsEventAction
    private let screenName = "AddBBQMap"
    private let locationAction = "user location"
    private let fetchLabel = "fetch"
    private let deniedLabel = "denied"
    private let addingBBQAction = "adding BBQ"


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

    func trackUserAddingBBQ() {
        eventAction(screenName, locationAction, addingBBQAction)
    }

}
