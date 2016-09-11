//
//  Copyright © 2016 RichardMoult. All rights reserved.
//
//  todo show to user that we are currently getting the users location - add spinner over button???
//  todo add distance to bbq
//  todo add area photo shot
//  todo add directions
//  todo address
//  todo ammenities
//  todo add review
//

import UIKit
import MapKit


class BBQMapViewController: UIViewController, BBQMapPresenterOutput, UserLocationPresenterOutput {

    var interactor: BBQMapInteractor!
    var userLocationInteractor: UserLocationInteractor!
    var alerter: Alerter!
    @IBOutlet var mapView: BBQMapView?

    deinit {
        print("deleted map view controller") // test this
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fetchLocations() // todo make only onViewDidLoad as it hides the pin callout info
    }

    // MARK: presenter output

    func presenterUpdate(response: BBQMapPresenterResponse) {

        switch(response) {

        case .updateDataModels(let coordinates):
            mapView?.reloadData(coordinates)
            
        }
    }


    func presenterUpdate(presenter: UserLocationPresenter, response: UserLocationPresenterResponse) {

        switch(response) {

        case .showUsersLocation(let coordinate2D):
            mapView?.showLocationOfUser(coordinate2D)

        case .displayAlert(let title, let message):
            alerter.displayOkAlert(title, message: message, presentingViewController: self)
        }
    }

    // MARK: Actions

    @IBAction func userSelectedShowCurrentLocation() {
        userLocationInteractor.requestUsersLocation()
    }

}
