//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import MapKit


struct BBQDetails {
    let coordinate: CLLocationCoordinate2D
    let userLocationUnknown: Bool
    let distanceInMeters: Int
}

enum BBQDetailsInteractorResponseModel {
    case details(BBQDetails)
    case userLocationDenied
}

protocol BBQDetailsInteractorOutput {
    func interactorUpdate(response: BBQDetailsInteractorResponseModel)
}


class BBQDetailsInteractor: NSObject, LocationManagerStatusDelegate {

    let output: BBQDetailsInteractorOutput
    let locationStatus: LocationManagerStatus
    let bbqCoordinate: CLLocationCoordinate2D


    init(output: BBQDetailsInteractorOutput, coordinate: CLLocationCoordinate2D, locationStatus: LocationManagerStatus) {
        self.output = output
        self.bbqCoordinate = coordinate
        self.locationStatus = locationStatus
    }


    func fetchDetails() {

        if locationStatus.isCurrentLocationAuthorised() {
            output.interactorUpdate(.details(makeBBQDetailsWithLocationAuthorised(true, distance: 0)))
        }
        else {

            output.interactorUpdate(.details(makeBBQDetailsWithLocationAuthorised(false, distance: 0)))
        }

        requestUsersLocation()
    }


    private func makeBBQDetailsWithLocationAuthorised(locationAuthorised:Bool, distance: Int) -> BBQDetails {

        return BBQDetails(coordinate: bbqCoordinate, userLocationUnknown: !locationAuthorised, distanceInMeters: distance)
    }

    // MARK: user location status

    func requestUsersLocation() {

        locationStatus.statusDelegate = self

        if locationStatus.isCurrentLocationDenied() {
            output.interactorUpdate( .userLocationDenied )
        }
        else if locationStatus.isCurrentLocationNotDetermined() {
            locationStatus.requestLocationWhenInUse()
        }
        else if let location = locationStatus.currentLocation() {

            let locationBbq = CLLocation(latitude: bbqCoordinate.latitude, longitude: bbqCoordinate.longitude)

            let locationUser = CLLocation(latitude: location.lat, longitude: location.lon)

            let distance = Int(locationBbq.distanceFromLocation(locationUser))

            output.interactorUpdate(.details(makeBBQDetailsWithLocationAuthorised(true, distance: distance)))
        }
    }


    // MARK: Location status delegate

    func locationManagerStatusUpdated(locationManager: UserLocationStatus) {

        requestUsersLocation()
    }

}
