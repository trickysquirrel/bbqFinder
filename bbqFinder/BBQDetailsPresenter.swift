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
    func presenterUpdate(_ response: BBQDetailsPresenterResponseModel)
}


class BBQDetailsPresenter: NSObject, BBQDetailsInteractorOutput {

    private weak var output: BBQDetailsPresenterOutput?
    private let style: AppStyle
    private let appleMapsApp: AppleMapsApp

    private let distanceUnknownString = "your location is unknown"
    private let fetchingDistance = "please wait"
    private let facilitiesUnknownString = "unknown"
    private let requestingAddressString = "please wait"
    private let locationServiceOffTitle = "location services off"
    private let locationServiceOffMessage = "please go to settings and allow user location to be determined"


    init(output: BBQDetailsPresenterOutput, style: AppStyle, appleMapsApp: AppleMapsApp) {
        self.output = output
        self.style = style
        self.appleMapsApp = appleMapsApp
    }

    
    // MARK: interactor output 

    func interactorUpdate(_ response: BBQDetailsInteractorResponseModel) {

        switch response {
            
        case .details(let details):

            let viewModel = makeBBQDetailsDataModel(details)
            output?.presenterUpdate( .details(viewModel) )

        case .userLocationDenied:
            
            output?.presenterUpdate(.displayAlert(title: locationServiceOffTitle, message: locationServiceOffMessage))
        }
    }


    fileprivate func makeBBQDetailsDataModel(_ bbqDetails: BBQDetails) -> BBQDetailsViewModel {

        var labelColour = style.enabledColour

        let noAction: DataModelAction? = nil

        var distanceAction: DataModelAction? = nil
        var directionAction: DataModelAction? = makeShowDirectionAction(bbqDetails)

        if bbqDetails.userLocationUnknown {

            labelColour = style.disabledColour

            let requestUserLocationAction: DataModelAction  = { self.output?.presenterUpdate(.requiresUserLocation) }
            distanceAction = requestUserLocationAction
            directionAction = requestUserLocationAction
        }

        let mapViewModel = BBQDetailsViewCellModel(labelColour: labelColour, action: noAction, enabled: false, infoText: "")

        let distanceString = presentDistanceInMeters(bbqDetails)

        let distanceViewModel = BBQDetailsViewCellModel(labelColour: labelColour, action: distanceAction, enabled: false, infoText: distanceString)

        let directionViewModel = BBQDetailsViewCellModel(labelColour: style.enabledColour, action: directionAction, enabled: true, infoText: "")

        let facilities = presentFacilitiesTextAndColour(bbqDetails)

        let ammenitiesViewModel = BBQDetailsViewCellModel(labelColour: facilities.colour, action: noAction, enabled: false, infoText: facilities.text)

        let addressTextAndColour = presentAddressTextAndColour(bbqDetails)

        let addressViewModel = BBQDetailsViewCellModel(labelColour: addressTextAndColour.colour, action: directionAction, enabled: true, infoText: addressTextAndColour.text)

        let cellViewModels = [ mapViewModel, distanceViewModel, directionViewModel, ammenitiesViewModel, addressViewModel ]

        return BBQDetailsViewModel(
                coordinate: bbqDetails.coordinate,
                cellModels: cellViewModels
        )
    }

    // MARK: Presenters

    fileprivate func presentAddressTextAndColour(_ bbqDetails: BBQDetails) ->(text: String, colour: UIColor) {

        if bbqDetails.address.characters.count == 0 {
            return (requestingAddressString, style.disabledColour)
        }

        return (bbqDetails.address,style.selectableColour)
    }


    fileprivate func presentFacilitiesTextAndColour(_ bbqDetails: BBQDetails) -> (text:String, colour:UIColor) {

        if bbqDetails.facilities.isEmpty {
            return (facilitiesUnknownString, style.disabledColour)
        }
        return (bbqDetails.facilities, style.enabledColour)
    }


    fileprivate func presentDistanceInMeters(_ bbqDetails: BBQDetails) -> String {

        var distanceString = distanceUnknownString
        if bbqDetails.userLocationUnknown == false {

            if bbqDetails.distanceInMeters == 0 {
                distanceString = fetchingDistance
            }
            else {
                distanceString = "\(bbqDetails.distanceInMeters)m"
            }
        }
        return distanceString
    }

    // MARK: Actions

    fileprivate func makeRequestUserLocationAction() -> DataModelAction {

        return  { self.output?.presenterUpdate(.requiresUserLocation) }
    }


    fileprivate func makeShowDirectionAction(_ bbqDetails: BBQDetails) -> DataModelAction {

        let showDirectionsAction: DataModelAction  = {
            self.appleMapsApp.showDirectionsForLatitude(bbqDetails.coordinate.latitude, longitude: bbqDetails.coordinate.longitude, regionDistance: 10000, pinTitle: "bbq")
        }
        return showDirectionsAction
    }
}
