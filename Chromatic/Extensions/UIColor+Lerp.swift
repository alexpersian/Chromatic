//
//  UIColor+Lerp.swift
//  Chromatic
//
//  Created by Alex Persian on 2/22/16.
//  Copyright © 2016 alexpersian. All rights reserved.
//

import UIKit

extension UIColor {

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
