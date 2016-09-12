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

        var enabled = false

        if bbqDetails.userLocationUnknown {

            labelColour = UIColor.lightGrayColor()
            enabled = true

            let requestUserLocationAction: DataModelAction  = { self.output?.presenterUpdate(.requiresUserLocation) }
            distanceAction = requestUserLocationAction
            directionAction = requestUserLocationAction
        }

        let mapViewModel = BBQDetailsViewCellModel(labelColour: labelColour, action: noAction, enabled: false, infoText: "")

        let distanceString = presentDistanceInMeters(bbqDetails)

        let distanceViewModel = BBQDetailsViewCellModel(labelColour: labelColour, action: distanceAction, enabled: false, infoText: distanceString)

        let directionViewModel = BBQDetailsViewCellModel(labelColour: UIColor.blackColor(), action: directionAction, enabled: true, infoText: ">")

        let facilities = presentFacilitiesTextAndColour(bbqDetails)

        let ammenitiesViewModel = BBQDetailsViewCellModel(labelColour: facilities.colour, action: noAction, enabled: false, infoText: facilities.text)

        let addressTextAndColour = addressTextAndFontColour(bbqDetails)
        let addressViewModel = BBQDetailsViewCellModel(labelColour: addressTextAndColour.colour, action: directionAction, enabled: true, infoText: addressTextAndColour.text)

        let cellViewModels = [ mapViewModel, distanceViewModel, directionViewModel, ammenitiesViewModel, addressViewModel ]

        return BBQDetailsViewModel(
                coordinate: bbqDetails.coordinate,
                cellModels: cellViewModels
        )
    }

    private func addressTextAndFontColour(bbqDetails: BBQDetails) ->(text: String, colour: UIColor) {

        if bbqDetails.address.characters.count == 0 {
            return ("requesting address please wait", UIColor.lightGrayColor())
        }

        return (bbqDetails.address, UIColor.blueColor())
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


    private func presentFacilitiesTextAndColour(bbqDetails: BBQDetails) -> (text:String, colour:UIColor) {

        if bbqDetails.facilities.characters.count == 0 {
            return ("unknown", UIColor.lightGrayColor())
        }
        return (bbqDetails.facilities, UIColor.blackColor())
    }


    private func presentDistanceInMeters(bbqDetails: BBQDetails) -> String {

        var distanceString = "your location is unknown"
        if bbqDetails.userLocationUnknown == false {
            distanceString = "\(bbqDetails.distanceInMeters)m"
        }
        return distanceString
    }
}
