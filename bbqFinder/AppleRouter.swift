//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import CoreLocation


typealias RouterDirectionAction = (_ latitude: Double, _ longitude: Double, _ regionDistance: CLLocationDistance, _ pinTitle: String) -> Void

typealias RouterShareBBQAction = (_ presentingViewController: UIViewController, _ title:String, _ latitude: Double, _ longitude: Double) -> Void



struct AppleRouter {

    let appleMapsApp: AppleMapsApp


    func makeRouterDirectionAction() -> RouterDirectionAction {

        let action: RouterDirectionAction = { latitude, longitude, regionDistance, pinTitle in
            self.showDirections(latitude: latitude, longitude: longitude, regionDistance: regionDistance, pinTitle: pinTitle)
        }
        return action
    }


    func makeRouterShareBBQAction() -> RouterShareBBQAction {

        let action: RouterShareBBQAction = { presentingViewController, title, latitude, longitude in
            self.showSharing(presentingViewController: presentingViewController, title: title, latitude: latitude, longitude: longitude)
        }
        return action
    }
}



extension AppleRouter {

    fileprivate func showDirections(latitude: Double, longitude: Double, regionDistance: CLLocationDistance, pinTitle: String) {

        appleMapsApp.showDirectionsForLatitude(latitude, longitude: longitude, regionDistance: regionDistance, pinTitle: pinTitle)
    }


    fileprivate func showSharing(presentingViewController: UIViewController, title:String, latitude: Double, longitude: Double) {

        let latString = String(format: "%.6f", latitude)
        let lonString = String(format: "%.6f", longitude)

        if let myWebsite = NSURL(string: "http://maps.google.com/?ie=UTF8&hq=&ll=\(latString),\(lonString)&z=20") {

            let objectsToShare = [title, myWebsite] as [Any]

            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            activityVC.popoverPresentationController?.sourceView = presentingViewController.view
            presentingViewController.present(activityVC, animated: true, completion: nil)
        }
    }

}
