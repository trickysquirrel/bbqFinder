//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class BBQDetailsAddressViewCell: UITableViewCell {

    @IBOutlet var addressLabel: UILabel?

    func configureWithViewModel(_ viewModel: BBQDetailsViewCellModel?) {

        guard let viewModel = viewModel else { return }
        addressLabel?.textColor = viewModel.labelColour
        addressLabel?.text = viewModel.infoText
        isUserInteractionEnabled = viewModel.enabled
    }

}