//
//  UserDefaultsManager.swift
//  Chromatic
//
//  Created by Alex Persian on 9/17/15.
//  Copyright © 2015 alexpersian. All rights reserved.
//

import Foundation

final class UserDefaultsManager {
    class var standardUserDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    class func setDefaultCity() {
        if (!(standardUserDefaults.object(forKey: "currentCity") != nil)) {
            standardUserDefaults.set("Cupertino", forKey: "currentCity")
        }
    }
    
    class func setDefaultTimeOffset() {
        if (!(standardUserDefaults.object(forKey: "timeOffset") != nil)) {
            standardUserDefaults.set(-25200, forKey: "timeOffset")
        }
    }
    
    class func setCurrentCity(_ city: String) {
        standardUserDefaults.set(city, forKey: "currentCity")
    }
    
    class func getCurrentCity() -> String {
        return standardUserDefaults.object(forKey: "currentCity") as? String ?? "Cupertino"
    }
    
    class func setTimeOffset(_ offset: Int) {
        standardUserDefaults.set(offset, forKey: "timeOffset")
    }
    
    class func getTimeOffset() -> Int {
        return standardUserDefaults.object(forKey: "timeOffset") as? Int ?? -25200
    }
    
    class func clearUserDefaults() {
        let appDomain = Bundle.main.bundleIdentifier!
        standardUserDefaults.removePersistentDomain(forName: appDomain)
    }
}
