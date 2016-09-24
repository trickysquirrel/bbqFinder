//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit

class LabelSpacing: UILabel {

    @IBInspectable var spacing: CGFloat = 0.0

    override func layoutSubviews() {

        super.layoutSubviews()
        if let validText = text {
            self.setText(text: validText, characterSpacing: spacing)
        }
        self.setNeedsDisplay()
    }

}
