//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import MapKit


struct BBQDetails {
    let title: String
    let latitude: Double
    let longitude: Double
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


class BBQDetailsInteractor: NSObject, UserLocationDelegate, LocationAddressDelegate {

    private let output: BBQDetailsInteractorOutput
    private let userLocation: UserLocation
    private let locationAddress: LocationAddress
    private let bbqTitle: String
    private let bbqLatitude: Double
    private let bbqLongitude: Double
    private let facilities: String
    private let locationDistance: LocationDistance

    private var distanceInMeters: Int = 0
    private var userLocationAuthorised = false
    private var address: String = ""


    init(output: BBQDetailsInteractorOutput,
         bbqTitle: String,
         bbqLatitude: Double,
         bbqLongitude: Double,
         facilities: String,
         userLocation: UserLocation,
         locationAddress: LocationAddress,
         locationDistance: LocationDistance) {
        
        self.output = output
        self.bbqTitle = bbqTitle
        self.bbqLatitude = bbqLatitude
        self.bbqLongitude = bbqLongitude
        self.facilities = facilities
        self.userLocation = userLocation
        self.locationAddress = locationAddress
        self.locationDistance = locationDistance
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

        locationAddress.requestAddress(bbqLatitude, longitude: bbqLongitude)
    }
    

    func fetchUsersLocation() {

        userLocation.delegate = self
        userLocation.requestUsersLocation()
    }


    // MARK: request user location delegate

    func requestUserLocationDenied() {

        output.interactorUpdate( .userLocationDenied )
    }


    func requestUserLocationCompleted(latitude:Double, longitude:Double) {

        distanceInMeters = Int( locationDistance.calculateDistanceInMetersBetween(latitudeA: bbqLatitude, longitudeA: bbqLongitude, latitudeB: latitude, longitudeB: longitude))

        output.interactorUpdate(.details(makeBBQDetails()))
    }

    // MARK: Location Address Delegate

    func locationAddressDidFetchAddress(_ address: String) {

        self.address = address
        output.interactorUpdate(.details(makeBBQDetails()))
    }

    // MARK: Helpers

    private func makeBBQDetails() -> BBQDetails {

        return BBQDetails(title: bbqTitle,
                          latitude: bbqLatitude,
                          longitude: bbqLongitude,
                          userLocationUnknown: !userLocationAuthorised,
                          distanceInMeters: distanceInMeters,
                          address: address,
                          facilities: facilities)
    }
}
