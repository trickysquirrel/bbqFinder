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



import UIKit


protocol TableViewDataSourceDelegate: class {
    associatedtype cellType
    associatedtype dataSourceType
    func configureCell(tableViewCell cell: cellType, object: dataSourceType)
}

struct TableRow<T> {
    let data:T
    let cellIdentifier: String
}

struct TableSection<T:TableViewDataSourceDelegate> {
    let rows:[TableRow<T.dataSourceType>]
}


class TableViewDataSource<T:TableViewDataSourceDelegate>: NSObject, UITableViewDataSource where T.cellType: UITableViewCell {

    weak var delegate: T?
    private weak var tableView:UITableView?
    private var sections: [TableSection<T>]?


    func setTableView(_ tableView: UITableView?) {

        self.tableView = tableView
        self.tableView?.dataSource = self
    }


    func reloadData(_ dataSource: [[T.dataSourceType]], cellIdentifier: String) {

        guard delegate != nil else { print("delegate not yet set"); return }

        sections = dataSource.map { TableSection<T>(rows: $0.map{ TableRow<T.dataSourceType>(data: $0, cellIdentifier: cellIdentifier) }) }

        self.tableView?.reloadData()
    }

    // MARK: table view delegate

    func numberOfSections(in tableView: UITableView) -> Int {

        if let source = sections {
            return source.count
        }
        return 0
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let source = sections {

            if source.count > section {
                return source[section].rows.count
            }
        }
        return 0;
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let tableRow = sections?[safe:indexPath.section]?.rows[safe:indexPath.row] {

            if let cell = tableView.dequeueReusableCell(withIdentifier: tableRow.cellIdentifier, for: indexPath) as? T.cellType {

                self.delegate?.configureCell(tableViewCell: cell, object: tableRow.data)

                return cell
            }
        }
        print("CollectionViewDataSource ERROR: delegate not set or cell identifier not associated with kind of class cellType")
        return UITableViewCell()
    }


    func objectAtIndexPath(_ indexPath: IndexPath) -> T.dataSourceType? {

        return sections?[safe:indexPath.section]?.rows[safe:indexPath.row]?.data
    }

}
