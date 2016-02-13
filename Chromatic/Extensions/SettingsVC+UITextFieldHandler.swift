//
//  SettingsVC+UITextFieldDelegate.swift
//  Chromatic
//
//  Created by Alex Persian on 2/13/16.
//  Copyright © 2016 alexpersian. All rights reserved.
//

import Foundation
import UIKit

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.placesTextField) {
            textField.resignFirstResponder()
            self.findNewCity()
        }
        return true
    }
}
