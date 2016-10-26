//
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Foundation
//import FirebaseRemoteConfig





class BBQFinderConfiguration: ABConfiguration {

    let expirationDuration = 43200
    //let remoteConfig: FIRRemoteConfig


    init() {
        //FIRApp.configure()
        //self.remoteConfig = FIRRemoteConfig.remoteConfig()

        // todo remove this
        // allows for frequent refreshes of the cache
        //let remoteConfigSettings = FIRRemoteConfigSettings(developerModeEnabled: true)
        //remoteConfig.configSettings = remoteConfigSettings!
        //setDetaultConfigurations()
        //fetchRemoteConfiguration()
    }


    func isFlagForDetailsPopeverOn() -> Bool {

//        if let flag = remoteConfig["map_details_popover"].stringValue {
//            return flag == "true" ? true : false
//        }
        return false
    }

    // MARK: Helpers

    private func setDetaultConfigurations() {
        //remoteConfig.setDefaults(["map_details_popover": "false" as NSObject])
    }


    private func fetchRemoteConfiguration() {

//        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
//            if (status == FIRRemoteConfigFetchStatus.success) {
//                print("Config fetched!")
//                self.remoteConfig.activateFetched()
//            } else {
//                print("Config not fetched")
//                print("Error \(error!.localizedDescription)")
//            }
//        }
    }
}
