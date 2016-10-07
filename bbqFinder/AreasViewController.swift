//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class AreasViewController: UITableViewController, TableViewDataSourceDelegate, ListAreaPresenterOutput {

    typealias cellType = AreaTableViewCell
    typealias dataSourceType = AreaViewModel
    private let dataSource: TableViewDataSource<AreasViewController>
    private let analytics: AreasTracker
    var interactor: AreasInteractor!    // required var for the controller/interactor/presenter dependancy


    required init(dataSource: TableViewDataSource<AreasViewController>, analyticsTracker: AreasTracker) {

        self.dataSource = dataSource
        self.analytics = analyticsTracker
        super.init(style: .plain)
        AreaTableViewCell.reigsterWithTableView(tableView)
        dataSource.delegate = self
        dataSource.setTableView(tableView)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        analytics.trackScreenAppearance()
        setAutoResizingTableCells()
        interactor.fetchAreas()
    }


    private func setAutoResizingTableCells() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }

    // MARK: List View Interface

    func presenterUpdate(_ response: AreasMapPresenterResponse) {

        switch response {
        case .updateAreas(let areas):
            dataSource.reloadData(areas, cellIdentifier: AreaTableViewCell.cellIdentifier)
        }
    }

    // MARK: data source delegate
    
    func configureCell(tableViewCell cell: AreaTableViewCell, object viewModel: AreaViewModel) {
        cell.configureWithViewModel(viewModel)
    }

    // MARK: table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dataSource.objectAtIndexPath(indexPath)?.action()
    }

}
