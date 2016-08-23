//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


protocol ListInterface {

    func reloadData(dataSource:[[AnyObject]])
}

class AreasPresenter: NSObject {

    let areaList = ["alpineShire", "ballarat", "glenorchy", "Melbourne"]
    let interface: ListInterface


    init(interface: ListInterface) {
        self.interface = interface
    }


    func tempFuncUpdateView() {
        interface.reloadData([areaList])
    }
}
