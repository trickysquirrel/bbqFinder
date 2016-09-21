//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import MapKit


protocol AppleMapsApp {

    func showDirectionsForLatitude(_ latitude: Double, longitude: Double, regionDistance: CLLocationDistance, pinTitle: String)
}


struct AppleMapsAppDirection: AppleMapsApp {

    func showDirectionsForLatitude(_ latitude: Double, longitude: Double, regionDistance: CLLocationDistance, pinTitle: String) {

        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)

        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)

        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]

        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = pinTitle
        mapItem.openInMaps(launchOptions: options)
    }
}
