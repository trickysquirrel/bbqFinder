//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import UIKit

class Alerter: NSObject {

    func displayOkAlert(_ title: String, message: String, presentingViewController: UIViewController) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let button = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(button)
        presentingViewController.present(alertController, animated: true, completion: nil)
    }
}
