//
//  Copyright © 2015 TrickySquirrel. All rights reserved.
//

import UIKit


protocol TableViewDataSourceDelegate: class {

    associatedtype dataSourceType
    func cellReuseIdentifier(atIndexPath indexPath:IndexPath) -> String
    func configureCell(tableViewCell cell:UITableViewCell, object:dataSourceType)
}


class TableViewDataSource<T:TableViewDataSourceDelegate>: NSObject, UITableViewDataSource {

    var delegate: T?

    fileprivate var tableView:UITableView?
    fileprivate var dataSource:[[T.dataSourceType]]?


    func setTableView(_ tableView: UITableView?) {

        self.tableView = tableView
        self.tableView?.dataSource = self
    }


    func reloadData(_ dataSource:[[T.dataSourceType]]) {

        self.dataSource = dataSource
        self.tableView?.reloadData()
    }


    // MARK: table view delegate

    @objc internal func numberOfSections(in tableView: UITableView) -> Int {

        if let source = dataSource {
            return source.count
        }
        return 0
    }


    @objc internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let source = dataSource {

            if source.count > section {

                return source[section].count
            }
        }
        return 0;
    }


    @objc internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = self.delegate?.cellReuseIdentifier(atIndexPath: indexPath)

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier!, for: indexPath);

        let object = self.objectAtIndexPath(indexPath)

        self.delegate?.configureCell(tableViewCell: cell, object: object!)

        return cell;
    }


    // MARK: helpers
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> T.dataSourceType? {
        
        return dataSource?[safe:(indexPath as NSIndexPath).section]?[safe:(indexPath as NSIndexPath).row]
    }
    
}
