//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


struct AreaViewModel {
    let title: String
}


protocol ListAreaViewInterface {
    func reloadData(dataSource:[[AreaViewModel]])
}


class AreasPresenter: NSObject {

    let areaList = [ AreaViewModel(title:"alpineShire"),
                     AreaViewModel(title:"ballarat"),
                     AreaViewModel(title:"glenorchy"),
                     AreaViewModel(title:"Melbourne") ]

    let interface: ListAreaViewInterface


    init(interface: ListAreaViewInterface) {
        self.interface = interface
    }


    func tempFuncUpdateView() {
        interface.reloadData([areaList])
    }
}
