//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import MapKit


class BBQDetailsMapViewCell: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!

    func configureWithCoordinate(_ coordinate: CLLocationCoordinate2D) {

        let region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)
        mapView.setRegion(region, animated: false)
        isUserInteractionEnabled = false
    }

}
