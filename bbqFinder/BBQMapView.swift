//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import MapKit


class MapViewAnnotation: NSObject, MKAnnotation {

    let coordinate: CLLocationCoordinate2D
    let dataModel: BBQMapDataModel
    let title: String?

    init(dataModel: BBQMapDataModel) {
        self.coordinate = dataModel.viewModel.location
        self.title = dataModel.viewModel.title
        self.dataModel = dataModel
    }
}


class BBQMapView: MKMapView, MKMapViewDelegate {

    private var annotationList:[MapViewAnnotation] = [MapViewAnnotation]()


    func hasLocationData() -> Bool {
        return annotationList.count > 0 ? true : false
    }


    func reloadData(_ dataSource:[BBQMapDataModel]) {

        delegate = self
        removeAnnotations(annotationList)
        annotationList = dataSource.map{ MapViewAnnotation(dataModel: $0) }
        addAnnotations(annotationList)
        showAnnotations(annotationList, animated: false)
    }


    func showAndCentreLocationOfUser(_ coordinate2D: CLLocationCoordinate2D) {

        showsUserLocation = true
        setCenter(coordinate2D, animated: true)
    }

    // MARK: MapView delegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard (annotation is MKUserLocation) == false else { return nil }
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "bbqLocation")
        view.canShowCallout = true
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return view
    }


    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        guard let annotation = view.annotation as? MapViewAnnotation else { return }
        annotation.dataModel.action()
    }
}
