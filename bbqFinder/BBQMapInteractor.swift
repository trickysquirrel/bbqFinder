//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


enum BBQMapInteractorResponseModel {
    case bbqs([BBQ])
}

protocol BBQMapInteractorOutput {
    func interactorUpdate(response: BBQMapInteractorResponseModel)
}


class BBQMapInteractor: NSObject {

    let output: BBQMapInteractorOutput
    let bbqListProvider: BBQListProvider


    required init(output: BBQMapInteractorOutput, bbqListProvider: BBQListProvider) {

        self.output = output
        self.bbqListProvider = bbqListProvider
    }


    func fetchLocations() {

        output.interactorUpdate( locationsResponseModel() )
    }

    // MARK: Response Models

    private func locationsResponseModel() -> BBQMapInteractorResponseModel {

        let bbqs = bbqListProvider.list()
        let response: BBQMapInteractorResponseModel = .bbqs(bbqs)
        return response
    }

}
