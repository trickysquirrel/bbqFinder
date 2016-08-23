//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation

class AreasInteractor: NSObject {

    let presenter: AreasPresenter // <-- make interface

    init(presenter: AreasPresenter) {
        self.presenter = presenter
    }

    func fetchAreas() {
        presenter.tempFuncUpdateView()
    }
}
