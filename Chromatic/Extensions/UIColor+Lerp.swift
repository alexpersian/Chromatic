//
//  UIColor+Lerp.swift
//  Chromatic
//
//  Created by Alex Persian on 2/22/16.
//  Copyright © 2016 alexpersian. All rights reserved.
//

import Foundation

extension UIColor {

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
