//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


protocol AreasInteractorOutput {
    func didFetchAreas(_ list: [BBQArea])
}


class AreasInteractor {

    private let areaList: [BBQArea] = [  .canberra,
                                         .ballarat,
                                         .alpineShire,
                                         .melbourne,
                                         .greaterDandenong,
                                         .noosa,
                                         .glenorchy ]
    private let output: AreasInteractorOutput

    init(output: AreasPresenter) {
        self.output = output
    }

    func fetchAreas() {
        output.didFetchAreas(areaList)
    }
}
