//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

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
        }
    }


    private func makeBBQDetailsDataModel(bbqDetails: BBQDetails) -> BBQDetailsViewModel {

        var labelColour = UIColor.blackColor()

        let noAction: DataModelAction? = nil

        var distanceAction: DataModelAction? = nil
        var directionAction: DataModelAction? = nil
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

        let distanceString = "\(bbqDetails.distanceInMeters)m"

        let distanceViewModel = BBQDetailsViewCellModel(labelColour: labelColour, action: distanceAction, enabled: enabled, infoText: distanceString)

        let directionViewModel = BBQDetailsViewCellModel(labelColour: labelColour, action: directionAction, enabled: enabled, infoText: "")

        let ammenitiesViewModel = BBQDetailsViewCellModel(labelColour: UIColor.blackColor(), action: noAction, enabled: false, infoText: "")

        let addressViewModel = BBQDetailsViewCellModel(labelColour: labelColour, action: addressAction, enabled: enabled, infoText: "")

        let cellViewModels = [ mapViewModel, distanceViewModel, directionViewModel, ammenitiesViewModel, addressViewModel ]

        return BBQDetailsViewModel(
                coordinate: bbqDetails.coordinate,
                cellModels: cellViewModels
        )
    }
}
