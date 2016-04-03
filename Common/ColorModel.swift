//
//  ColorModel.swift
//  Chromatic
//
//  Created by Alex Persian on 9/7/15.
//  Copyright (c) 2015 alexpersian. All rights reserved.
//

import Foundation
import UIKit

typealias didUpdateBlock = (timeString: String, hex: String, color: UIColor, nextColor: UIColor, hours: Int, minutes: Int) -> Void

class ColorModel: NSObject {
    
    var didUpdate: didUpdateBlock?
    var timer = NSTimer()

    /// The GMT offset to be applied to the time as we format our dateStrings.
    var offset = UserDefaultsManager.getTimeOffset()
    
    func startUpdates() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ColorModel.sendData as (ColorModel) -> () -> ()), userInfo: nil, repeats: true)
        self.sendData()
    }
    
    func stopUpdates() {
        timer.invalidate()
    }
    
    func timeTravelWithOffset(interval: NSTimeInterval) -> Void {
        let date: NSDate = NSDate().dateByAddingTimeInterval(interval)
        self.sendData(date)
    }
    
    func sendData() {
        let date = NSDate()
        self.sendData(date)
    }
    
    func sendData(date: NSDate) {
        guard let updateBlock = self.didUpdate else { return }

        let dateString: NSString = self.stringForDate(date)
        let hexString: NSString = self.hexStringFromDateString(dateString as String)
        let color: UIColor = self.colorFromHexString(hexString as String)
        
        let nextDateString: NSString = self.stringForDate(date.dateByAddingTimeInterval(1.0))
        let nextHexString: NSString = self.hexStringFromDateString(nextDateString as String)
        let nextColor: UIColor = self.colorFromHexString(nextHexString as String)
        
        let components: NSDateComponents = NSCalendar.currentCalendar().components([
            NSCalendarUnit.Hour,
            NSCalendarUnit.Minute
            ], fromDate: date)
        
        updateBlock(timeString: dateString as String, hex: hexString as String, color: color, nextColor: nextColor, hours: components.hour, minutes: components.minute)
    }
    
    func stringForDate(date: NSDate) -> String {
        var onceToken: dispatch_once_t = dispatch_once_t()
        var formatter: NSDateFormatter = NSDateFormatter()
        
        dispatch_once(&onceToken, {
            formatter = NSDateFormatter()
            formatter.dateFormat = "HH : mm : ss"
        })
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: offset)

        return formatter.stringFromDate(date)
    }
    
    func hexStringFromDateString(dateString: String) -> String {
        var components = dateString.componentsSeparatedByString(" : ")
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
                components[i] = components[i].stringByReplacingOccurrencesOfString(key, withString: obj)
            }
        }
        let hexString = components.joinWithSeparator(" : ")
        return "#".stringByAppendingString(hexString)
    }
    
    func colorFromHexString(hex: String) -> UIColor {
        return UIColor(rgba: hex)
    }
}
