//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class ButtonRounded: UIButton {

    @IBInspectable var rounding: CGFloat = 4.0

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = rounding
        clipsToBounds = true
    }

}
