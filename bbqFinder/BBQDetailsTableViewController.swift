//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class BBQDetailsTableViewController: UITableViewController, BBQDetailsPresenterOutput {

    var interactor: BBQDetailsInteractor!
    var alerter: Alerter!
    var viewModels: BBQDetailsViewModel?
    @IBOutlet var mapViewCell: BBQDetailsMapViewCell?
    @IBOutlet var distanceViewCell: BBQDetailsDistanceViewCell?
    @IBOutlet var directionViewCell: BBQDetailsDirectionViewCell?
    @IBOutlet var ammentiesViewCell: BBQDetailsAmmenitiesViewCell?
    @IBOutlet var addressViewCell: BBQDetailsAddressViewCell?


    override func viewWillAppear(animated: Bool) {
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
            interactor.requestUsersLocation()

        case .displayAlert(let title, let message):
            alerter.displayOkAlert(title, message: message, presentingViewController: self)
            
        }
    }


    private func updateAllViewCells(viewModels: BBQDetailsViewModel) {

        mapViewCell?.configureWithViewModel(viewModels.cellModels[safe:0], coordinate: viewModels.coordinate)
        distanceViewCell?.configureWithViewModel(viewModels.cellModels[safe:1])
        directionViewCell?.configureWithViewModel(viewModels.cellModels[safe:2])
        ammentiesViewCell?.configureWithViewModel(viewModels.cellModels[safe:3])
        addressViewCell?.configureWithViewModel(viewModels.cellModels[safe:4])
    }


    // MARK: tabel view delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let cellModel = self.viewModels?.cellModels[safe: indexPath.row] {
            cellModel.action?()
        }
    }
    
}
