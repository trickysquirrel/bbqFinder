//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class AreasViewController: UITableViewController, TableViewDataSourceDelegate, ListAreaPresenterOutput {

    private let tableViewDataSource: TableViewDataSource<AreasViewController>
    private let analytics: AreasTracker
    private var interactor: AreasInteractor?    // required var for the controller/interactor/presenter dependancy

    // MARK: Life cycle

    required init(tableViewDataSource: TableViewDataSource<AreasViewController>, analyticsTracker: AreasTracker) {

        self.tableViewDataSource = tableViewDataSource
        self.analytics = analyticsTracker
        super.init(style: .plain)
        tableView.registerTableCell(nibName: AreaTableViewCell.nibName, cellReuseIdentifier: AreaTableViewCell.cellIdentifier)
    }

    func configure(interactor: AreasInteractor) {
        self.interactor = interactor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        analytics.trackScreenAppearance()
        tableView.setAutoResizingTableCellsWithEstimatedRowHeight(140)
        interactor?.fetchAreas()
    }


    // MARK: List Area Output

    func presenterUpdate(_ response: AreasMapPresenterResponse) {

        switch response {
        case .updateAreas(let areas):
            let tableSections = convertAreasToTableSections(areas)
            tableViewDataSource.reloadData(tableSections: tableSections)
        }
    }


    private func convertAreasToTableSections(_ areas: [[AreaViewModel]]) -> [TableSection<AreaViewModel>] {
        return areas.map { TableSection<AreaViewModel>(rows: $0.map { TableRow<AreaViewModel>(data: $0, cellIdentifier: AreaTableViewCell.cellIdentifier) }) }
    }


    // MARK: data source delegate
    
    func configureCell(tableViewCell cell: AreaTableViewCell, object viewModel: AreaViewModel) {
        cell.configureWithViewModel(viewModel)
    }


    // MARK: table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableViewDataSource.objectAtIndexPath(indexPath)?.showMapAction()
    }

}
