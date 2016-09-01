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


class ViewControllerFactory: NSObject {

    private let storyboard: UIStoryboard?

    
    override init() {
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
    }


    func makeAreasViewController() -> AreasViewController {

        let controller = storyboard?.instantiateViewControllerWithIdentifier(.areas) as! AreasViewController
        
        controller.dataSource = RMTableViewDataSource()
        controller.dataSource.delegate = controller

        let presenter = AreasPresenter(interface: controller)

        let interactor = AreasInteractor(presenter: presenter)
        controller.interactor = interactor

        return controller
    }
}
