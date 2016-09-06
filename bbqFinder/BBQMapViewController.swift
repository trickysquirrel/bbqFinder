//
//  Copyright © 2016 RichardMoult. All rights reserved.
//
//  todo add user location
//  todo add distance to bbq
//  todo add area photo shot
//  todo add directions
//  todo add review
//

import UIKit
import MapKit


class BBQMapViewController: UIViewController, BBQMapPresenterOutput {

    var interactor: BBQMapInteractor!
    @IBOutlet var mapView: MapView?

    deinit {
        print("deleted map view controller") // test this
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        interactor.fetchLocations()
    }

    // MARK: presenter output

    func presenterUpdate(response: BBQMapPresenterResponse) {

        switch(response) {

        case .updateDataModels(let coordinates):
            mapView?.reloadData(coordinates)

        case .watchUsersLocation:
            mapView?.showLocationOfUser()

        case .displayAlert(let title, let message):

            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let button = UIAlertAction(title: "ok", style: .Default, handler: nil)
            alertController.addAction(button)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    // MARK: Actions

    @IBAction func userSelectedShowCurrentLocation() {
        interactor.fetchUsersLocation()
    }

}
