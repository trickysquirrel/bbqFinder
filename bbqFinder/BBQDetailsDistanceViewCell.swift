//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class BBQDetailsDistanceViewCell: UITableViewCell {

    @IBOutlet var infoLabel: UILabel?

    func configureWithViewModel(_ viewModel: BBQDetailsViewCellModel?) {

        guard let viewModel = viewModel else { return }
        infoLabel?.textColor = viewModel.labelColour
        isUserInteractionEnabled = viewModel.enabled
        infoLabel?.text = viewModel.infoText
    }
}
