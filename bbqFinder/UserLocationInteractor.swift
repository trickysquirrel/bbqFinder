//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


enum UserLocationInteractorResponse {
    case showUsersLocation(lat:Double, lon:Double)
    case userLocationDenied
}


protocol UserLocationInteractorOutput {

    func interactorUpdate(_ response: UserLocationInteractorResponse)
}


class UserLocationInteractor: NSObject, LocationManagerStatusDelegate {

    let output: UserLocationInteractorOutput
    let locationManagerStatus: LocationManagerStatus


    required init(output: UserLocationInteractorOutput, locationManagerStatus: LocationManagerStatus) {

        self.output = output
        self.locationManagerStatus = locationManagerStatus
    }


    func requestUsersLocation() {

        self.locationManagerStatus.statusDelegate = self

        if locationManagerStatus.isCurrentLocationDenied() {
            output.interactorUpdate( .userLocationDenied )
        }
        else if locationManagerStatus.isCurrentLocationNotDetermined() {
            locationManagerStatus.requestLocationWhenInUse()
        }
        else if let location = locationManagerStatus.currentLocation() {
            output.interactorUpdate( .showUsersLocation(lat: location.lat, lon: location.lon) )
        }
    }


    // MARK: Location status delegate

    func locationManagerStatusUpdated(_ locationManager: UserLocationStatus) {

        requestUsersLocation()
    }


}
