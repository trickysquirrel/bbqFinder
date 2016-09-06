//
//  Created by Richard Moult on 06/09/2016.
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import MapKit


class BBQMapViewController: UIViewController, BBQMapPresenterOutput {

    var interactor: BBQMapInteractor!
    @IBOutlet var mapView: MapView?

    deinit {
        print("deleted map view controller")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fetchLocations()
    }

    // MARK: presenter output

    func presenterUpdate(response: BBQMapPresenterResponse) {

        switch(response) {
        case .updateDataModels(let coordinates):
            mapView?.reloadData(coordinates)
        case .updateMapRegion(let region):
            mapView?.updateRegion(region)
        }

    }

}
