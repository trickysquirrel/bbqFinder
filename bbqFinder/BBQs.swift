//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


struct BBQ {
    let title: String
    let facilities: String
    let lat: Double
    let lon: Double
}


// todo change this to sections vic = A,B,C
enum BBQArea: String {

    case alpineShire = "Melbourne - Bright (alpineshire)"
    case ballarat = "Melbourne - Ballarat"
    case melbourne = "Melbourne - CBD"
    case glenorchy = "Tasmania (glenorchy)"

    func title() -> String {
        return self.rawValue
    }
}


struct BBQListProvider {

    let area: BBQArea

    func list() -> [BBQ] {

        switch area {
        case .melbourne:
            return melbourneBBQs
        default:
            return emptyBBQs
        }
    }
}


let emptyBBQs: [BBQ] = []

