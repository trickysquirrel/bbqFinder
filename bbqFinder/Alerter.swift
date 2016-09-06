//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import UIKit

class Alerter: NSObject {

    func displayOkAlert(title: String, message: String, presentingViewController: UIViewController) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let button = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(button)
        presentingViewController.presentViewController(alertController, animated: true, completion: nil)
    }
}
