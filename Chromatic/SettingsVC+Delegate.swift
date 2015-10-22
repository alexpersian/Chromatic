//
//  SettingsVC+Delegate.swift
//  Chromatic
//
//  Created by Alex Persian on 9/23/15.
//  Copyright © 2015 alexpersian. All rights reserved.
//

import Foundation
import UIKit

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newCity = cityArray[row]
        newOffset = (offsetArray[row] * 3600)
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (row == 0) {
            newCity = cityArray[row]
            newOffset = (offsetArray[row] * 3600)
        }
        return cityArray[row]
    }
}
