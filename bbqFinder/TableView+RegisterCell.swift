//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit


extension UITableView {

    func registerTableCell(nibName: String, cellReuseIdentifier: String, bundle: Bundle?=nil) {

        let nibName = UINib(nibName: nibName, bundle:nil)
        self.register(nibName, forCellReuseIdentifier: cellReuseIdentifier)
    }
}
