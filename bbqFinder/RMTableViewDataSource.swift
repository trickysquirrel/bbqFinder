//
//  TSTableDataSource.swift
//  FoodNutrientsFinder
//
//  Created by Richard Moult on 08/10/2015.
//  Copyright © 2015 TrickySquirrel. All rights reserved.
//

import UIKit


protocol RMTableViewDataSourceDelegate: class {

    associatedtype dataSourceType
    func cellReuseIdentifier(atIndexPath indexPath:NSIndexPath) -> String
    func configureCell(tableViewCell cell:UITableViewCell, object:dataSourceType)
}



class RMTableViewDataSource<T:RMTableViewDataSourceDelegate>: NSObject, UITableViewDataSource, ListInterface {

    var delegate: T?

    private var tableView:UITableView?
    private var dataSource:[[T.dataSourceType]]?


    func setTableView(tableView: UITableView?) {

        self.tableView = tableView
        self.tableView?.dataSource = self
    }


    // todo make listInteractor generic
    func reloadData(dataSource:[[AnyObject]]) {

        self.dataSource = dataSource as? AnyObject as? [[T.dataSourceType]]
        self.tableView?.reloadData()
    }

//    func reloadData(dataSource:[[T.dataSourceType]]) {
//
//        self.dataSource = dataSource
//        self.tableView?.reloadData()
//    }


    // MARK: table view delegate

    @objc internal func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        if let source = dataSource {
            return source.count
        }
        return 0
    }


    @objc internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let source = dataSource {

            if source.count > section {

                return source[section].count
            }
        }
        return 0;
    }


    @objc internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cellIdentifier = self.delegate?.cellReuseIdentifier(atIndexPath: indexPath)

        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath);

        let object = self.objectAtIndexPath(indexPath)

        self.delegate?.configureCell(tableViewCell: cell, object: object!)

        return cell;
    }


    // MARK: helpers
    
    private func objectAtIndexPath(indexPath: NSIndexPath) -> T.dataSourceType? {
        
        return dataSource?[safe:indexPath.section]?[safe:indexPath.row]
    }
    
}
