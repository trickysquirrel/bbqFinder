//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation

// todo: not the correct name especially if we inject the view controller factory
class Wireframe: NSObject {


    func wireUpAreasViewController(controller: AreasViewController, action: @escaping AreaSelectionAction) {

        controller.title = "Areas"
        controller.dataSource = TableViewDataSource()
        controller.dataSource.delegate = controller

        let presenter = AreasPresenter(interface: controller, action: action)

        let interactor = AreasInteractor(output: presenter)
        controller.interactor = interactor

    }
}
