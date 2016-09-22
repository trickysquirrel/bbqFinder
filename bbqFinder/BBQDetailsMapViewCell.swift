//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import MapKit


class BBQDetailsMapViewCell: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!

    func configureWithViewModel(_ viewModel: BBQDetailsViewCellModel?, coordinate: CLLocationCoordinate2D) {

        guard let viewModel = viewModel else { return }
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)
        mapView.setRegion(region, animated: false)
        isUserInteractionEnabled = viewModel.enabled
    }

}
