//
//  Copyright © 2016 RichardMoult. All rights reserved.
//
//  Note: As this class contains a relationship with an end point (external web service)
//  we need to make sure this is not used in testing.  For these classes always use
//  protocols, tests are therefore required to replace the whole object.
//  If we use this as a sub class and override we might accidentally touch some code we were
//  not expecting and hit the network.
//  In this specific case googleAnalytics has a testing switch, but generally this is good practice


import UIKit


typealias AnalyticsScreenAppearanceAction = (_ screenName: String) -> Void
typealias AnalyticsEventAction = ((_ category: String, _ action: String, _ label: String) -> Void)


protocol AnalyticsTrackerFactoryProtocol {

    func makeAreasTracker() -> AreasTracker
    func makeMapTracker() -> MapAnalyticsTracker
    func makeAddBBQMapTracker() -> AddBBQMapAnalyticsTracker
    func makeBBQDetailsTracker() -> BBQDetailsAnalyticsTracker
}


final class AnalyticsTrackerFactory: AnalyticsTrackerFactoryProtocol {

    private let flurrySessionBuilder: FlurrySessionBuilder

    init() {

        let bundleVersion: String = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "unknown"

        flurrySessionBuilder = FlurrySessionBuilder()
        flurrySessionBuilder.withLogLevel(FlurryLogLevel(0)) // None
        flurrySessionBuilder.withCrashReporting(true)
        flurrySessionBuilder.withAppVersion(bundleVersion)

        Flurry.startSession(analyticsId, with: flurrySessionBuilder)
    }
    

    func makeAreasTracker() -> AreasTracker {
        return AreasTracker(screenApperanceAction: trackScreenAppearance)
    }


    func makeMapTracker() -> MapAnalyticsTracker {
        return MapAnalyticsTracker(screenApperanceAction: trackScreenAppearance, eventAction: trackEvent)
    }


    func makeAddBBQMapTracker() -> AddBBQMapAnalyticsTracker {
        return AddBBQMapAnalyticsTracker(screenApperanceAction: trackScreenAppearance, eventAction: trackEvent)
    }


    func makeBBQDetailsTracker() -> BBQDetailsAnalyticsTracker {
        return BBQDetailsAnalyticsTracker(screenApperanceAction: trackScreenAppearance, eventAction: trackEvent)
    }
}


//  We could pass in Flurry to the classes this factory generates, but this couples
//  those classes with the 3rd party library.
//  By passing in funcs rather than properties we ensure that all code that touches
//  the 3rd party library is kept in this class, decoupling all others.  We can then
//  easily switch to another analytic provider if needs by only amend this one class.

extension AnalyticsTrackerFactory {

    fileprivate func trackScreenAppearance(screenName: String) {
        Flurry.logEvent(screenName)
    }


    fileprivate func trackEvent(screenName: String, action: String, label: String) {
        Flurry.logEvent(screenName, withParameters: [action: label])
    }
}
