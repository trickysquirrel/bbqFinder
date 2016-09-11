//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class BBQDetailsAmmenitiesViewCell: UITableViewCell {

    func configureWithViewModel(viewModel: BBQDetailsViewCellModel?) {

        guard let viewModel = viewModel else { return }
        textLabel?.textColor = viewModel.labelColour
        userInteractionEnabled = false
        userInteractionEnabled = viewModel.enabled
    }

}
