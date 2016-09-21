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
    let action: DataModelAction
}

enum BBQMapPresenterResponse {
    case updateDataModels([BBQMapDataModel])
}

protocol BBQMapPresenterOutput: class {
    func presenterUpdate(_ response: BBQMapPresenterResponse)
}


class BBQMapPresenter: BBQMapInteractorOutput {

    weak var output: BBQMapPresenterOutput?
    var action: BBQSelectionAction


    required init(output: BBQMapPresenterOutput, action: @escaping BBQSelectionAction) {
        self.output = output
        self.action = action
    }

    // MARK: interactor output

    func interactorUpdate(_ response: BBQMapInteractorResponseModel) {

        switch response {

        case .bbqs(let bbqs):
            let dataModels = bbqs.map { BBQMapDataModel(viewModel: makeViewModel($0), action: actionForBBQ($0)) }
            output?.presenterUpdate(.updateDataModels(dataModels))
        }
    }


    fileprivate func makeViewModel(_ bbq: BBQ) -> BBQMapViewModel {

        return BBQMapViewModel(title: bbq.title, location: CLLocationCoordinate2D(latitude: bbq.lat, longitude: bbq.lon))
    }


    fileprivate func actionForBBQ(_ bbq: BBQ) -> DataModelAction {
        return  {
            let coordinate = CLLocationCoordinate2D(latitude: bbq.lat, longitude: bbq.lon)
            self.action( coordinate, bbq.facilities )
        }
    }

}
