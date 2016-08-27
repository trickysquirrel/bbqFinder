//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class AreasViewController: UITableViewController, RMTableViewDataSourceDelegate {

    typealias dataSourceType = String
    var dataSource: RMTableViewDataSource<AreasViewController>!
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


    func configureCell(tableViewCell cell:UITableViewCell, object:String) {

        cell.textLabel?.text = object
    }

}
