//
//  SettingsVC+DataSource.swift
//  Chromatic
//
//  Created by Alex Persian on 9/21/15.
//  Copyright © 2015 alexpersian. All rights reserved.
//

import Foundation
import UIKit

extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CityList.cities.count
    }
}
