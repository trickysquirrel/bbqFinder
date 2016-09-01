//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class AreasViewController: UITableViewController, TableViewDataSourceDelegate, ListAreaViewInterface {

    typealias dataSourceType = AreaViewModel
    var dataSource: TableViewDataSource<AreasViewController>!
    var interactor: AreasInteractor!


    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.setTableView(tableView)
        interactor.fetchAreas()
    }

    // MARK: List View Interface

    func reloadData(data:[[AreaViewModel]]) {
        dataSource.reloadData(data)
    }

    // MARK: data source delegate
    
    func cellReuseIdentifier(atIndexPath indexPath:NSIndexPath) -> String {
        return "AreasTableCellID"
    }


    func configureCell(tableViewCell cell:UITableViewCell, object:AreaViewModel) {
        cell.textLabel?.text = object.title
    }

    // MARK: table view delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
