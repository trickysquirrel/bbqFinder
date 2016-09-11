//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


struct BBQDetailsViewCellModel {
    let labelColour: UIColor
    let action: DataModelAction?
    let enabled: Bool
    let infoText: String
}

struct BBQDetailsViewModel {
    let coordinate: CLLocationCoordinate2D
    let cellModels: [BBQDetailsViewCellModel]
}

enum BBQDetailsPresenterResponseModel {
    case details(BBQDetailsViewModel)
    case requiresUserLocation
    case displayAlert(title: String, message: String)
}

protocol BBQDetailsPresenterOutput: class {
    func presenterUpdate(response: BBQDetailsPresenterResponseModel)
}


class BBQDetailsPresenter: NSObject, BBQDetailsInteractorOutput {

    weak var output: BBQDetailsPresenterOutput?


    init(output: BBQDetailsPresenterOutput) {
        self.output = output
    }

    
    // MARK: interactor output 

    func interactorUpdate(response: BBQDetailsInteractorResponseModel) {

        switch response {
            
        case .details(let details):
            output?.presenterUpdate( .details(makeBBQDetailsDataModel(details)) )

        case .userLocationDenied:
            output?.presenterUpdate(.displayAlert(title:"location services off", message:"please go to settings and allow user location to be determined"))
        }
    }


    private func makeBBQDetailsDataModel(bbqDetails: BBQDetails) -> BBQDetailsViewModel {

        var labelColour = UIColor.blackColor()

        let noAction: DataModelAction? = nil

        var distanceAction: DataModelAction? = nil
        var directionAction: DataModelAction? = makeDirectionAction(bbqDetails)
        var addressAction: DataModelAction? = nil

        var enabled = false

        if bbqDetails.userLocationUnknown {

            labelColour = UIColor.lightGrayColor()
            enabled = true

            let requestUserLocationAction: DataModelAction  = { self.output?.presenterUpdate(.requiresUserLocation) }
            distanceAction = requestUserLocationAction
            directionAction = requestUserLocationAction
            addressAction = requestUserLocationAction
        }

        let mapViewModel = BBQDetailsViewCellModel(labelColour: labelColour, action: noAction, enabled: false, infoText: "")

        let distanceString = presentDistanceInMeters(bbqDetails)

        let distanceViewModel = BBQDetailsViewCellModel(labelColour: labelColour, action: distanceAction, enabled: false, infoText: distanceString)

        let directionViewModel = BBQDetailsViewCellModel(labelColour: labelColour, action: directionAction, enabled: true, infoText: ">")

        let ammenitiesViewModel = BBQDetailsViewCellModel(labelColour: UIColor.blackColor(), action: noAction, enabled: false, infoText: "")

        let addressViewModel = BBQDetailsViewCellModel(labelColour: labelColour, action: addressAction, enabled: enabled, infoText: "")

        let cellViewModels = [ mapViewModel, distanceViewModel, directionViewModel, ammenitiesViewModel, addressViewModel ]

        return BBQDetailsViewModel(
                coordinate: bbqDetails.coordinate,
                cellModels: cellViewModels
        )
    }

    private func makeDirectionAction(bbqDetails: BBQDetails) -> DataModelAction {

        let showDirectionsAction: DataModelAction  = {

            let latitude:CLLocationDegrees =  bbqDetails.coordinate.latitude
            let longitude:CLLocationDegrees =  bbqDetails.coordinate.longitude

            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "bbq"
            mapItem.openInMapsWithLaunchOptions(options)
        }
        return showDirectionsAction
    }

    private func presentDistanceInMeters(bbqDetails: BBQDetails) -> String {

        var distanceString = "your location is unknown"
        if bbqDetails.userLocationUnknown == false {
            distanceString = "\(bbqDetails.distanceInMeters)m"
        }
        return distanceString
    }
}
