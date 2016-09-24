//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class BBQDetailsTableViewController: UITableViewController, BBQDetailsPresenterOutput {

    var interactor: BBQDetailsInteractor!
    var alerter: Alerter!
    private var viewModel: BBQDetailsViewModel?
    @IBOutlet weak var mapViewCell: BBQDetailsMapViewCell!
    @IBOutlet weak var distanceViewCell: BBQDetailsDistanceViewCell!
    @IBOutlet weak var ammentiesViewCell: BBQDetailsAmenitiesViewCell!
    @IBOutlet weak var addressViewCell: BBQDetailsAddressViewCell!


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.fetchDetails()
    }

    // MARK: Presenter output
    
    func presenterUpdate(response: BBQDetailsPresenterResponseModel) {

        switch response {

        case .details(let viewModel):
            self.viewModel = viewModel
            updateAllViewCells(viewModel)

        case .displayAlert(let title, let message):
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
        viewModel?.directionAction()
    }

    
    @IBAction func userSelectedShare() {
        viewModel?.shareAction(self)
    }
    
}
