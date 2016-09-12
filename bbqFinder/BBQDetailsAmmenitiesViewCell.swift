//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class BBQDetailsAmenitiesViewCell: UITableViewCell {

    @IBOutlet var infoLabel: UILabel?

    func configureWithViewModel(viewModel: BBQDetailsViewCellModel?) {

        guard let viewModel = viewModel else { return }
        infoLabel?.textColor = viewModel.labelColour
        infoLabel?.text = viewModel.infoText
        userInteractionEnabled = viewModel.enabled
    }

}
