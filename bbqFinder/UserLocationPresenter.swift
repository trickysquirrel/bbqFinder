//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import CoreLocation


enum UserLocationPresenterResponse {
    case showUsersLocation(CLLocationCoordinate2D)
    case displayAlert(title: String, message: String)
}

protocol UserLocationPresenterOutput: class {
    func presenterUpdate(presenter: UserLocationPresenter, response: UserLocationPresenterResponse)
}


class UserLocationPresenter: NSObject, UserLocationInteractorOutput {

    weak var output: UserLocationPresenterOutput?


    init(output: UserLocationPresenterOutput) {
        self.output = output
    }


    // MARK: interactor output

    func interactorUpdate(response: UserLocationInteractorResponse) {

        switch response {

        case .userLocationDenied:
            output?.presenterUpdate(self, response: .displayAlert(title:"location services off", message:"please go to settings and allow user location to be determined"))

        case .showUsersLocation(let lat, let lon):

            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            output?.presenterUpdate(self, response: .showUsersLocation(coordinate))
        }
    }

}
