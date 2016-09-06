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
        print("list interactor \(interactor)")
        interactor.fetchAreas()
    }

    // MARK: List View Interface

    func presenterUpdate(response:AreasMapPresenterResponse) {

        switch response {
        case .updateAreas(let areas):
            dataSource.reloadData(areas)
        }
    }

    // MARK: data source delegate
    
    func cellReuseIdentifier(atIndexPath indexPath:NSIndexPath) -> String {
        return "AreasTableCellID"
    }

    func configureCell(tableViewCell cell:UITableViewCell, object:AreaDataModel) {
        cell.textLabel?.text = object.viewModel.title
    }

    // MARK: table view delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        dataSource.objectAtIndexPath(indexPath)?.action()
    }

}
