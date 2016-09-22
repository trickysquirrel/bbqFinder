//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class BBQDetailsTableViewController: UITableViewController, BBQDetailsPresenterOutput {

    var interactor: BBQDetailsInteractor!
    var alerter: Alerter!
    var viewModels: BBQDetailsViewModel?
    @IBOutlet weak var mapViewCell: BBQDetailsMapViewCell!
    @IBOutlet weak var distanceViewCell: BBQDetailsDistanceViewCell!
    @IBOutlet weak var directionViewCell: BBQDetailsDirectionViewCell!
    @IBOutlet weak var ammentiesViewCell: BBQDetailsAmenitiesViewCell!
    @IBOutlet weak var addressViewCell: BBQDetailsAddressViewCell!


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.fetchDetails()
    }

    // MARK: Presenter output
    
    func presenterUpdate(_ response: BBQDetailsPresenterResponseModel) {

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

        mapViewCell.configureWithViewModel(viewModels.cellModels[safe:0], coordinate: viewModels.coordinate)
        distanceViewCell.configureWithViewModel(viewModels.cellModels[safe:1])
        directionViewCell.configureWithViewModel(viewModels.cellModels[safe:2])
        ammentiesViewCell.configureWithViewModel(viewModels.cellModels[safe:3])
        addressViewCell.configureWithViewModel(viewModels.cellModels[safe:4])
    }


    // MARK: tabel view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        if let cellModel = self.viewModels?.cellModels[safe: (indexPath as NSIndexPath).row] {
            cellModel.action?()
        }
    }
    
}
