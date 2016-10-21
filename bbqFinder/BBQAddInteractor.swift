//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import UIKit


protocol BBQAddInteractorOutput {
    func interactorUpdatedStoredBBQs(bbqs: [BBQ])
}


final class BBQAddInteractor: NSObject {

    let bbqStorage: BBQPersistentStorage
    let output: BBQAddInteractorOutput
    let defaultTitle = "bbq"
    let defaultFacilities = ""


    required init(bbqStorage: BBQPersistentStorage, output: BBQAddInteractorOutput) {

        self.bbqStorage = bbqStorage
        self.output = output
    }


    func addNewCoordinate(latitude: Double, longitude: Double) {

        let key = String(Date().timeIntervalSince1970)

        let bbq = BBQ(title: defaultTitle,
                      facilities: defaultFacilities,
                      lat: latitude,
                      lon: longitude,
                      userGenerated: true)

        bbqStorage.setBBQ(value: bbq, forKey: key)

        let allBbqs = bbqStorage.allBbqs()
        output.interactorUpdatedStoredBBQs(bbqs: allBbqs)
    }
}
