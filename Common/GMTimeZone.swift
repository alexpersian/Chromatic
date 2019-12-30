//
//  GMTimeZone.swift
//  Chromatic
//
//  Created by Alex Persian on 12/30/19.
//  Copyright © 2019 alexpersian. All rights reserved.
//

import Foundation

struct GMTimeZone: Codable {
    let dstOffset: Int
    let rawOffset: Int
    let status: String
    let timeZoneId: String
    let timeZoneName: String
}
