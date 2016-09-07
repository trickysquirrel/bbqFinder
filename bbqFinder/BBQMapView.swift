//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import MapKit


@objc class MapViewAnnotation: NSObject, MKAnnotation {

    let coordinate: CLLocationCoordinate2D
    let dataModel: BBQMapDataModel
    let title: String?

    init(dataModel: BBQMapDataModel) {
        self.coordinate = dataModel.viewModel.location
        self.title = dataModel.viewModel.title
        self.dataModel = dataModel
    }
}


@objc class BBQMapView: MKMapView, MKMapViewDelegate {

    private var annotationList:[MapViewAnnotation] = [MapViewAnnotation]()


    func reloadData(dataSource:[BBQMapDataModel]) {
        
        removeAnnotations(annotationList)
        annotationList = dataSource.map{ MapViewAnnotation(dataModel: $0) }
        addAnnotations(annotationList)
        showAnnotations(annotationList, animated: false)
    }


    func showLocationOfUser() {

        showsUserLocation = true
        if userLocation.coordinate.isLocationSet() {
            delegate = self
        }
        else {
            setCenterCoordinate(userLocation.coordinate, animated: true)
        }
    }

    // MARK: MapView delegate

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        delegate = nil
        setCenterCoordinate(userLocation.coordinate, animated: true)
    }
}
