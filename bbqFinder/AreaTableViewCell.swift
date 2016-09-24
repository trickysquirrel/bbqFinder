//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit


class AreaTableViewCell: UITableViewCell {

    static let nibName = "AreaViewCell"
    static let cellIdentifier = "AreasTableCellID"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!


    class func reigsterWithTableView(_ tableView: UITableView) {
        let nibName = UINib(nibName: self.nibName, bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: AreaTableViewCell.cellIdentifier)
    }


    func configureWithViewModel(_ viewModel: AreaViewModel) {
        titleLabel.setText(text: viewModel.title, characterSpacing: 1.0)
        subtitleLabel.setText(text: viewModel.subtitle, characterSpacing: 5.0)
    }

}
