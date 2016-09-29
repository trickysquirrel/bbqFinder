//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


protocol AreasInteractorOutput {
    func didFetchAreas(_ list: [BBQArea])
}


final class AreasInteractor {

    private let areaList: [BBQArea] = [  .ballarat,
                                         .alpineShire,
                                         .canberra,
                                         .glenorchy,
                                         .melbourne,
                                         .greaterDandenong,
                                         .noosa
                                      ]
    private let output: AreasInteractorOutput

    init(output: AreasPresenter) {
        self.output = output
    }

    func fetchAreas() {
        output.didFetchAreas(areaList)
    }
}
