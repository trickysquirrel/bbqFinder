//
//  Copyright © 2016 RichardMoult. All rights reserved.
//
//  Note: As this class contains a relationship with an end point (external web service)
//  we need to make sure this is not used in testing.  For these classes always use
//  protocols, tests are therefore required to replace the whole object.
//  If we use this as a sub class we might accidentally touch some code we were
//  not expecting and hit the network.


import UIKit


typealias AnalyticsScreenAppearanceAction = ((_ screenName: String) -> Void)
typealias AnalyticsEventAction = ((_ category: String, _ action: String, _ label: String) -> Void)


protocol AnalyticsTrackerFactoryProtocol {

    func makeAreasTracker() -> AnalyticsTracker
    func makeMapTracker() -> MapAnalyticsTracker
    func makeBBQDetailsTracker() -> BBQDetailsAnalyticsTracker
}


final class AnalyticsTrackerFactory: AnalyticsTrackerFactoryProtocol {

    let tracker: GAITracker


    init() {
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")

        let gai = GAI.sharedInstance()
        gai?.trackUncaughtExceptions = true
        gai?.logger.logLevel = .none
        //gai?.dispatchInterval = 20

        tracker = GAI.sharedInstance().defaultTracker
    }


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

    // MARK: Actions

    private func makeScreenAppearanceAction() -> AnalyticsScreenAppearanceAction {

        let action: AnalyticsScreenAppearanceAction = { screenName in

            self.tracker.set(kGAIScreenName, value: screenName)

            if let builder = GAIDictionaryBuilder.createScreenView() {
                self.tracker.send(builder.build() as [NSObject : AnyObject])
            }
        }
        return action
    }


    private func makeAnalyticsEventAction() -> AnalyticsEventAction {

        let action: AnalyticsEventAction = { category, action, label in

            if let builder = GAIDictionaryBuilder.createEvent(withCategory: category,
                                                              action: action,
                                                              label: label,
                                                              value: 0) {
                self.tracker.send(builder.build() as [NSObject : AnyObject])
            }
        }
        return action
    }
}
