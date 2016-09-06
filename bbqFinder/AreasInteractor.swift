//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


protocol AreasInteractorOutput {
    func didFetchAreas(list: [BBQArea])
}


class AreasInteractor {

    let areaList: [BBQArea] = [ .alpineShire, .ballarat, .glenorchy, .melbourne ]

    let output: AreasInteractorOutput

    init(output: AreasPresenter) {
        self.output = output
    }

    func fetchAreas() {
        output.didFetchAreas(areaList)
    }
}
