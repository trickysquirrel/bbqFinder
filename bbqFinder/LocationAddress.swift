//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import CoreLocation


protocol LocationAddressDelegate: class {
    func locationAddressDidFetchAddress(_ address: String)
}


class LocationAddress: NSObject {

    weak var delegate: LocationAddressDelegate?
    fileprivate let locationStatus: UserLocationStatus
    let geocoder: CLGeocoder


    init(locationStatus: UserLocationStatus) {
        self.locationStatus = locationStatus
        geocoder = CLGeocoder()
    }


    func requestAddress(_ latitude: Double, longitude: Double) {

        let location = CLLocation(latitude: latitude, longitude: longitude)

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in

            guard let placemarks = placemarks else { return }
            guard let placemark = placemarks.last else { return }

            var address: String = self.appendString("", separator:"", string: placemark.subThoroughfare)

            address = self.appendString(address, separator:" ", string: placemark.thoroughfare)

            address = self.appendString(address, separator: "\n", string: placemark.locality)

            address = self.appendString(address,separator: "\n", string: placemark.postalCode)

            self.delegate?.locationAddressDidFetchAddress(address)
        }
    }


    fileprivate func appendString(_ address: String, separator: String, string: String?) -> String {

        guard let string = string else { return address }

        var output = address

        if address.characters.count > 0 {

            output = output + separator
        }
        return output + string
    }


    func replaceCommasWithNewLines(address: String) -> String {

        return address.replacingOccurrences(of: ",", with: "\n")
    }

}
