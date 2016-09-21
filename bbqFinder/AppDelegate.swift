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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        guard let validWindow = window else { return true }

        let wireframe = Wireframe()
        let viewControllerFactory = ViewControllerFactory()
        router = Router(window: validWindow, viewControllerFactory: viewControllerFactory, navigationController: UINavigationController(), wireframe: wireframe)
        router?.showRootViewController()

        return true
    }



    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}

}

