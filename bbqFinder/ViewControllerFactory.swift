//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import Foundation


extension UIStoryboard {

    func instantiateViewControllerWithIdentifier(identifier: ViewControllersIDs) -> UIViewController {
        return self.instantiateViewControllerWithIdentifier(identifier.rawValue)
    }
}


enum ViewControllersIDs : String {
    case areas = "AreasViewControllerStoryboardID"
}


typealias AreaSelectionAction = (areaTitle:String) -> Void


class ViewControllerFactory: NSObject {

    private let storyboard: UIStoryboard?

    
    override init() {
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
    }


    func makeAreasViewController(action action: AreaSelectionAction) -> AreasViewController {

        let controller = storyboard?.instantiateViewControllerWithIdentifier(.areas) as! AreasViewController
        
        controller.dataSource = TableViewDataSource()
        controller.dataSource.delegate = controller

        let presenter = AreasPresenter(interface: controller, action: action)

        let interactor = AreasInteractor(output: presenter)
        controller.interactor = interactor

        return controller
    }
}
