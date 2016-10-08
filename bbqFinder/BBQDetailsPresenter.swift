//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit



struct BBQDetailsViewModel {
    let title: String
    let distance: String
    let distanceColour: UIColor
    let address: String
    let addressColour: UIColor
    let amenities: String
    let amenitiesColour: UIColor
    let directionAction: ViewModelAction
    let shareAction: DataModelViewControllerAction
    let coordinate: CLLocationCoordinate2D
}

enum BBQDetailsPresenterResponseModel {
    case details(BBQDetailsViewModel)
    case displayAlert(title: String, message: String)
}

protocol BBQDetailsPresenterOutput: class {
    func presenterUpdate(response: BBQDetailsPresenterResponseModel)
}


final class BBQDetailsPresenter: NSObject, BBQDetailsInteractorOutput {

    fileprivate weak var output: BBQDetailsPresenterOutput?
    fileprivate let style: AppStyle
    fileprivate let directionsAction: RouterDirectionAction
    fileprivate let shareAction: RouterShareBBQAction

    // todo localise
    fileprivate let distanceUnknownString = "-.-km"
    fileprivate let fetchingDistance = "please wait"
    fileprivate let facilitiesUnknownString = "unknown"
    fileprivate let requestingAddressString = "please wait"
    fileprivate let locationServiceOffTitle = "location services off"
    fileprivate let locationServiceOffMessage = "please go to settings and allow user location to be determined"


    init(output: BBQDetailsPresenterOutput, style: AppStyle, directionsAction: @escaping RouterDirectionAction, sharingAction: @escaping RouterShareBBQAction) {
        self.output = output
        self.style = style
        self.directionsAction = directionsAction
        self.shareAction = sharingAction
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

        let bbqLocation2D = CLLocationCoordinate2DMake(bbqDetails.latitude, bbqDetails.longitude)
        let distance = presentDistance(bbqDetails: bbqDetails)
        let address = presentAddress(bbqDetails: bbqDetails)
        let amenities = presentAmenities(bbqDetails: bbqDetails)

        return BBQDetailsViewModel(
                title: bbqDetails.title,
                distance: distance.text,
                distanceColour: distance.colour,
                address: address.text,
                addressColour: address.colour,
                amenities: amenities.text,
                amenitiesColour: amenities.colour,
                directionAction: makeShowDirectionAction(bbqDetails: bbqDetails),
                shareAction: makeShareAction(bbqDetails: bbqDetails),
                coordinate: bbqLocation2D
        )
    }
}


// MARK: Present text and colours
extension BBQDetailsPresenter {

    fileprivate func presentAmenities(bbqDetails: BBQDetails) -> (text:String, colour:UIColor) {
        var text = facilitiesUnknownString
        var colour = style.disabledColour

        if bbqDetails.facilities.isEmpty == false {
            text = bbqDetails.facilities
            colour = style.enabledColour
        }

        return (text, colour)
    }


    fileprivate func presentAddress(bbqDetails: BBQDetails) -> (text: String, colour: UIColor) {

        if bbqDetails.address.characters.count > 0 {
            return (bbqDetails.address, style.enabledColour)
        }
        else {
            return (requestingAddressString, style.disabledColour)
        }
    }


    fileprivate func presentDistance(bbqDetails: BBQDetails) -> (text: String, colour: UIColor) {

        var colour = style.disabledColour
        var distanceString = distanceUnknownString
        if bbqDetails.userLocationUnknown == false {

            if bbqDetails.distanceInMeters == 0 {
                distanceString = fetchingDistance
            }
            else {
                colour = style.enabledColour
                if bbqDetails.distanceInMeters < 999 {
                    distanceString = "\(bbqDetails.distanceInMeters)m"
                }
                else {
                    let kmDistance: Double = Double(bbqDetails.distanceInMeters)/1000.0
                    distanceString = String(format: "%.2fkm", kmDistance)
                }
            }
        }
        return (distanceString, colour)
    }
}


// MARK: Actions
extension BBQDetailsPresenter {


    fileprivate func makeEmptyAction() -> ViewModelAction {

        return {}
    }


    private func makeActionForDirections(bbqDetails: BBQDetails) -> ViewModelAction {

        if bbqDetails.userLocationUnknown {
            return makeEmptyAction()
        }
        else {
            return makeShowDirectionAction(bbqDetails: bbqDetails)
        }
    }
    

    fileprivate func makeShareAction(bbqDetails: BBQDetails) -> DataModelViewControllerAction {

        return { viewController in
            self.shareAction(viewController, "Lets meet at a BBQ here", bbqDetails.latitude, bbqDetails.longitude)
        }
    }


    // todo - as this is a new view controller maybe this should belong in the router

    fileprivate func makeShowDirectionAction(bbqDetails: BBQDetails) -> ViewModelAction {

        let showDirectionsAction: ViewModelAction  = {
            self.directionsAction(bbqDetails.latitude, bbqDetails.longitude, 10000, "bbq")
        }
        return showDirectionsAction
    }

}

