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
    // add other things like centre point
}


protocol BBQMapInteractorOutput {

    func didFetchLocations(locations: BBQLocationsResponseModel)
}


class BBQMapInteractor: NSObject {

    var output: BBQMapInteractorOutput


    required init(output: BBQMapInteractorOutput) {
        self.output = output
    }


    func fetchLocations() {

        output.didFetchLocations( responseModel() )
    }


    private func responseModel() -> BBQLocationsResponseModel {

        let bbqs = [
            BBQ(title:"Barbeque - Enterprize Park", lat: -37.8202390666158, lon: 144.959910438727),
            BBQ(title:"Barbeque - Brick Single Hotplate", lat: -37.8217875175357, lon: 144.957267921996)
        ]

        return BBQLocationsResponseModel(bbqs: bbqs)
    }
}
