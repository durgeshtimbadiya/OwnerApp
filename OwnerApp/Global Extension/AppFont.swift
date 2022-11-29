//
//  AppFont.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import UIKit

enum AppFont {
    case helvetica, other

    private var famailyName: String {
        switch self {
        case .helvetica:
            return "Helvetica"
        case .other:
            return ""
        }
    }

    enum Weight: String {
        case regular = "Regular", bold = "Bold", medium = "Medium", semibold = "SemiBold", light = "Light"
    }

    func with(weight: Weight, size: CGFloat) -> UIFont? {
        let fontFamaily = famailyName + "-" + weight.rawValue
        if let font = UIFont(name: fontFamaily, size: size) {
            return font
        }
        return UIFont(name: famailyName, size: size)
    }
}
