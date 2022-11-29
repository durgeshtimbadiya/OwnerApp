//
//  ColorExts.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import UIKit

extension UIColor {
    class var appDefaultColor: UIColor {
        return UIColor(hex: "082240")
    }

    class var appSecondColor: UIColor {
        return UIColor(hex: "1E3A46")
    }

    class var screenTitleColor: UIColor {
        return UIColor.white
    }

    class var lightGrayColor: UIColor {
        return UIColor(hex: "E5E5EE")
    }

    /// color with hex code
    convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {}

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        let alpha = CGFloat(1.0)

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
