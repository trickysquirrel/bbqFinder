//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class BBQDetailsAmenitiesViewCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!

    func configureWithAmenities(_ text: String, colour: UIColor) {

        infoLabel.textColor = colour
        infoLabel.text = text
    }

}
