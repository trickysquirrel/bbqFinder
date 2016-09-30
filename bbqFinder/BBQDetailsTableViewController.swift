//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

final class BBQDetailsTableViewController: UITableViewController, BBQDetailsPresenterOutput {

    var interactor: BBQDetailsInteractor!
    var alerter: Alerter!
    var analytics: BBQDetailsAnalyticsTracker!
    private var viewModel: BBQDetailsViewModel?
    @IBOutlet weak var mapViewCell: BBQDetailsMapViewCell!
    @IBOutlet weak var distanceViewCell: BBQDetailsDistanceViewCell!
    @IBOutlet weak var ammentiesViewCell: BBQDetailsAmenitiesViewCell!
    @IBOutlet weak var addressViewCell: BBQDetailsAddressViewCell!


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        analytics.trackScreenAppearance()
        interactor.fetchDetails()
    }

    // MARK: Presenter output
    
    func presenterUpdate(response: BBQDetailsPresenterResponseModel) {

        switch response {

        case .details(let viewModel):
            self.viewModel = viewModel
            updateAllViewCells(viewModel)

        case .displayAlert(let title, let message):
            analytics.trackUserLocationDenied()
            alerter.displayOkAlert(title, message: message, presentingViewController: self)
            
        }
    }


    fileprivate func updateAllViewCells(_ viewModel: BBQDetailsViewModel) {

        mapViewCell.configureWithCoordinate(viewModel.coordinate)
        distanceViewCell.configureWithBbqTitle(viewModel.title, distance: viewModel.distance, distanceColour: viewModel.distanceColour)
        ammentiesViewCell.configureWithAmenities(viewModel.amenities, colour: viewModel.amenitiesColour)
        addressViewCell.configureWithAddress(viewModel.address, colour: viewModel.addressColour)
    }

    // MARK: Actions

    @IBAction func userSelectedDirection() {
        analytics.trackDirectionSelection()
        viewModel?.directionAction()
    }

    
    @IBAction func userSelectedShare() {
        analytics.trackShareSelection()
        viewModel?.shareAction(self)
    }
    
}
