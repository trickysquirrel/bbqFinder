//
//  Created by Richard Moult on 06/09/2016.
//  Copyright © 2016 RichardMoult. All rights reserved.
//
//  todo: Add user location button

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


@objc class MapView: MKMapView {

    private var annotationList:[MapViewAnnotation] = [MapViewAnnotation]()

    func reloadData(dataSource:[BBQMapDataModel]) {
        
        removeAnnotations(annotationList)
        annotationList = dataSource.map{ MapViewAnnotation(dataModel: $0) }
        addAnnotations(annotationList)
        showAnnotations(annotationList, animated: false)
    }
}
