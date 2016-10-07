//
//  AppDelegate.swift
//  bbqFinder
//
//  Created by Richard Moult on 23/08/2016.
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: BBQAppRouter?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        guard isExecutingTests() else {
            window = nil
            return false
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        guard let validWindow = window else { return true }

        let abConfiguration = BBQFinderConfiguration()
        setAppApperance()

        let appleMapsApp = AppleMapsAppDirection()
        let analyticsTrackerFactory = AnalyticsTrackerFactory()
        let viewControllerFactory = BBQViewControllerFactory(analyticsTrackerFactory: analyticsTrackerFactory)
        let moduleFactory = BBQModuleFactory(viewControllerFactory: viewControllerFactory)
        let appleRouter = BBQAppleRouterActionFactory(appleMapsApp: appleMapsApp)
        
        router = BBQAppRouter(window: validWindow,
                              navigationController: UINavigationController(),
                              moduleFactory: moduleFactory,
                              appleRouterActionFactory: appleRouter,
                              abConfiguration: abConfiguration)
        
        router?.showRootViewController()

        return true
    }


    private func setAppApperance() {

        let titleFont = UIFont(name: "HelveticaNeue-Light", size: 20)!
        let backButtonDont = UIFont(name: "HelveticaNeue-Light", size: 18)!

        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: titleFont
        ]

        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: backButtonDont], for: .normal)

        UINavigationBar.appearance().tintColor = UIColor.black
    }


    private func isExecutingTests() -> Bool {
        return NSClassFromString("XCTestCase") == nil
    }

    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}

}

