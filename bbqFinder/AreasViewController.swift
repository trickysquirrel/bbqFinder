//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class AreasViewController: UITableViewController, RMTableViewDataSourceDelegate {

    var dataSource: RMTableViewDataSource!
    var interactor: AreasInteractor!

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.setTableView(tableView)
        interactor.fetchAreas()
    }

    // MARK: data source delegate
    
    func cellReuseIdentifier(atIndexPath indexPath:NSIndexPath) -> String {
        return "AreasTableCellID"
    }


    func configureCell(tableViewCell cell:UITableViewCell, object:AnyObject) {

        cell.textLabel?.text = object as? String
    }

}
