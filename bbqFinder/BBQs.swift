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

let melbourneBBQs = [
    BBQ(title:"Barbeque - Enterprize Park", lat: -37.8202390666158, lon: 144.959910438727),
    BBQ(title:"Barbeque - Brick Single Hotplate", lat: -37.8217875175357, lon: 144.957267921996)
]