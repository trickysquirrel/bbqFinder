//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation


protocol PersistentStorage {
    func setObject(value: Any?, forKey key: String)
    func removeObjectForKey(key: String)
    func objectForKey(key: String) -> Any?
    func allObjects() -> [Any]
}


struct BBQPersistentStorage: BBQListProvider {

    let persistentStorage: PersistentStorage

    func setBBQ(value: BBQ, forKey defaultName: String) {
        let dictionary = convertBBQToDictionary(bbq: value)
        persistentStorage.setObject(value: dictionary, forKey: defaultName)
    }

    func removeBBQForKey(key defaultName: String) {
        persistentStorage.removeObjectForKey(key: defaultName)
    }

    func objectForKey(key defaultName: String) -> BBQ? {
        return persistentStorage.objectForKey(key: defaultName) as? BBQ
    }

    func allBbqs() -> [BBQ] {
        return persistentStorage.allObjects().flatMap{ convertObjectToBBQ($0) }
    }
}

// Conversion

extension BBQPersistentStorage {

    private struct Keys {
        static let title = "title"
        static let facilities = "facilities"
        static let lat = "lat"
        static let lon = "lon"
        static let address = "address"
        static let userGeneratedKey = "userGeneratedKey"
    }


    fileprivate func convertBBQToDictionary(bbq: BBQ) -> [String:Any] {
        return [Keys.title: bbq.title,
                Keys.facilities: bbq.facilities,
                Keys.lat: bbq.lat,
                Keys.lon: bbq.lon,
                Keys.address: bbq.address,
                Keys.userGeneratedKey: bbq.userGeneratedKey
        ]
    }
    

    fileprivate func convertObjectToBBQ(_ object: Any) -> BBQ? {

        guard let dictionary = object as? [String:Any] else { return nil }
        guard let title = dictionary[string: Keys.title] else { return nil }
        guard let facilities = dictionary[string: Keys.facilities] else { return nil }
        guard let lat = dictionary[double: Keys.lat] else { return nil }
        guard let lon = dictionary[double: Keys.lon] else { return nil }
        guard let address = dictionary[string: Keys.address] else { return nil }
        guard let userGenerated = dictionary[string: Keys.userGeneratedKey] else { return nil }

        return BBQ(title: title, facilities: facilities, lat: lat, lon: lon, address: address, userGeneratedKey: userGenerated)
    }
}
