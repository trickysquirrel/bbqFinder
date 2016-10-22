//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import CoreLocation


struct BBQMapViewModel {
    let title: String
    let location: CLLocationCoordinate2D
    let action: ViewModelAction
}

extension BBQMapViewModel: Equatable {}

func ==(lhs: BBQMapViewModel, rhs: BBQMapViewModel) -> Bool {
    return lhs.title == rhs.title &&
        lhs.location == rhs.location
}


extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
}
