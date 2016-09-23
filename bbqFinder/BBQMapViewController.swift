//
//  Copyright © 2016 RichardMoult. All rights reserved.
//
//  todo show to user that we are currently getting the users location - add spinner over button???
//  todo add drive and steps times using MKDirectionsResponse - http://www.techotopia.com/index.php/Using_MKDirections_to_get_iOS_7_Map_Directions_and_Routes
//  todo add reviews
//

import UIKit
import MapKit


class BBQMapViewController: UIViewController, BBQMapPresenterOutput, UserLocationPresenterOutput {

    var interactor: BBQMapInteractor!
    var userLocationInteractor: UserLocationInteractor!
    private let alerter: Alerter
    @IBOutlet weak var mapView: BBQMapView!


    deinit {
        print("deleted map view controller") // test this
    }


    required init(alerter: Alerter) {
        self.alerter = alerter
        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        if mapView.hasLocationData() == false {
            interactor.fetchLocations()
        }
    }

    // MARK: presenter output

    func presenterUpdate(_ response: BBQMapPresenterResponse) {

        switch(response) {
        case .updateDataModels(let coordinates):
            mapView.reloadData(coordinates)
        }
    }


    func presenterUpdate(_ presenter: UserLocationPresenter, response: UserLocationPresenterResponse) {

        switch(response) {
        case .showUsersLocation(let coordinate2D):
            mapView.showLocationOfUser(coordinate2D)

        case .displayAlert(let title, let message):
            alerter.displayOkAlert(title, message: message, presentingViewController: self)
        }
    }

    // MARK: Actions

    @IBAction func userSelectedShowCurrentLocation() {
        userLocationInteractor.requestUsersLocation()
    }

}
