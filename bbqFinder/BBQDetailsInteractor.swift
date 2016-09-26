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
    private var address: String = ""
    private let locationDistance: LocationDistance

    // todo remove these 2 vars
    private var distanceInMeters: Int = 0

    // todo pass through address if there is one
    init(output: BBQDetailsInteractorOutput,
         bbqTitle: String,
         bbqLatitude: Double,
         bbqLongitude: Double,
         facilities: String,
         address: String,
         userLocation: UserLocation,
         locationAddress: LocationAddress,
         locationDistance: LocationDistance) {
        
        self.output = output
        self.bbqTitle = bbqTitle
        self.bbqLatitude = bbqLatitude
        self.bbqLongitude = bbqLongitude
        self.facilities = facilities
        self.address = address
        self.userLocation = userLocation
        self.locationAddress = locationAddress
        self.locationDistance = locationDistance
        super.init()
        self.locationAddress.delegate = self
    }


    func fetchDetails() {

        fetchUsersLocation()
        fetchBBQAddress()
        output.interactorUpdate(.details(makeBBQDetails()))
    }


    private func isUsersLocationUnknown() -> Bool {

        return userLocation.canRequestUserLocation() ? false : true
    }


    private func fetchBBQAddress() {

        if address.isEmpty {
            locationAddress.requestAddress(bbqLatitude, longitude: bbqLongitude)
        }
        else {
            address = locationAddress.replaceCommasWithNewLines(address: address)
        }
    }
    

    private func fetchUsersLocation() {

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
                          userLocationUnknown: isUsersLocationUnknown(),
                          distanceInMeters: distanceInMeters,
                          address: address,
                          facilities: facilities)
    }
}
