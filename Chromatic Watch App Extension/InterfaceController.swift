//
//  InterfaceController.swift
//  Chromatic Watch App Extension
//
//  Created by Alex Persian on 10/8/15.
//  Copyright © 2015 alexpersian. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var hexLabel: WKInterfaceLabel!
    @IBOutlet var colorImage: WKInterfaceImage!
    
    private var model: ColorModel?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.model = ColorModel()
        self.bindToModel()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.model?.startUpdates()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        self.model?.stopUpdates()
    }

    // MARK: Model
    func bindToModel() {
        self.model?.didUpdate = self.modelDidUpdate
    }
    
    func modelDidUpdate(dateString: String, hexString: String, color: UIColor, hour: Int, minutes: Int) {
        self.hexLabel.setText(hexString)
        self.colorImage.setTintColor(color)
    }
}
