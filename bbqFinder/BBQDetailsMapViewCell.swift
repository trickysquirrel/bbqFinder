//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import MapKit



class BBQDetailsMapViewCell: UITableViewCell {

    @IBOutlet var mapView: MKMapView?

    func configureWithViewModel(viewModel: BBQDetailsViewCellModel?, coordinate: CLLocationCoordinate2D) {

        guard let viewModel = viewModel else { return }
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 80, 80)
        mapView?.setRegion(region, animated: false)
        userInteractionEnabled = viewModel.enabled
    }

}
