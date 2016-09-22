//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

// todo: not the correct name especially if we inject the view controller factory
class Wireframe: NSObject {


    func wireUpAreasViewController(controller: AreasViewController, action: @escaping AreaSelectionAction) {

        controller.title = "Bbq Areas"

        let presenter = AreasPresenter(interface: controller, action: action)

        let interactor = AreasInteractor(output: presenter)
        controller.interactor = interactor

        let nibContents =  Bundle.main.loadNibNamed("AreasTableViewBackground", owner: nil, options: nil)
        if let view = nibContents?.first as? UIView {
            controller.tableView.backgroundView = view
        }
    }


    func wireUpBbqMapViewController(controller: BBQMapViewController, bbqArea: BBQArea, action: @escaping BBQSelectionAction) {

        let presenter = BBQMapPresenter(output: controller, action: action)

        let bbqListProvider = BBQListProvider(area: bbqArea)

        let interactor = BBQMapInteractor(output: presenter, bbqListProvider: bbqListProvider)

        let userLocationInteractor = makeUserLocationInteractor(controller)

        controller.title = bbqArea.title()
        controller.interactor = interactor
        controller.userLocationInteractor = userLocationInteractor
    }


    // MARK: private

    fileprivate func makeUserLocationInteractor(_ output: UserLocationPresenterOutput) -> UserLocationInteractor {

        let locationManager = UserLocationStatus()
        let userLocationPresenter = UserLocationPresenter(output: output)
        let userLocationInteractor = UserLocationInteractor(output: userLocationPresenter, locationManagerStatus: locationManager)
        return userLocationInteractor
    }


}
