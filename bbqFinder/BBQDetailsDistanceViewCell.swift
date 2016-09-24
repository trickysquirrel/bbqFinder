//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class BBQDetailsDistanceViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!

    func configureWithViewModel(title: String, distance: String, distanceColour: UIColor) {

        titleLabel.setText(text: title, characterSpacing: 1.0)
        infoLabel?.text = distance
        infoLabel?.textColor = distanceColour
    }
}
