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
    case updateMapRegion(region: MKCoordinateRegion)
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
        output?.presenterUpdate(.updateMapRegion(region: makeCentreRegion(responseModel.bbqs)))
    }


    private func makeCentreRegion(bbqs: [BBQ]) -> MKCoordinateRegion {

        let distance: Double = 20000 // todo - make this dynamic

        if let firstBbq = bbqs.first {
            let coord = CLLocationCoordinate2D(latitude: firstBbq.lat, longitude: firstBbq.lon)
            return MKCoordinateRegionMakeWithDistance(coord, distance, distance)
        }
        return MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(), distance, distance)
    }


    private func makeViewModel(bbq: BBQ) -> BBQMapViewModel {

        return BBQMapViewModel(title: bbq.title, location: CLLocationCoordinate2D(latitude: bbq.lat, longitude: bbq.lon))
    }
}
