//
//  Created by Richard Moult on 06/09/2016.
//  Copyright © 2016 RichardMoult. All rights reserved.
//
//  todo add user location
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
        }
    }

}
