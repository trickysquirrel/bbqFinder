//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class AreasViewController: UITableViewController, TableViewDataSourceDelegate, ListAreaPresenterOutput {

    typealias dataSourceType = AreaDataModel
    var dataSource: TableViewDataSource<AreasViewController>!
    var interactor: AreasInteractor!


    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.setTableView(tableView)
        interactor.fetchAreas()
    }

    // MARK: List View Interface

    func presenterUpdate(_ response:AreasMapPresenterResponse) {

        switch response {
        case .updateAreas(let areas):
            dataSource.reloadData(areas)
        }
    }

    // MARK: data source delegate
    
    func cellReuseIdentifier(atIndexPath indexPath:IndexPath) -> String {
        return "AreasTableCellID"
    }

    func configureCell(tableViewCell cell:UITableViewCell, object:AreaDataModel) {
        cell.textLabel?.text = object.viewModel.title
    }

    // MARK: table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dataSource.objectAtIndexPath(indexPath)?.action()
    }

}
