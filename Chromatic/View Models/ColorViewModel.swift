//
//  ColorViewModel.swift
//  Chromatic
//
//  Created by Alex Persian on 1/18/20.
//  Copyright © 2020 alexpersian. All rights reserved.
//

import UIKit

protocol ColorViewDelegate: AnyObject {
    func modelDidUpdate(_ dateString: String, _ hexString: String, _ color: UIColor, _ nextColor: UIColor, _ hour: Int, _ minutes: Int)
}

final class ColorViewModel {

    private weak var delegate: ColorViewDelegate?
    private let model = ColorModel()

    init(delegate: ColorViewDelegate) {
        self.delegate = delegate
        bindToModel()
    }

    private func bindToModel() {
        model.didUpdate = delegate?.modelDidUpdate
    }

    func updateTimeOffset(_ newOffset: Int) {
        model.offset = newOffset
    }

    func startUpdates() {
        model.startUpdates()
    }

    func stopUpdates() {
        model.stopUpdates()
    }
}
