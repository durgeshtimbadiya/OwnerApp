//
//  GlobalUiVIew.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import Foundation
import UIKit

class redVIew: UIView {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_Red
    }
}

class LightGrayVIew: UIView {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_LightGrey
    }
}

class blackVIew: UIView {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_Black
    }
}

class blueVIew: UIView {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_TopHeader
    }
}

class YellowVIew: UIView {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_TopHeader
    }
}

class creamView: UIView {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_Cream
    }
}

class greenVIew: UIView {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_LightGreenButtonBG
    }
}

class orangeVIew: UIView {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_OrangeButtonBG
    }
}

class SkyBlueView: UIView {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_SkyBlueTitle
    }
}

class CardView: UIView {
    @IBInspectable var cornerradious: CGFloat = 4
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 1
    @IBInspectable var shadowColor: UIColor? = UIColor.gray
    @IBInspectable var shadowOpacity: Float = 0.5

    override func layoutSubviews() {
        layer.cornerRadius = cornerradious
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerradious)

        layer.masksToBounds = false

        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}
