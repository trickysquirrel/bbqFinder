//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import MapKit


struct BBQDetails {
    let coordinate: CLLocationCoordinate2D
    let userLocationUnknown: Bool
    let distanceInMeters: Int
    let address: String
    let facilities: String
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
    let facilities: String
    var distanceInMeters: Int = 0


    init(output: BBQDetailsInteractorOutput, coordinate: CLLocationCoordinate2D, locationStatus: LocationManagerStatus, facilities: String) {
        self.output = output
        self.bbqCoordinate = coordinate
        self.locationStatus = locationStatus
        self.facilities = facilities
    }


    func fetchDetails() {

        if locationStatus.isCurrentLocationAuthorised() {
            output.interactorUpdate(.details(makeBBQDetails(locationAuthorised: true, distance: distanceInMeters)))
        }
        else {

            output.interactorUpdate(.details(makeBBQDetails(locationAuthorised: false, distance: distanceInMeters)))
        }

        requestUsersLocation()
        locationStatus.fetchCurrentAddress()
    }


    private func makeBBQDetails(locationAuthorised locationAuthorised:Bool, distance: Int, address : String="") -> BBQDetails {

        return BBQDetails(coordinate: bbqCoordinate, userLocationUnknown: !locationAuthorised, distanceInMeters: distance, address: address, facilities: facilities)
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

            distanceInMeters = Int(locationBbq.distanceFromLocation(locationUser))

            output.interactorUpdate(.details(makeBBQDetails(locationAuthorised: true, distance: distanceInMeters)))
        }
    }


    // MARK: Location status delegate

    func locationManagerStatusUpdated(locationManager: UserLocationStatus) {

        requestUsersLocation()
    }


    func didFetchAddress(address: String) {

        output.interactorUpdate(.details(makeBBQDetails(locationAuthorised: true, distance: distanceInMeters, address: address)))
    }

}
