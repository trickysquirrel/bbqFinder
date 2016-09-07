//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {

    func isLocationSet() -> Bool {

        if self.latitude == 0.0 && self.longitude == 0.0 {
            return true
        }
        return false
    }
}