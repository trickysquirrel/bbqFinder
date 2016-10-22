//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation

struct DeleteBBQInteractor {

    let persistentStorage: BBQPersistentStorage

    func deleteBBQWithUserGeneratedKey(_ userGeneratedKey: String) {
        persistentStorage.removeBBQForKey(key: userGeneratedKey)
    }
}
