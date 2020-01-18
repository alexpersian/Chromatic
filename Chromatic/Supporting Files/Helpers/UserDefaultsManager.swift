//
//  UserDefaultsManager.swift
//  Chromatic
//
//  Created by Alex Persian on 9/17/15.
//  Copyright © 2015 alexpersian. All rights reserved.
//

import Foundation

final class UserDefaultsManager {
    private struct Constants {
        static let currentCity = "currentCity"
        static let timeOffset = "timeOffset"
        static let defaultCity = "Cupertino"
        static let defaultTimeOffset = -25200
    }

    class var standardUserDefaults: UserDefaults {
        return UserDefaults.standard
    }

    class func setDefaultCity() {
        if (!(standardUserDefaults.object(forKey: Constants.currentCity) != nil)) {
            standardUserDefaults.set(Constants.defaultCity, forKey: Constants.currentCity)
        }
    }

    class func setDefaultTimeOffset() {
        if (!(standardUserDefaults.object(forKey: Constants.timeOffset) != nil)) {
            standardUserDefaults.set(-25200, forKey: Constants.timeOffset)
        }
    }

    class func setCurrentCity(_ city: String) {
        standardUserDefaults.set(city, forKey: Constants.currentCity)
    }

    class func getCurrentCity() -> String {
        return standardUserDefaults.object(forKey: Constants.currentCity) as? String ?? Constants.defaultCity
    }

    class func setTimeOffset(_ offset: Int) {
        standardUserDefaults.set(offset, forKey: Constants.timeOffset)
    }

    class func getTimeOffset() -> Int {
        return standardUserDefaults.object(forKey: Constants.timeOffset) as? Int ?? Constants.defaultTimeOffset
    }

    class func clearUserDefaults() {
        let appDomain = Bundle.main.bundleIdentifier!
        standardUserDefaults.removePersistentDomain(forName: appDomain)
    }
}
