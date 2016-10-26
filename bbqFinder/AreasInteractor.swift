//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


protocol AreasInteractorOutput {
    func didFetchAreas(_ list: [BBQArea])
}


final class AreasInteractor {

    private let areaList: [BBQArea] = [
        .canberra,
        .noosa,
        .glenorchy,
        .ballarat,
        .alpineShire,
        .melbourne,
        .greaterDandenong,
    ]
    
    private let output: AreasInteractorOutput

    init(output: AreasPresenter) {
        self.output = output
    }

    func fetchAreas() {
        output.didFetchAreas(areaList)
    }
}
