//
//  GMPlace.swift
//  Chromatic
//
//  Created by Alex Persian on 12/30/19.
//  Copyright © 2019 alexpersian. All rights reserved.
//

import Foundation

struct GMPlaceResult: Codable {
    private enum CodingKeys: String, CodingKey {
        case places = "results"
    }
    let places: [GMPlace]
}

/// Codable wrapper for a Google Maps Place
struct GMPlace: Codable {
    private enum CodingKeys: String, CodingKey {
        case placeID = "place_id"
        case formattedAddress = "formatted_address"
        case addressComponents = "address_components"
        case geometry = "geometry"
        case types = "types"
    }

    let placeID: String
    let formattedAddress: String
    let addressComponents: [GMComponent]
    let geometry: GMPlaceGeometry
    let types: [String]
}

struct GMComponent: Codable {
    private enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types = "types"
    }

    let longName: String
    let shortName: String
    let types: [String]
}

struct GMPlaceGeometry: Codable {
    private enum CodingKeys: String, CodingKey {
        case location = "location"
        case locationType = "location_type"
        case bounds = "bounds"
        case viewport = "viewport"
    }

    let location: GMCoordinate
    let locationType: String
    let bounds: GMCoordinateBounds
    let viewport: GMCoordinateBounds
}

struct GMCoordinateBounds: Codable {
    private enum CodingKeys: String, CodingKey {
        case northEast = "northeast"
        case southWest = "southwest"
    }
    let northEast: GMCoordinate
    let southWest: GMCoordinate
}

struct GMCoordinate: Codable {
    private enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lon = "lng"
    }

    let lat: Float
    let lon: Float
}
