//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import MapKit


struct BBQDetails {
    let coordinate: CLLocationCoordinate2D
    let userLocationUnknown: Bool

}

enum BBQDetailsInteractorResponseModel {
    case details(BBQDetails)
}

protocol BBQDetailsInteractorOutput {
    func interactorUpdate(response: BBQDetailsInteractorResponseModel)
}


class BBQDetailsInteractor: NSObject {

    let output: BBQDetailsInteractorOutput
    let locationStatus: LocationManagerStatus
    let coordinate: CLLocationCoordinate2D


    init(output: BBQDetailsInteractorOutput, coordinate: CLLocationCoordinate2D, locationStatus: LocationManagerStatus) {
        self.output = output
        self.coordinate = coordinate
        self.locationStatus = locationStatus
    }


    func fetchDetails() {

        if locationStatus.isCurrentLocationAuthorised() {
            output.interactorUpdate(.details(makeBBQDetailsWithLocationAuthorised(true)))
        }
        else {

            output.interactorUpdate(.details(makeBBQDetailsWithLocationAuthorised(false)))
        }
    }


    private func makeBBQDetailsWithLocationAuthorised(locationAuthorised:Bool) -> BBQDetails {

        return BBQDetails(coordinate: coordinate, userLocationUnknown: !locationAuthorised)
    }
}
