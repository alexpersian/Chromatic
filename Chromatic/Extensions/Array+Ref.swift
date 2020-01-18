//
//  Array+Ref.swift
//  Chromatic
//
//  Created by Alex Persian on 3/8/16.
//  Copyright © 2016 alexpersian. All rights reserved.
//

import Foundation

extension Array {
    // TODO: Rename or document this to better indicate that it
    // is a safe index accessor for an array.
    func ref (_ i: Int) -> Element? {
        return 0 <= i && i < count ? self[i] : nil
    }
}
