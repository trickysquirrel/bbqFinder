//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

final class BBQDetailsAddressViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!

    func configureWithAddress(_ address: String, colour: UIColor) {

        addressLabel.text = address
        addressLabel.textColor = colour
    }

}
