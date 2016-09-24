//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class BBQDetailsTableViewController: UITableViewController, BBQDetailsPresenterOutput {

    var interactor: BBQDetailsInteractor!
    var alerter: Alerter!
    private var viewModels: BBQDetailsViewModel?
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

        case .details(let viewModels):
            self.viewModels = viewModels
            updateAllViewCells(viewModels)

        case .requiresUserLocation:
            interactor.fetchUsersLocation()

        case .displayAlert(let title, let message):
            alerter.displayOkAlert(title, message: message, presentingViewController: self)
            
        }
    }


    fileprivate func updateAllViewCells(_ viewModels: BBQDetailsViewModel) {

        mapViewCell.configureWithViewModel(coordinate: viewModels.coordinate)
        distanceViewCell.configureWithViewModel(title: viewModels.title, distance: viewModels.distance, distanceColour: viewModels.distanceColour)
        ammentiesViewCell.configureWithViewModel(viewModels.cellModels[safe:3])
        addressViewCell.configureWithViewModel(viewModels.cellModels[safe:4])
    }

    // MARK: Actions

    @IBAction func userSelectedDirection() {
        viewModels?.directionAction()
    }

    
    @IBAction func userSelectedShare() {
        viewModels?.shareAction(self)
    }
    
}
