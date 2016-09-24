//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


struct BBQDetailsViewCellModel {
    let labelColour: UIColor
    let action: DataModelAction
    let enabled: Bool
    let infoText: String
}

// todo this should be data model and extra view stuff
struct BBQDetailsViewModel {
    let title: String
    let distance: String
    let distanceColour: UIColor
    let directionAction: DataModelAction
    let shareAction: DataModelViewControllerAction
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

    fileprivate weak var output: BBQDetailsPresenterOutput?
    fileprivate let style: AppStyle
    fileprivate let appleMapsApp: AppleMapsApp

    // todo localise
    fileprivate let distanceUnknownString = "your location is unknown"
    fileprivate let fetchingDistance = "please wait"
    fileprivate let facilitiesUnknownString = "unknown"
    fileprivate let requestingAddressString = "please wait"
    fileprivate let locationServiceOffTitle = "location services off"
    fileprivate let locationServiceOffMessage = "please go to settings and allow user location to be determined"


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
            output?.presenterUpdate( response: .details(viewModel) )

        case .userLocationDenied:
            
            output?.presenterUpdate(response: .displayAlert(title: locationServiceOffTitle, message: locationServiceOffMessage))
        }
    }


    private func makeBBQDetailsDataModel(_ bbqDetails: BBQDetails) -> BBQDetailsViewModel {

        let mapViewModel = makeMapViewCellModel(bbqDetails: bbqDetails)
        let distanceViewModel = makeDistanceViewCellModel(bbqDetails: bbqDetails)
        let directionViewModel = makeDirectionViewCellModel(bbqDetails: bbqDetails)
        let ammenitiesViewModel = makeAmmenitiesViewCellModel(bbqDetails: bbqDetails)
        let addressViewModel = makeAddressViewCellModel(bbqDetails: bbqDetails)

        let cellViewModels = [ mapViewModel, distanceViewModel, directionViewModel, ammenitiesViewModel, addressViewModel ]

        let bbqLocation2D = CLLocationCoordinate2DMake(bbqDetails.latitude, bbqDetails.longitude)

        var distanceColour = style.enabledColour

        if bbqDetails.userLocationUnknown {
            distanceColour = style.disabledColour
        }


        return BBQDetailsViewModel(
                title: bbqDetails.title,
                distance: presentDistance(bbqDetails),
                distanceColour: distanceColour,
                directionAction: makeShowDirectionAction(bbqDetails: bbqDetails),
                shareAction: makeShareAction(bbqDetails: bbqDetails),
                coordinate: bbqLocation2D,
                cellModels: cellViewModels
        )
    }
}


// MARK: View Cell Models
extension BBQDetailsPresenter {

    fileprivate func makeMapViewCellModel(bbqDetails: BBQDetails) -> BBQDetailsViewCellModel {
        let emptyAction = makeEmptyAction()
        return BBQDetailsViewCellModel(labelColour: style.enabledColour, action: emptyAction, enabled: false, infoText: "")
    }


    fileprivate func makeDistanceViewCellModel(bbqDetails: BBQDetails) -> BBQDetailsViewCellModel {

        var action = makeEmptyAction()
        var colour = style.enabledColour
        let distanceString = presentDistance(bbqDetails)

        if bbqDetails.userLocationUnknown {
            action = { self.output?.presenterUpdate(response: .requiresUserLocation) }
            colour = style.disabledColour
        }

        return BBQDetailsViewCellModel(labelColour: colour, action: action, enabled: false, infoText: distanceString)
    }


    fileprivate func makeDirectionViewCellModel(bbqDetails: BBQDetails) -> BBQDetailsViewCellModel {
        let action = makeActionForDirections(bbqDetails: bbqDetails)
        return BBQDetailsViewCellModel(labelColour: style.enabledColour, action: action, enabled: true, infoText: "")
    }


    fileprivate func makeAmmenitiesViewCellModel(bbqDetails: BBQDetails) -> BBQDetailsViewCellModel {
        var text = facilitiesUnknownString
        var colour = style.disabledColour
        let emptyAction = makeEmptyAction()

        if bbqDetails.facilities.isEmpty == false {
            text = bbqDetails.facilities
            colour = style.enabledColour
        }

        return BBQDetailsViewCellModel(labelColour: colour, action: emptyAction, enabled: false, infoText: text)
    }


    fileprivate func makeAddressViewCellModel(bbqDetails: BBQDetails) -> BBQDetailsViewCellModel {

        var text = requestingAddressString
        var colour = style.disabledColour

        if bbqDetails.address.characters.count > 0 {
            text = bbqDetails.address
            colour = style.selectableColour
        }

        return BBQDetailsViewCellModel(labelColour: colour, action: makeEmptyAction(), enabled: true, infoText: text)
    }


    private func makeActionForDirections(bbqDetails: BBQDetails) -> DataModelAction {

        if bbqDetails.userLocationUnknown {
            return { self.output?.presenterUpdate(response: .requiresUserLocation) }
        }
        else {
            return makeShowDirectionAction(bbqDetails: bbqDetails)
        }
    }


    fileprivate func presentDistance(_ bbqDetails: BBQDetails) -> String {

        var distanceString = distanceUnknownString
        if bbqDetails.userLocationUnknown == false {

            if bbqDetails.distanceInMeters == 0 {
                distanceString = fetchingDistance
            }
            else {
                if bbqDetails.distanceInMeters < 999 {
                    distanceString = "\(bbqDetails.distanceInMeters)m"
                }
                else {
                    let kmDistance: Double = Double(bbqDetails.distanceInMeters)/1000.0
                    distanceString = String(format: "%.2fkm", kmDistance)
                }
            }
        }
        return distanceString
    }
}


// MARK: Actions
extension BBQDetailsPresenter {


    fileprivate func makeRequestUserLocationAction() -> DataModelAction {

        return { self.output?.presenterUpdate(response: .requiresUserLocation) }
    }


    fileprivate func makeEmptyAction() -> DataModelAction {

        return {}
    }


    fileprivate func makeShareAction(bbqDetails: BBQDetails) -> DataModelViewControllerAction {

        return { viewController in

            let textToShare = "Lets meet at a BBQ here"

            let latString = String(format: "%.6f", bbqDetails.latitude)
            let lonString = String(format: "%.6f", bbqDetails.longitude)

            if let myWebsite = NSURL(string: "http://maps.google.com/?ie=UTF8&hq=&ll=\(latString),\(lonString)&z=20") {

                let objectsToShare = [textToShare, myWebsite] as [Any]

                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

                activityVC.popoverPresentationController?.sourceView = viewController.view
                viewController.present(activityVC, animated: true, completion: nil)
            }
        }
    }


    fileprivate func makeShowDirectionAction(bbqDetails: BBQDetails) -> DataModelAction {

        let showDirectionsAction: DataModelAction  = {
            self.appleMapsApp.showDirectionsForLatitude(bbqDetails.latitude, longitude: bbqDetails.longitude, regionDistance: 10000, pinTitle: "bbq")
        }
        return showDirectionsAction
    }

}

