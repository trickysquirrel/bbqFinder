//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import CoreLocation


protocol UserLocationDelegate: class {
    func requestUserLocationDenied()
    func requestUserLocationCompleted(latitude:Double, longitude:Double)
}


class UserLocation: NSObject, LocationManagerStatusDelegate {

    weak var delegate: UserLocationDelegate?
    fileprivate let locationStatus: UserLocationStatus
    let geocoder: CLGeocoder


    init(locationStatus: UserLocationStatus) {

        self.locationStatus = locationStatus
        geocoder = CLGeocoder()
    }


    func canRequestUserLocation() -> Bool {

        if locationStatus.isCurrentLocationAuthorised() {
            return true
        }
        return false
    }


    func requestUsersLocation() {

        locationStatus.statusDelegate = self

        if locationStatus.isCurrentLocationDenied() {
            self.delegate?.requestUserLocationDenied()
        }
        else if locationStatus.isCurrentLocationNotDetermined() {
            locationStatus.requestLocationWhenInUse()
        }
        else if let location = locationStatus.currentLocation() {
            self.delegate?.requestUserLocationCompleted(latitude: location.lat, longitude: location.lon)
        }
    }


    // MARK: Location status delegate

    @objc internal func locationManagerStatusUpdated(_ locationManager: UserLocationStatus) {

        requestUsersLocation()
    }


}
