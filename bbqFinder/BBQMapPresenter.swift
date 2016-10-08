//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import MapKit


struct BBQMapViewModel {
    let title: String
    let location: CLLocationCoordinate2D
    let action: ViewModelAction
}

enum BBQMapPresenterResponse {
    case updateDataModels([BBQMapViewModel])
    case showUsersLocation(CLLocationCoordinate2D)
    case displayAlert(title: String, message: String)
}

protocol BBQMapPresenterOutput: class {
    func presenterUpdate(_ response: BBQMapPresenterResponse)
}


final class BBQMapPresenter: BBQMapInteractorOutput {

    private weak var output: BBQMapPresenterOutput?
    private let action: RouterBBQSelectionAction


    required init(output: BBQMapPresenterOutput, action: @escaping RouterBBQSelectionAction) {
        self.output = output
        self.action = action
    }

    // MARK: interactor output

    func interactorUpdate(_ response: BBQMapInteractorResponseModel) {

        switch response {

        case .bbqs(let bbqs):
            let dataModels = bbqs.map { makeViewModel($0) }
            output?.presenterUpdate(.updateDataModels(dataModels))

        case .userLocationDenied:
            output?.presenterUpdate(.displayAlert(title:"location services off", message:"please go to settings and allow user location to be determined"))

        case .usersLocation(let lat, let lon):

            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            output?.presenterUpdate(.showUsersLocation(coordinate))
        }
    }

    // MARK: helpers

    fileprivate func makeViewModel(_ bbq: BBQ) -> BBQMapViewModel {

        return BBQMapViewModel(title: bbq.title,
                               location: CLLocationCoordinate2D(latitude: bbq.lat, longitude: bbq.lon),
                               action: actionForBBQ(bbq))
    }


    fileprivate func actionForBBQ(_ bbq: BBQ) -> ViewModelAction {
        return  {
            let coordinate = CLLocationCoordinate2D(latitude: bbq.lat, longitude: bbq.lon)
            self.action( coordinate, bbq.title, bbq.facilities, bbq.address )
        }
    }

}
