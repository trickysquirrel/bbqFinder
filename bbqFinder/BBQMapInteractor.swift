//
//  Created by Richard Moult on 06/09/2016.
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


struct BBQ {
    let title: String
    let lat: Double
    let lon: Double
}

struct BBQLocationsResponseModel {
    let bbqs: [BBQ]
}

protocol BBQMapInteractorOutput {
    func didFetchLocations(locations: BBQLocationsResponseModel)
}


class BBQMapInteractor: NSObject {

    let output: BBQMapInteractorOutput
    let bbqListProvider: BBQListProvider


    required init(output: BBQMapInteractorOutput, bbqListProvider: BBQListProvider) {

        self.output = output
        self.bbqListProvider = bbqListProvider
    }


    func fetchLocations() {

        output.didFetchLocations( responseModel() )
    }


    private func responseModel() -> BBQLocationsResponseModel {

        return BBQLocationsResponseModel(bbqs: bbqListProvider.list())
    }
}
