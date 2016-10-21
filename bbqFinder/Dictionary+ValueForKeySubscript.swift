//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


extension Dictionary where Key:ExpressibleByStringLiteral, Value:Any {


    subscript (string key: String) -> String? {

        guard let string = self[key as! Key] as? String else { return nil }
        return string
    }


    subscript (int key: String) -> Int? {

        guard let integer = self[key as! Key] as? Int else { return nil }
        return integer
    }


    subscript (double key: String) -> Double? {

        guard let double = self[key as! Key] as? Double else { return nil }
        return double
    }

}
