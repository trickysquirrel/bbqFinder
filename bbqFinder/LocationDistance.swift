//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import CoreLocation

class LocationDistance: NSObject {

    func calculateDistanceInMetersBetween(latitudeA:Double, longitudeA:Double, latitudeB:Double, longitudeB:Double) -> Double {

        let locationA = CLLocation(latitude: latitudeA, longitude: longitudeA)

        let locationB = CLLocation(latitude: latitudeB, longitude: longitudeB)

        return locationA.distance(from: locationB)
    }


}
