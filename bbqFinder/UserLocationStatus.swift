//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import CoreLocation


protocol LocationManagerStatus: NSObjectProtocol {

    var statusDelegate: LocationManagerStatusDelegate? { get set }
    func isCurrentLocationNotDetermined() -> Bool
    func isCurrentLocationAuthorised() -> Bool
    func isCurrentLocationDenied() -> Bool
    func requestLocationWhenInUse()
}

protocol LocationManagerStatusDelegate: class {
    func locationManagerStatusUpdated(locationManager: UserLocationStatus)
}


class UserLocationStatus: NSObject, CLLocationManagerDelegate, LocationManagerStatus {

    let locationManager: CLLocationManager
    weak var statusDelegate: LocationManagerStatusDelegate?

    override init() {

        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }


    func isCurrentLocationNotDetermined() -> Bool {

        return CLLocationManager.authorizationStatus() == .NotDetermined
    }


    func isCurrentLocationAuthorised() -> Bool {

        return CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == .AuthorizedAlways;
    }


    func isCurrentLocationDenied() -> Bool {

        return CLLocationManager.authorizationStatus() == .Denied;
    }


    func requestLocationWhenInUse() {

         locationManager.requestWhenInUseAuthorization()
    }

    // MARK: delegate

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        statusDelegate?.locationManagerStatusUpdated(self)
    }

}
