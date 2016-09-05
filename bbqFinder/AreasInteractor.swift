//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


protocol AreasInteractorOutput {
    func didFetchAreas(list: [String])
}


class AreasInteractor {

    let areaList = ["alpineShire", "ballarat", "glenorchy", "Melbourne"]

    let output: AreasInteractorOutput

    init(output: AreasPresenter) {
        self.output = output
    }

    func fetchAreas() {
        output.didFetchAreas(areaList)
    }
}
