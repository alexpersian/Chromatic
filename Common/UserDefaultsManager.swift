//
//  UserDefaultsManager.swift
//  Chromatic
//
//  Created by Alex Persian on 9/17/15.
//  Copyright © 2015 alexpersian. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    class var standardUserDefaults: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    class func setDefaultCity() {
        if (!(standardUserDefaults.objectForKey("currentCity") != nil)) {
            standardUserDefaults.setObject("Cupertino", forKey: "currentCity")
        }
    }
    
    class func setDefaultTimeOffset() {
        if (!(standardUserDefaults.objectForKey("timeOffset") != nil)) {
            standardUserDefaults.setObject(-25200, forKey: "timeOffset")
        }
    }
    
    class func setCurrentCity(city: String) {
        standardUserDefaults.setObject(city, forKey: "currentCity")
    }
    
    class func getCurrentCity() -> String {
        return standardUserDefaults.objectForKey("currentCity") as? String ?? "Cupertino"
    }
    
    class func setTimeOffset(offset: Int) {
        standardUserDefaults.setObject(offset, forKey: "timeOffset")
    }
    
    class func getTimeOffset() -> Int {
        return standardUserDefaults.objectForKey("timeOffset") as? Int ?? -25200
    }
    
    class func clearUserDefaults() {
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        standardUserDefaults.removePersistentDomainForName(appDomain)
    }
}
