//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import CoreLocation


protocol LocationManagerStatus: class {

    var statusDelegate: LocationManagerStatusDelegate? { get set }
    func currentLocation() -> (lat:Double, lon:Double)?
    func fetchCurrentAddress()
    func isCurrentLocationNotDetermined() -> Bool
    func isCurrentLocationAuthorised() -> Bool
    func isCurrentLocationDenied() -> Bool
    func requestLocationWhenInUse()
}


protocol LocationManagerStatusDelegate: class {
    func locationManagerStatusUpdated(locationManager: UserLocationStatus)
    func didFetchAddress(address: String) // optional
}


extension LocationManagerStatusDelegate {

    func didFetchAddress(address: String) {
        // leaving this empty to act as an optional delegate method
    }
}

class UserLocationStatus: NSObject, CLLocationManagerDelegate, LocationManagerStatus {

    let locationManager: CLLocationManager
    let geocoder: CLGeocoder
    weak var statusDelegate: LocationManagerStatusDelegate?

    override init() {

        locationManager = CLLocationManager()
        geocoder = CLGeocoder()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }


    func currentLocation() -> (lat:Double, lon:Double)? { // todo tuple to lat lon

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


    func fetchCurrentAddress() {

        guard isCurrentLocationAuthorised() == true else {
            print("you are not yet authorised to access user location")
            return
        }

        guard let location = self.locationManager.location else {
            print("location manager does not yet have the user location")
            return
        }

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in

            guard let placemarks = placemarks else { return }
            guard let placemark = placemarks.last else { return }

            var address: String = self.addressByAddingString("", string: nil)
            address = self.addressByAddingString(address, string: placemark.thoroughfare)
            address = self.addressByAddingString(address, string: placemark.locality)
            address = self.addressByAddingString(address, string: placemark.postalCode)

            self.statusDelegate?.didFetchAddress(address)
        }
    }


    private func addressByAddingString(address: String, string: String?) -> String {

        guard let string = string else { return address }

        var output = address

        if address.characters.count > 0 {

            output = output.stringByAppendingString("\n")
        }
        return output.stringByAppendingString(string)
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
