//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
import CoreLocation


protocol LocationAddressDelegate: class {
    func locationAddressDidFetchAddress(address: String)
}


class LocationAddress: NSObject {

    weak var delegate: LocationAddressDelegate?
    private let locationStatus: UserLocationStatus
    let geocoder: CLGeocoder


    init(locationStatus: UserLocationStatus) {
        self.locationStatus = locationStatus
        geocoder = CLGeocoder()
    }


    func requestAddress(latitude: Double, longitude: Double) {

        guard locationStatus.isCurrentLocationAuthorised() == true else {
            print("you are not yet authorised to access user location")
            return
        }

        let location = CLLocation(latitude: latitude, longitude: longitude)

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in

            guard let placemarks = placemarks else { return }
            guard let placemark = placemarks.last else { return }
            //CLPlacemark

            var address: String = self.addressByAddingString("", string: placemark.subThoroughfare)
            address = self.addressByAddingString(address, string: placemark.thoroughfare)
            address = self.addressByAddingNewLineString(address, string: placemark.locality)
            address = self.addressByAddingNewLineString(address, string: placemark.postalCode)

            self.delegate?.locationAddressDidFetchAddress(address)
        }
    }


    private func addressByAddingString(address: String, string: String?) -> String {

        guard let string = string else { return address }

        var output = address

        if address.characters.count > 0 {

            output = output.stringByAppendingString(" ")
        }
        return output.stringByAppendingString(string)
    }


    private func addressByAddingNewLineString(address: String, string: String?) -> String {

        guard let string = string else { return address }

        var output = address

        if address.characters.count > 0 {

            output = output.stringByAppendingString("\n")
        }
        return output.stringByAppendingString(string)
    }

}
