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
    let userGeneratedKey: String

    init(title:String, facilities:String, lat:Double, lon:Double, address:String="", userGeneratedKey: String = "") {
        self.title = title
        self.facilities = facilities
        self.lat = lat
        self.lon = lon
        self.address = address
        self.userGeneratedKey = userGeneratedKey
    }
}


// todo change this to sections vic = A,B,C
enum BBQArea: String {

    case alpineShire = "Bright" // alpineshire
    case ballarat = "Ballarat"
    case melbourne = "Melbourne"
    case glenorchy = "Glenorchy"
    case noosa = "Noosa"
    case greaterDandenong = "Melbourne SE"
    case canberra = "Canberra"

    func title() -> String {
        return self.rawValue
    }

    func subtitle() -> String {
        switch self {
        case .alpineShire, .ballarat, .greaterDandenong:
            return "Victoria"
        case .melbourne:
            return "Victoria"
        case .glenorchy:
            return "Tasmania"
        case .noosa:
            return "Queensland"
        case .canberra:
            return "ACT"
        }
    }
}

protocol BBQListProvider {
    func allBbqs() -> [BBQ]
}

struct BBQAreaListProvider: BBQListProvider {

    let area: BBQArea

    func allBbqs() -> [BBQ] {

        switch area {
        case .melbourne:
            return melbourneBBQs
        case .ballarat:
            return ballaratBBQs
        case .greaterDandenong:
            return greaterDandenonyBBQs
        case .glenorchy:
            return glenorchyBBQs
        case .alpineShire:
            return alpineShireBBQs
        case .noosa:
            return noosaBBQs
        case .canberra:
            return canberraBBQs
        }
    }
}


let emptyBBQs: [BBQ] = []

