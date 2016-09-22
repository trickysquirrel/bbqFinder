//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit


extension UILabel {

    func setText(text:String, characterSpacing:CGFloat) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSKernAttributeName, value: characterSpacing, range: NSMakeRange(0, text.characters.count))
        self.attributedText = attributedString
    }
}
