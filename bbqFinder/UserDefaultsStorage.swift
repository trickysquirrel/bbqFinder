//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


struct UserDefaultsStorage: PersistentStorage {

    let userDefaults = UserDefaults.standard

    func setObject(value: Any?, forKey defaultName: String) {
        userDefaults.set(value, forKey: defaultName)
        userDefaults.synchronize()
    }

    func removeObjectForKey(key defaultName: String) {
        userDefaults.removeObject(forKey: defaultName)
        userDefaults.synchronize()
    }

    func objectForKey(key defaultName: String) -> Any? {
        return userDefaults.object(forKey: defaultName) as AnyObject?
    }

    func allObjects() -> [Any] {
        return userDefaults.dictionaryRepresentation().map{ (key,value) in value }
    }
}
