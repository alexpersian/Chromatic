//
//  Array+Extensions.swift
//  Chromatic
//
//  Created by Alex Persian on 3/8/16.
//  Copyright © 2016 alexpersian. All rights reserved.
//

import Foundation

extension Array {
    /// Returns the value at the index if it is within bounds, otherwise `nil`.
    subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}
