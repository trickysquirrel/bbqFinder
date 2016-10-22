//
//  Copyright © 2016 RichardMoult. All rights reserved.
//
//  todo show to user that we are currently getting the users location - add spinner over button???
//  todo add drive and steps times using MKDirectionsResponse - http://www.techotopia.com/index.php/Using_MKDirections_to_get_iOS_7_Map_Directions_and_Routes
//  todo add reviews
//

import UIKit
import MapKit


final class BBQMapViewController: UIViewController, BBQMapPresenterOutput {

    var interactor: BBQMapInteractor!
    private let alerter: Alerter
    private let analytics: MapAnalyticsTracker
    @IBOutlet weak var mapView: BBQMapView!


    deinit {
        print("deleted map view controller") // test this
    }


    required init(alerter: Alerter, analyticsTracker: MapAnalyticsTracker) {
        self.alerter = alerter
        self.analytics = analyticsTracker
        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.analytics.trackScreenAppearance()
        interactor.fetchLocations()
    }

    // MARK: presenter output

    func presenterUpdate(_ response: BBQMapPresenterResponse) {

        switch(response) {

        case .updateDataModels(let bbqCoordinates):
            mapView.reloadData(bbqCoordinates)

        case .showUsersLocation(let coordinate2D):
            mapView.showAndCentreLocationOfUser(coordinate2D)

        case .displayAlert(let title, let message):
            analytics.trackUserLocationDenied()
            alerter.displayOkAlert(title, message: message, presentingViewController: self)
        }
    }


    // MARK: Actions

    @IBAction func userSelectedShowCurrentLocation() {
        analytics.trackUserLocationSelection()
        interactor.fetchUsersLocation()
    }

}
