//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
import MapKit


class MapViewAnnotation: NSObject, MKAnnotation {

    let coordinate: CLLocationCoordinate2D
    let action: ViewModelAction
    let title: String?

    init(viewModel: BBQMapViewModel) {
        self.coordinate = viewModel.location
        self.title = viewModel.title
        self.action = viewModel.action
    }
}


final class BBQMapView: MKMapView, MKMapViewDelegate {

    private var annotationList:[MapViewAnnotation] = [MapViewAnnotation]()
    private var mapViewModels = [BBQMapViewModel]()

    
    func hasLocationData() -> Bool {
        return annotationList.count > 0 ? true : false
    }


    func reloadData(_ newDataSource:[BBQMapViewModel]) {

        delegate = self

        if newDataSourceHasBeenUpdated(newDataSource) {
            removeAnnotations(annotationList)
            annotationList = newDataSource.map{ MapViewAnnotation(viewModel: $0) }
            addAnnotations(annotationList)
            fitAllAnnotationsInView()
        }

        mapViewModels = newDataSource
    }


    private func fitAllAnnotationsInView() {
        showAnnotations(annotationList, animated: false)
    }


    // todo - presentation logic, should dataSource be held by presenter ??? think so
    private func newDataSourceHasBeenUpdated(_ newDataSource: [BBQMapViewModel]) -> Bool {

        return (newDataSource == mapViewModels) ? false : true
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
        annotation.action()
    }
}
