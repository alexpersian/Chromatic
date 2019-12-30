//
//  SettingsVC+GoogleHandler.swift
//  Chromatic
//
//  Created by Alex Persian on 2/13/16.
//  Copyright © 2016 alexpersian. All rights reserved.
//

import Alamofire

extension SettingsViewController {
    
    func requestGeocodingFromGoogle(_ address: String) {
        guard
            let googleAPIKey = data["Google API Key"],
            let requestURL = URL(string: "https://maps.googleapis.com/maps/api/geocode/json")
            else { return }
        
        let params = [
            "address": address,
            "key": googleAPIKey
        ]

        Alamofire.request(requestURL, method: .get, parameters: params)
            .responseData { response in
                let result: Result<GMPlaceResult> = JSONDecoder().decodeResponse(from: response)
                switch result {
                case .success(let results):
                    print(results)
                    if let place = results.places.first {
                        let coordinates = place.geometry.location
                        self.requestTimeZoneFromGoogle("\(coordinates.lat), \(coordinates.lon)", address: address)
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    private func requestTimeZoneFromGoogle(_ location: String, address: String) {
        guard
            let googleAPIKey = data["Google API Key"],
            let requestURL = URL(string: "https://maps.googleapis.com/maps/api/timezone/json")
            else { return }
        
        let params = [
            "location": location,
            "timestamp": "\(Date().timeIntervalSince1970)",
            "key": googleAPIKey
        ]

        Alamofire.request(requestURL, method: .get, parameters: params)
            .responseData { response in
                let result: Result<GMTimeZone> = JSONDecoder().decodeResponse(from: response)
                switch result {
                case .success(let timeZone):
                    let city = address.components(separatedBy: ",")[0]
                    let totalOffset = timeZone.rawOffset + timeZone.dstOffset
                    self.updateLocationData(city, offset: totalOffset)
                case .failure(let error):
                    print(error)
                }
        }
    }
}
