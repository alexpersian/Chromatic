//
//  Dictionary+PList.swift
//  Chromatic
//
//  Created by Alex Persian on 4/3/16.
//  Copyright © 2016 alexpersian. All rights reserved.
//

import Foundation

extension Dictionary {
    // Thanks to Ian Keen for the help with this great function
    static func fromPlist(_ named: String) -> [Key : Value] {
        guard
            let pList = Bundle.main.path(forResource: named, ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: pList)
        else { return [:] }

        var result = [Key : Value]()
        dict.forEach { (key, value) in
            if let key = key as? Key, let value = value as? Value {
                result[key] = value
            }
        }
        return result
    }
}
