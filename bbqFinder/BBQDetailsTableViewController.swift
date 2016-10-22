//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

final class BBQDetailsTableViewController: UITableViewController, BBQDetailsPresenterOutput {

    var detailsInteractor: BBQDetailsInteractor!
    var deleteBBQInteractor: DeleteBBQInteractor!
    var alerter: Alerter!
    var analytics: BBQDetailsAnalyticsTracker!
    private var viewModel: BBQDetailsViewModel?
    @IBOutlet weak var mapViewCell: BBQDetailsMapViewCell!
    @IBOutlet weak var distanceViewCell: BBQDetailsDistanceViewCell!
    @IBOutlet weak var ammentiesViewCell: BBQDetailsAmenitiesViewCell!
    @IBOutlet weak var addressViewCell: BBQDetailsAddressViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        analytics.trackScreenAppearance()
        detailsInteractor.fetchDetails()
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

        case .displayDeleteButton:
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(userSelectedDeleteBBQButton))

        }
    }

    // todo this could all be in an action
    @objc private func userSelectedDeleteBBQButton() {
        if let viewModel = viewModel {
            deleteBBQInteractor.deleteBBQWithUserGeneratedKey(viewModel.userGeneratedKey)
            navigationController?.popViewController(animated: true)
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
