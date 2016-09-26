//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


struct BBQ {
    let title: String
    let facilities: String
    let lat: Double
    let lon: Double
    let address: String

    init(title:String, facilities:String, lat:Double, lon:Double, address:String="") {
        self.title = title
        self.facilities = facilities
        self.lat = lat
        self.lon = lon
        self.address = address
    }
}


// todo change this to sections vic = A,B,C
enum BBQArea: String {

    case alpineShire = "Bright" // alpineshire
    case ballarat = "Ballarat"
    case melbourne = "Melbourne"
    case glenorchy = "Glenorchy"

    func title() -> String {
        return self.rawValue
    }

    func subtitle() -> String {
        switch self {
        case .alpineShire, .ballarat:
            return "Victoria"
        case .melbourne:
            return "Victoria"
        case .glenorchy:
            return "Tasmania"
        }
    }
}


struct BBQListProvider {

    let area: BBQArea

    func list() -> [BBQ] {

        switch area {
        case .melbourne:
            return melbourneBBQs
        case .ballarat:
            return ballaratBBQs
        case .glenorchy:
            return glenorchyBBQs
        case .alpineShire:
            return alpineShireBBQs
//        default:
//            return emptyBBQs
        }
    }
}


let emptyBBQs: [BBQ] = []

