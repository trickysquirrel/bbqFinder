//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import CoreLocation


protocol LocationManagerStatus: class {

    var statusDelegate: LocationManagerStatusDelegate? { get set }
    func currentLocation() -> (lat:Double, lon:Double)?
    func isCurrentLocationNotDetermined() -> Bool
    func isCurrentLocationAuthorised() -> Bool
    func isCurrentLocationDenied() -> Bool
    func requestLocationWhenInUse()
}


protocol LocationManagerStatusDelegate: class {
    func locationManagerStatusUpdated(_ locationManager: UserLocationStatus)
    func didFetchAddress(_ address: String) // optional
}


extension LocationManagerStatusDelegate {

    func didFetchAddress(_ address: String) {
        // leaving this empty to act as an optional delegate method
    }
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


    func currentLocation() -> (lat:Double, lon:Double)? {

        guard isCurrentLocationAuthorised() == true else {
            print("you are not yet authorised to access user location")
            return nil
        }

        guard let coordinate = self.locationManager.location?.coordinate else {
            print("location manager does not yet have the user location")
            return nil
        }
        return (coordinate.latitude, coordinate.longitude)
    }


    func isCurrentLocationNotDetermined() -> Bool {

        return CLLocationManager.authorizationStatus() == .notDetermined
    }


    func isCurrentLocationAuthorised() -> Bool {

        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways;
    }


    func isCurrentLocationDenied() -> Bool {

        return CLLocationManager.authorizationStatus() == .denied;
    }


    func requestLocationWhenInUse() {

         locationManager.requestWhenInUseAuthorization()
    }

    // MARK: delegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        statusDelegate?.locationManagerStatusUpdated(self)
    }

}
