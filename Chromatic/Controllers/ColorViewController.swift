//
//  ViewController.swift
//  Chromatic
//
//  Created by Alex Persian on 9/6/15.
//  Copyright (c) 2015 alexpersian. All rights reserved.
//

import UIKit
import SwiftyTimer

class ColorViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var hexLabel: UILabel!
    
    private var model: ColorModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.model = ColorModel()
        self.bindToModel()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true

        // update the offset and city label in case they were changed elsewhere
        self.model?.offset = UserDefaultsManager.getTimeOffset()
        self.cityLabel.text = UserDefaultsManager.getCurrentCity()

        self.model?.startUpdates()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.model?.stopUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Model
    func bindToModel() {
        self.model?.didUpdate = self.modelDidUpdate
    }
    
    func modelDidUpdate(dateString: String, hexString: String, color: UIColor, nextColor: UIColor, hour: Int, minutes: Int) {
        self.timeLabel.text = dateString
        self.hexLabel.text = hexString
        lerpBackgroundColor(color, fColor: nextColor, step: 0.05)
    }
    
    func lerpBackgroundColor(cColor: UIColor, fColor: UIColor, step: CGFloat) {
        var progress: CGFloat = 0.0

        NSTimer.every(Double(step)) {
            if (progress <= 1.0) {
                self.view.backgroundColor = cColor.lerp(cColor, finalColor: fColor, progress: progress)
                progress += step
            } else {
                return
            }
        }
    }
}
