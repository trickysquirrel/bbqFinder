//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation

enum BBQArea: String {

    case alpineShire = "AlpineShire"
    case ballarat = "Ballarat"
    case glenorchy = "Glenorchy"
    case melbourne = "Melbourne"

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