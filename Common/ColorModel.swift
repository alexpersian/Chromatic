//
//  ColorModel.swift
//  Chromatic
//
//  Created by Alex Persian on 9/7/15.
//  Copyright (c) 2015 alexpersian. All rights reserved.
//

import Foundation
import UIKit

typealias didUpdateBlock = (_ timeString: String, _ hex: String, _ color: UIColor, _ nextColor: UIColor, _ hours: Int, _ minutes: Int) -> Void

final class ColorModel: NSObject {

    private var timer = Timer()
    private lazy var formatter: DateFormatter = {
        let fmt: DateFormatter = DateFormatter()
        fmt.dateFormat = "HH:mm:ss"
        return fmt
    }()

    /// The GMT offset to be applied to the time as we format our dateStrings.
    var offset = UserDefaultsManager.getTimeOffset()
    var didUpdate: didUpdateBlock?

    // MARK: Public Interface

    func startUpdates() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ColorModel.sendData as (ColorModel) -> () -> ()), userInfo: nil, repeats: true)
        self.sendData()
    }
    
    func stopUpdates() {
        timer.invalidate() // TODO: Modify to be thread-safe
    }

    // MARK: Private Interface
    
    private func timeTravelWithOffset(_ interval: TimeInterval) -> Void {
        let date: Date = Date().addingTimeInterval(interval)
        self.sendData(date)
    }

    @objc private func sendData() {
        let date = Date()
        self.sendData(date)
    }
    
    private func sendData(_ date: Date) {
        guard let updateBlock = self.didUpdate else { return }

        let dateString: NSString = self.stringForDate(date) as NSString
        let hexString: NSString = self.hexStringFromDateString(dateString as String) as NSString
        let color: UIColor = self.colorFromHexString(hexString as String)
        
        let nextDateString: NSString = self.stringForDate(date.addingTimeInterval(1.0)) as NSString
        let nextHexString: NSString = self.hexStringFromDateString(nextDateString as String) as NSString
        let nextColor: UIColor = self.colorFromHexString(nextHexString as String)
        
        let components: DateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        updateBlock(dateString as String, hexString as String, color, nextColor, components.hour!, components.minute!)
    }
    
    private func stringForDate(_ date: Date) -> String {
        formatter.timeZone = TimeZone(secondsFromGMT: offset)
        return formatter.string(from: date)
    }
    
    private func hexStringFromDateString(_ dateString: String) -> String {
        var components = dateString.components(separatedBy: " : ")
        let changes: [String: String] = [
            "1" : "A",
            "2" : "B",
            "3" : "C",
            "4" : "D",
            "5" : "E",
            "6" : "F"
        ]
        for i in 0..<components.count {
            for (key, obj) in changes {
                components[i] = components[i].replacingOccurrences(of: key, with: obj)
            }
        }
        let hexString = components.joined(separator: " : ")
        return "#" + hexString
    }
    
    private func colorFromHexString(_ hex: String) -> UIColor {
        return UIColor(rgba: hex)
    }
}
