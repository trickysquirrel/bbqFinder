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
    var router: Router?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        guard let validWindow = window else { return true }

        let viewControllerFactory = ViewControllerFactory()
        router = Router(window: validWindow, viewControllerFactory: viewControllerFactory, navigationController: UINavigationController())
        router?.showRootViewController()

        return true
    }



    func applicationWillResignActive(application: UIApplication) {}
    func applicationDidEnterBackground(application: UIApplication) {}
    func applicationWillEnterForeground(application: UIApplication) {}
    func applicationDidBecomeActive(application: UIApplication) {}
    func applicationWillTerminate(application: UIApplication) {}

}

