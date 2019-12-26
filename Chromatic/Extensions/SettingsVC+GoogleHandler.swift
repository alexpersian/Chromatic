//
//  SettingsVC+GoogleHandler.swift
//  Chromatic
//
//  Created by Alex Persian on 2/13/16.
//  Copyright © 2016 alexpersian. All rights reserved.
//

import Foundation
import Alamofire

extension SettingsViewController {
    
    func requestGeocodingFromGoogle(_ address: String) {
        guard let googleAPIKey = data["Google API Key"] else { return }
        
        let _ = [
            "address": address,
            "key": googleAPIKey
        ]

//        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/geocode/json", parameters: params)
//            .responseJSON { response in
//                switch response.result {
//                case .Success(let value):
//                    do {
//                        guard let location = value.objectForKey("results")?
//                            .objectAtIndex(0)
//                            .objectForKey("geometry")?
//                            .objectForKey("location") else {
//                                print("Error: failed to parse location from JSON data")
//                                return
//                        }
//
//                        guard let lat = location.objectForKey("lat") else { return }
//                        guard let lng = location.objectForKey("lng") else { return }
//
//                        self.requestTimeZoneFromGoogle("\(lat), \(lng)", address: address)
//                    }
//                case .Failure(let error):
//                    print("Networking Error: \(error)")
//                }
//        }
    }
    
    func requestTimeZoneFromGoogle(_ location: String, address: String) {
        guard let googleAPIKey = data["Google API Key"] else { return }
        
        let _ = [
            "location": location,
            "timestamp": "\(Date().timeIntervalSince1970)",
            "key": googleAPIKey
        ]
        
//        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/timezone/json", parameters: params)
//            .responseJSON { response in
//                switch response.result {
//                case .Success(let value):
//                    do {
//                        guard let dstOffset = value.objectForKey("dstOffset") as? Int else {
//                            print("Error parsing DST offset")
//                            return
//                        }
//                        guard let offset = value.objectForKey("rawOffset") as? Int else {
//                            print("Error parsing raw offset")
//                            return
//                        }
//                        let city = address.componentsSeparatedByString(",")[0]
//                        let totalOffset = offset + dstOffset
//                        self.updateLocationData(city, offset: totalOffset)
//                        self.placesTextField.backgroundColor = self.placesTextField.successBackgroundColor
//                        if self.activitySpinner.isAnimating() { self.activitySpinner.stopAnimating() }
//                    }
//                case .Failure(let error):
//                    print("Networking Error: \(error)")
//                    self.placesTextField.backgroundColor = self.placesTextField.failureBackgroundColor
//                    if self.activitySpinner.isAnimating() { self.activitySpinner.stopAnimating() }
//                }
//        }
    }
}
