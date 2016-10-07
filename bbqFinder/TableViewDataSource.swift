//
//  Copyright © 2015 TrickySquirrel. All rights reserved.
//
//  The class that becomes the delegate will need to express two typealias's
//
//  typealias cellType = MyCellClass
//  typealias dataSourceType = MyDataClass
//
//  Implemenation of delegate methods now use the correct type, so no need to convert types, e.g.
//
//  func configureCell(collectionViewCell cell: MyCellClass, object: MyDataClass)
//
//  In this case we are saying that every collection view cell conforms to
//  MyCellClass and requires the same type of data MyDataClass.
//
//  But in the cases where you have cells of different types that require
//  different data types, you'll need
//
//  typealias cellType = UICollectionView
//  typealias dataSourceType = AnyObject
//
//  There is a code smell here as an external class can break the behavour by
//  returning different cellIdentifiers and needs to be in total sync with the property
//  dataSource.
//  Maybe later I'll associate data to cell identifier so things cannot get out of sync
//



import UIKit


protocol TableViewDataSourceDelegate: class {

    associatedtype cellType
    associatedtype dataSourceType
    func cellReuseIdentifier(atIndexPath indexPath: IndexPath) -> String
    func configureCell(tableViewCell cell: cellType, object: dataSourceType)
}


class TableViewDataSource<T:TableViewDataSourceDelegate>: NSObject, UITableViewDataSource where T.cellType: UITableViewCell {

    weak var delegate: T?
    private weak var tableView:UITableView?
    private var dataSource:[[T.dataSourceType]]?

    
    func setTableView(_ tableView: UITableView?) {

        self.tableView = tableView
        self.tableView?.dataSource = self
    }


    func reloadData(_ dataSource:[[T.dataSourceType]]) {

        guard delegate != nil else { print("delegate not yet set"); return }
        self.dataSource = dataSource
        self.tableView?.reloadData()
    }


    // MARK: table view delegate

    func numberOfSections(in tableView: UITableView) -> Int {

        if let source = dataSource {
            return source.count
        }
        return 0
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let source = dataSource {

            if source.count > section {
                return source[section].count
            }
        }
        return 0;
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cellIdentifier = self.delegate?.cellReuseIdentifier(atIndexPath: indexPath) {

            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? T.cellType {

                let object = self.objectAtIndexPath(indexPath)

                self.delegate?.configureCell(tableViewCell: cell, object: object!)

                return cell
            }
        }
        print("CollectionViewDataSource ERROR: delegate not set or cell identifier not associated with kind of class cellType")
        return UITableViewCell()
    }


    // MARK: helpers
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> T.dataSourceType? {
        
        return dataSource?[safe:(indexPath as NSIndexPath).section]?[safe:(indexPath as NSIndexPath).row]
    }
    
}
