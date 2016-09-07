//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import MapKit


struct BBQMapViewModel {
    let title: String
    let location: CLLocationCoordinate2D
}

struct BBQMapDataModel {
    let viewModel: BBQMapViewModel
}

enum BBQMapPresenterResponse {
    case updateDataModels([BBQMapDataModel])
    case showUsersLocation()
    case displayAlert(title: String, message: String)
}

protocol BBQMapPresenterOutput: class {
    func presenterUpdate(response: BBQMapPresenterResponse)
}


class BBQMapPresenter: BBQMapInteractorOutput {

    weak var output: BBQMapPresenterOutput?


    required init(output: BBQMapPresenterOutput) {
        self.output = output
    }

    // MARK: interactor output

    func interactorUpdate(response: BBQMapInteractorResponseModel) {

        switch response {

        case .bbqs(let bbqs):
            let dataModels = bbqs.map { BBQMapDataModel(viewModel: makeViewModel($0)) }
            output?.presenterUpdate(.updateDataModels(dataModels))

        case .userLocationDenied:
            output?.presenterUpdate(.displayAlert(title:"location services off", message:"please go to settings and allow user location to be determined"))

        case .showUsersLocation:
            output?.presenterUpdate(.showUsersLocation())
        }
    }


    private func makeViewModel(bbq: BBQ) -> BBQMapViewModel {

        return BBQMapViewModel(title: bbq.title, location: CLLocationCoordinate2D(latitude: bbq.lat, longitude: bbq.lon))
    }
}
