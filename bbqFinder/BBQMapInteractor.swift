//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


enum BBQMapInteractorResponseModel {
    case bbqs([BBQ])
    case usersLocation(latitude:Double, longitude:Double)
    case userLocationDenied
}

protocol BBQMapInteractorOutput {
    func interactorUpdate(_ response: BBQMapInteractorResponseModel)
}


class BBQMapInteractor: NSObject, UserLocationDelegate {

    private let output: BBQMapInteractorOutput
    private let bbqListProvider: BBQListProvider
    private let userLocation: UserLocation


    required init(output: BBQMapInteractorOutput, bbqListProvider: BBQListProvider, userLocation: UserLocation) {

        self.output = output
        self.bbqListProvider = bbqListProvider
        self.userLocation = userLocation
    }


    func fetchLocations() {

        output.interactorUpdate( locationsResponseModel() )
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

        output.interactorUpdate(.usersLocation(latitude: latitude, longitude: longitude))
    }

    // MARK: Response Models

    fileprivate func locationsResponseModel() -> BBQMapInteractorResponseModel {

        let bbqs = bbqListProvider.list()
        let response: BBQMapInteractorResponseModel = .bbqs(bbqs)
        return response
    }

}
