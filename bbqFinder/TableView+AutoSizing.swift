//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

extension UITableView {

    func setAutoResizingTableCellsWithEstimatedRowHeight(_ height: CGFloat) {
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = height
    }
}
