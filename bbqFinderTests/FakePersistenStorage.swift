//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit
@testable import bbqFinder


class FakePersistenStorage: PersistentStorage {

    var dictionaryStorage = [String:Any]()

    func setObject(value: Any?, forKey key: String) {
        dictionaryStorage[key] = value
    }

    func removeObjectForKey(key: String) {
        dictionaryStorage.removeValue(forKey: key)
    }

    func objectForKey(key: String) -> Any? {
        return dictionaryStorage[key]
    }

    func allObjects() -> [Any] {
        return dictionaryStorage.map{ (key,value) in value }
    }
}
