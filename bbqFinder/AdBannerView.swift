//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import iAd


final class BBQADBannerView: ADBannerView, ADBannerViewDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        alpha = 0.0
        self.delegate = self
    }


    func bannerViewActionShouldBegin(_ banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }

    
    func bannerViewDidLoadAd(_ banner: ADBannerView!) {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1.0;
        }
    }


    public func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
        alpha = 0.0
    }

}
