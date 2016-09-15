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


class BBQDetailsInteractor: NSObject, RequestUserLocationDelegate, LocationAddressDelegate {

    let output: BBQDetailsInteractorOutput
    let userLocation: UserLocation
    let locationAddress: LocationAddress
    let bbqCoordinate: CLLocationCoordinate2D
    let facilities: String
    var distanceInMeters: Int = 0


    init(output: BBQDetailsInteractorOutput, coordinate: CLLocationCoordinate2D, facilities: String, userLocation: UserLocation, locationAddress: LocationAddress) {
        self.output = output
        self.bbqCoordinate = coordinate
        self.facilities = facilities
        self.userLocation = userLocation
        self.locationAddress = locationAddress
        super.init()
        self.locationAddress.delegate = self
    }


    func fetchDetails() {

        if userLocation.canRequestUserLocation() {
            output.interactorUpdate(.details(makeBBQDetails(locationAuthorised: true, distance: distanceInMeters)))
        }
        else {

            output.interactorUpdate(.details(makeBBQDetails(locationAuthorised: false, distance: distanceInMeters)))
        }

        fetchUsersLocation()
    }


    func fetchUsersLocation() {

        userLocation.delegate = self
        locationAddress.requestAddress(bbqCoordinate.latitude, longitude: bbqCoordinate.longitude)
        userLocation.requestUsersLocation()
    }


    // MARK: request user location delegate

    func requestUserLocationDenied() {

        output.interactorUpdate( .userLocationDenied )
    }


    func requestUserLocationCompleted(latitude:Double, londitude:Double) {

        let locationBbq = CLLocation(latitude: bbqCoordinate.latitude, longitude: bbqCoordinate.longitude)

        let locationUser = CLLocation(latitude: latitude, longitude: londitude)

        distanceInMeters = Int(locationBbq.distanceFromLocation(locationUser))

        output.interactorUpdate(.details(makeBBQDetails(locationAuthorised: true, distance: distanceInMeters)))
    }

    // MARK: Location Address Delegate

    func locationAddressDidFetchAddress(address: String) {

        output.interactorUpdate(.details(makeBBQDetails(locationAuthorised: true, distance: distanceInMeters, address: address)))
    }

    // MARK: Helpers

    private func makeBBQDetails(locationAuthorised locationAuthorised:Bool, distance: Int, address : String="") -> BBQDetails {

        return BBQDetails(coordinate: bbqCoordinate, userLocationUnknown: !locationAuthorised, distanceInMeters: distance, address: address, facilities: facilities)
    }
}
