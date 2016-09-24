//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class BBQDetailsAddressViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!

    func configureWithViewModel(_ viewModel: BBQDetailsViewCellModel?) {

        guard let viewModel = viewModel else { return }
        addressLabel.text = viewModel.infoText
    }

}
