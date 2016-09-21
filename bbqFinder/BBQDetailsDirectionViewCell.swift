//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class BBQDetailsDirectionViewCell: UITableViewCell {


    func configureWithViewModel(_ viewModel: BBQDetailsViewCellModel?) {

        guard let viewModel = viewModel else { return }
        textLabel?.textColor = viewModel.labelColour
        isUserInteractionEnabled = viewModel.enabled
    }

}
