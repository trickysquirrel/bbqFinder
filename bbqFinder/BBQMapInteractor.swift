//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


struct BBQ {
    let title: String
    let lat: Double
    let lon: Double
}

enum BBQMapInteractorResponseModel {
    case bbqs([BBQ])
    case showUsersLocation
    case userLocationDenied
}

protocol BBQMapInteractorOutput {
    func interactorUpdate(response: BBQMapInteractorResponseModel)
}


class BBQMapInteractor: NSObject, LocationManagerStatusDelegate {

    let output: BBQMapInteractorOutput
    let bbqListProvider: BBQListProvider
    let locationManagerStatus: LocationManagerStatus


    required init(output: BBQMapInteractorOutput, bbqListProvider: BBQListProvider, locationManagerStatus: LocationManagerStatus) {

        self.output = output
        self.bbqListProvider = bbqListProvider
        self.locationManagerStatus = locationManagerStatus
    }


    func fetchLocations() {

        output.interactorUpdate( locationsResponseModel() )
    }

    func requestUsersLocation() {

        self.locationManagerStatus.statusDelegate = self

        if locationManagerStatus.isCurrentLocationDenied() {
            output.interactorUpdate( .userLocationDenied )
        }
        else if locationManagerStatus.isCurrentLocationNotDetermined() {
            locationManagerStatus.requestLocationWhenInUse()
        }
        else {
            output.interactorUpdate( .showUsersLocation )
        }
    }

    // MARK: Location status delegate

    func locationManagerStatusUpdated(locationManager: UserLocationStatus) {

        requestUsersLocation()
    }

    // MARK: Response Models

    private func locationsResponseModel() -> BBQMapInteractorResponseModel {

        let bbqs = bbqListProvider.list()
        let response: BBQMapInteractorResponseModel = .bbqs(bbqs)
        return response
    }

}