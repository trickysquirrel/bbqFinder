//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


final class BBQDetailsAnalyticsTracker: NSObject {

    private let screenApperanceAction: AnalyticsScreenAppearanceAction
    private let eventAction: AnalyticsEventAction
    private let screenName = "Details"
    private let locationAction = "user location"
    private let directionAction = "directions"
    private let deleteAction = "delete"
    private let shareAction = "share"
    private let showLabel = "show"
    private let deniedLabel = "denied"
    private let deletedLabel = "deleted"


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

    func trackUserDeletedBBQ() {
        eventAction(screenName, deleteAction, deletedLabel)
    }
}
