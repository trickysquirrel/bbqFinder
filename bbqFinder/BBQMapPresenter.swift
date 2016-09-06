//
//  Created by Richard Moult on 06/09/2016.
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

    case updateDataModels(list: [BBQMapDataModel])
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

    func didFetchLocations(responseModel: BBQLocationsResponseModel) {

        let list = responseModel.bbqs.map { BBQMapDataModel(viewModel: makeViewModel($0)) }
        output?.presenterUpdate(.updateDataModels(list: list))
    }


    private func makeViewModel(bbq: BBQ) -> BBQMapViewModel {

        return BBQMapViewModel(title: bbq.title, location: CLLocationCoordinate2D(latitude: bbq.lat, longitude: bbq.lon))
    }
}
