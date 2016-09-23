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
    func interactorUpdate(_ response: BBQDetailsInteractorResponseModel)
}


class BBQDetailsInteractor: NSObject, RequestUserLocationDelegate, LocationAddressDelegate {

    private let output: BBQDetailsInteractorOutput
    private let userLocation: UserLocation
    private let locationAddress: LocationAddress
    private let bbqCoordinate: CLLocationCoordinate2D
    private let facilities: String

    private var distanceInMeters: Int = 0
    private var userLocationAuthorised = false
    private var address: String = ""


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

            userLocationAuthorised = true
            output.interactorUpdate(.details(makeBBQDetails()))
            fetchBBQAddress()
            fetchUsersLocation()
        }
        else {

            userLocationAuthorised = false
            output.interactorUpdate(.details(makeBBQDetails()))
            fetchBBQAddress()
        }
    }


    func fetchBBQAddress() {

        locationAddress.requestAddress(bbqCoordinate.latitude, longitude: bbqCoordinate.longitude)
    }
    

    func fetchUsersLocation() {

        userLocation.delegate = self
        userLocation.requestUsersLocation()
    }


    // MARK: request user location delegate

    func requestUserLocationDenied() {

        output.interactorUpdate( .userLocationDenied )
    }


    func requestUserLocationCompleted(_ latitude:Double, londitude:Double) {

        let locationBbq = CLLocation(latitude: bbqCoordinate.latitude, longitude: bbqCoordinate.longitude)

        let locationUser = CLLocation(latitude: latitude, longitude: londitude)

        distanceInMeters = Int(locationBbq.distance(from: locationUser))

        output.interactorUpdate(.details(makeBBQDetails()))
    }

    // MARK: Location Address Delegate

    func locationAddressDidFetchAddress(_ address: String) {

        self.address = address
        output.interactorUpdate(.details(makeBBQDetails()))
    }

    // MARK: Helpers

    fileprivate func makeBBQDetails() -> BBQDetails {

        return BBQDetails(coordinate: bbqCoordinate, userLocationUnknown: !userLocationAuthorised, distanceInMeters: distanceInMeters, address: address, facilities: facilities)
    }
}
