//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class BBQDetailsAmenitiesViewCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!

    func configureWithViewModel(_ viewModel: BBQDetailsViewCellModel?) {

        guard let viewModel = viewModel else { return }
        infoLabel.textColor = viewModel.labelColour
        infoLabel.text = viewModel.infoText
        isUserInteractionEnabled = viewModel.enabled
    }

}
