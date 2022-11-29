//
//  UIViewExtensions.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
//            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }

    @IBInspectable var setShadowColor: UIColor? {
        set {
            layer.shadowColor = (newValue?.cgColor)!
            layer.shadowOffset = CGSize(width: -1.0, height: 2.0)
            layer.shadowRadius = 4.0
            layer.shadowOpacity = 0.4
            layer.masksToBounds = false
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }

    @IBInspectable var setShadowColorForTab: UIColor? {
        set {
            layer.shadowColor = (newValue?.cgColor)!
            layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            layer.shadowRadius = 10.0
            layer.shadowOpacity = 0.4
            layer.masksToBounds = false
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }

    func round(corners: UIRectCorner, cornerRadius: Double) {
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let bezierPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: size)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = bezierPath.cgPath
        layer.mask = shapeLayer
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }

    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }

    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }

    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }

    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }

    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }

    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }

    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date) > 0 { return "\(years(from: date))y" }
        if months(from: date) > 0 { return "\(months(from: date))M" }
        if weeks(from: date) > 0 { return "\(weeks(from: date))w" }
        if days(from: date) > 0 { return "\(days(from: date))d" }
        if hours(from: date) > 0 { return "\(hours(from: date))h" }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

extension TimeInterval {
    var minuteSecondMS: String {
        return String(format: "0%d:%02d", minute, second)
    }

    var minute: Int {
        return Int((self / 60).truncatingRemainder(dividingBy: 60))
    }

    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }

    var millisecond: Int {
        return Int((self * 1000).truncatingRemainder(dividingBy: 1000))
    }
}

extension Double {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}

extension String {
    func checkValidMobileNumber() -> String {
        let first4 = prefix(4)

        if first4 == "+966" {
            return self
        } else {
            return "+966\(self)"
        }
    }

    func strikeThrough() -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        if isEmpty {
            return 0
        }

        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.width)
    }
}

extension UILabel {
    func setHTMLFromString(text: String) {
        // let modifiedFont = NSString(format:"<span style=\"font-family: \(self.font!.fontName); font-size: \(self.font!.pointSize)\">%@</span>" as NSString, text)
        let modifiedFont = NSString(format: "%@", text)

        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        )

        attributedText = attrStr
    }
}

// @available(iOS 13.0, *)
// @available(iOS 13.0, *)
extension UIViewController {
    @IBAction func popToviewcontroller(sender _: UIButton) {
        navigationController?.popViewController(animated: true)
    }

//    @IBAction func ClickonHome(sender : UIButton) {
//        let vc = UIStoryboard.init(name: StoryBoard.StoryBoardMain, bundle: nil).instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
//               vc.modalPresentationStyle = .fullScreen
//               self.present(vc, animated: false, completion: {
//               })
//      //  UIStoryboard.setHomeAsRootView()
//    }
//

//    @IBAction func DashboardClickonHome(sender : UIButton) {
//
//        let vc = UIStoryboard.init(name: StoryBoard.StoryBoardMain, bundle: nil).instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: false, completion: {
//        })
//          // UIStoryboard.setHomeAsRootView()
//       }
//

//    @IBAction func ClickonUser(sender : UIButton) {
//        UIStoryboard.SetUserView()
//    }
}

// MARK: - ALl Image view global classes

class fn_TopHeaderImageview: UIImageView {
    override func awakeFromNib() {
        image = image?.setTintColor(color: AppColor.Color_TopHeader) // withTintColor(AppColor.Color_TopHeader)
    }
}

class fn_REDImageview: UIImageView {
    override func awakeFromNib() {
        image = image?.setTintColor(color: AppColor.Color_Red) // withTintColor(AppColor.Color_Red)
    }
}

extension UIView {
    private static let kRotationAnimationKey = "rotationanimationkey"

    func rotate(duration: Double = 1) {
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity

            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }

    func stopRotating() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }

    // MARK: - Gradient Colour Of Button

    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}

extension UIView {
    func dropShadowWithCornerRadius(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 3
        layer.cornerRadius = 10
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
