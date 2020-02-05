//
//  ViewController.swift
//  Chromatic
//
//  Created by Alex Persian on 9/6/15.
//  Copyright (c) 2015 alexpersian. All rights reserved.
//

import UIKit
import SwiftyTimer

final class ColorViewController: UIViewController, ColorViewDelegate {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var hexLabel: UILabel!

    // Lazy declaration here allows us to pass `self` along as delegate on init
    // while avoiding exposure of  the `bindToModel` function on the VM.
    private lazy var viewModel: ColorViewModel = {
        return ColorViewModel(delegate: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true

        // Update the offset and city label in case they were changed elsewhere
        viewModel.updateTimeOffset(UserDefaultsManager.getTimeOffset())
        cityLabel.text = UserDefaultsManager.getCurrentCity()
        // Restart the model updates when we return to this view
        viewModel.startUpdates()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop model updates when we navigate away as there's no need for background updates
        viewModel.stopUpdates()
    }

    // MARK: Color Updates

    private func lerpBackgroundColor(_ cColor: UIColor, fColor: UIColor, step: CGFloat) {
        var progress: CGFloat = 0.0
        Timer.every(Double(step)) { [weak self] in
            guard progress <= 1.0 else { return }
            self?.view.backgroundColor = cColor.lerp(cColor, finalColor: fColor, progress: progress)
            progress += step
        }
    }

    func modelDidUpdate(_ dateString: String, _ hexString: String, _ color: UIColor, _ nextColor: UIColor, _ hour: Int, _ minutes: Int) {
        timeLabel.text = dateString
        hexLabel.text = hexString
        lerpBackgroundColor(color, fColor: nextColor, step: 0.05)
    }
}
