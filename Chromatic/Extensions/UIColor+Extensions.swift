//
//  UIColor+Extensions.swift
//  Chromatic
//
//  Created by Alex Persian on 9/7/15.
//  Copyright (c) 2015 alexpersian. All rights reserved.
//

import UIKit

// Thanks to yeahdongcn from Github.
// https://github.com/yeahdongcn/UIColor-Hex-Swift/blob/master/UIColorExtension.swift
// Slight modifications made to format the incoming strings.

extension UIColor {

    /// Creates a `UIColor` based on a passed in hex format `String`. Ensure that
    /// provided string is prefixed with a `#`.
    /// - Note: Example: Passing in "#FF0000" will return `UIColor.red`.
    convenience init(hex: String) {
        let hexString = hex.replacingOccurrences(of: ":", with: "")

        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0

        if hexString.hasPrefix("#") {
            let index   = hex.index(hex.startIndex, offsetBy: 1)
            let hex     = String(hexString[index...])
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                switch (hex.count) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
                }
            } else {
                print("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }

    /// Performs a linear interpolation between two `UIColor`s.
    /// - Parameters:
    ///     - currentColor: The starting `UIColor`.
    ///     - finalColor: The ending `UIColor`.
    ///     - progress: `CGFloat` between 0.0 and 1.0 indicating the progress of the interpolation.
    ///
    /// - Note: Rather than performing a timed transition itself, this function simply
    ///         produces a new `UIColor` between the starting and final colors based on the
    ///         progress value passed in. This should be used within an external timing block
    ///         to regulate how fast the interpolation should occur.
    func lerp(_ currentColor: UIColor, finalColor: UIColor, progress: CGFloat) -> UIColor {
        let c1 = currentColor.cgColor.components
        let c2 = finalColor.cgColor.components

        let r: CGFloat = ((1.0 - progress) * c1![0]) + (progress * c2![0])
        let g: CGFloat = ((1.0 - progress) * c1![1]) + (progress * c2![1])
        let b: CGFloat = ((1.0 - progress) * c1![2]) + (progress * c2![2])
        let a: CGFloat = ((1.0 - progress) * c1![3]) + (progress * c2![3])

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
