//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class AreasViewController: UITableViewController, TableViewDataSourceDelegate, ListAreaPresenterOutput {

    typealias dataSourceType = AreaDataModel
    let dataSource: TableViewDataSource<AreasViewController>
    var interactor: AreasInteractor!    // required var for the controller/interactor/presenter dependancy


    required init(dataSource: TableViewDataSource<AreasViewController>) {

        self.dataSource = dataSource
        super.init(style: .plain)
        AreaTableViewCell.reigsterWithTableView(tableView)
        dataSource.delegate = self
        dataSource.setTableView(tableView)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        interactor.fetchAreas()
    }

    // MARK: List View Interface

    func presenterUpdate(_ response: AreasMapPresenterResponse) {

        switch response {
        case .updateAreas(let areas):
            dataSource.reloadData(areas)
        }
    }

    // MARK: data source delegate
    
    func cellReuseIdentifier(atIndexPath indexPath:IndexPath) -> String {
        return AreaTableViewCell.cellIdentifier
    }
    

    func configureCell(tableViewCell cell:UITableViewCell, object:AreaDataModel) {
        guard let cell = cell as? AreaTableViewCell else { return }
        cell.configureWithViewModel(viewModel: object.viewModel)
    }

    // MARK: table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dataSource.objectAtIndexPath(indexPath)?.action()
    }

}
