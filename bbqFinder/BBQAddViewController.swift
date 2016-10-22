//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class BBQAddViewController: UIViewController, BBQMapPresenterOutput {

    @IBOutlet weak var mapView: BBQMapView!
    private let alerter: Alerter
    private let analytics: AddBBQMapAnalyticsTracker
    var mapInteractor: BBQMapInteractor?
    var addInteractor: BBQAddInteractor?


    required init(alerter: Alerter, analytics: AddBBQMapAnalyticsTracker) {
        self.alerter = alerter
        self.analytics = analytics
        super.init(nibName: "BBQMapViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addLongPressGestureHandler()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.analytics.trackScreenAppearance()
        mapInteractor?.fetchLocations()
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


    // MARK: User Actions

    private func addLongPressGestureHandler() {

        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(userPerformedLongPressGesture))
        mapView.addGestureRecognizer(gesture)
    }


    @objc private func userPerformedLongPressGesture(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            analytics.trackUserAddingBBQ()
            let touchPoint = gesture.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            addInteractor?.addNewCoordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }


    @IBAction func userSelectedShowCurrentLocation() {
        analytics.trackUserLocationSelection()
        mapInteractor?.fetchUsersLocation()
    }
}
