//
//  SwiftExtensions.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import UIKit

public extension UserDefaults {
    enum Keys {
        static let UserDetails = "userDetails"
        static let UserLoginAccessDetails = "userLoginAccessDetails"
        static let EcommerceUserQuoteID = "EcommerceUserQuoteID"
        static let EcommerceUserCartItems = "EcommerceUserCartItems"
        static let EcommerceAccessToken = "EcommerceAccessToken"
        static let UserEmail = "userEmail"
        static let UserPassword = "userPassword"
        static let UserRememberMe = "userRememberMe"
        static let UserOffLineData = "UserOffLineData"
        static let ShowAccountTypeStatus = "ShowAccountTypeStatus"
        static let ShowFollowingUserStatus = "ShowFollowingUserStatus"
        static let ShowProfileVideoStatus = "ShowProfileVideoStatus"
        static let SuggestAccountToOthersStatus = "SuggestAccountToOthersStatus"
    }
}

// MARK: - Date

extension Date {
    func daySuffix() -> String {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: self)
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
}

// MARK: - Data

extension Data {
    func decode<T>(type: T.Type) -> T? where T: Decodable {
        do {
            return try JSONDecoder().decode(type, from: self)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func asJson() -> Any? {
        do {
            let obj = try JSONSerialization.jsonObject(with: self, options: .mutableContainers)
            return obj
        } catch {
            print("JsonSerialization error : \(error.localizedDescription)")
            return nil
        }
    }
}

// MARK: - Dictionary

extension Dictionary {
    var data: Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return data
        } catch {
            print("Dictionary to Data casting error : \(error.localizedDescription)")
            return nil
        }
    }

    func decode<T>(type: T.Type) -> T? where T: Decodable {
        do {
            if let data = data {
                return try JSONDecoder().decode(type, from: data)
            }
            return nil
        } catch {
            print(error)
            return nil
        }
    }
}

// MARK: - Double

extension Double {
    func removeTrailingZero() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}

// MARK: - Bundle

extension Bundle {
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}

// MARK: - TypeCasting

protocol TypeCasting {
    var asString: String { get }
    var asInt: Int { get }
    var asFloat: Float { get }
    var asDouble: Double { get }
    var asDecimalString: String { get }
    // var isZero: Bool { get }
}

extension TypeCasting {
    var asString: String {
        return "\(self)"
    }

    var asInt: Int {
        var value = 0

        if self is String {
            value = Int(Float(self as! String) ?? 0)
        } else if self is NSNumber {
            value = (self as! NSNumber).intValue
        }
        return value
    }

    var asFloat: Float {
        var value: Float = 0.0

        if self is String {
            value = Float(self as! String) ?? 0
        } else if self is NSNumber {
            value = (self as! NSNumber).floatValue
        }
        return value
    }

    var asDouble: Double {
        var value = 0.0

        if self is String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal

            if let number = formatter.number(from: self as! String) {
                return number.doubleValue
            }

            value = Double(self as! String) ?? 0

        } else if self is NSNumber {
            value = (self as! NSNumber).doubleValue
        }
        return value
    }

    var asDecimalString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if self is String {
            if let number = formatter.number(from: self as! String) {
                return number.stringValue
            } else {
                return "0"
            }

        } else if self is NSNumber {
            let number = (self as! NSNumber)
            return formatter.string(from: number) ?? "0"
        }
        return "0"
    }
}

extension String: TypeCasting {}
extension Int: TypeCasting {}
extension Double: TypeCasting {}
extension Float: TypeCasting {}
extension CGFloat: TypeCasting {}

// MARK: - UIDevice

extension UIDevice {
    enum DeviceType {
        case iPhone35
        case iPhone40
        case iPhone47
        case iPhone55
        case iPhoneX
        case iPhoneMax
        case iPad
        case TV
        case carPlay
        case unspecified

        var isPhone: Bool {
            return [.iPhone35, .iPhone40, .iPhone47, .iPhone55, .iPhoneMax].contains(self)
        }
    }

    var deviceType: DeviceType {
        switch UIDevice.current.userInterfaceIdiom {
        case .tv:
            return .TV

        case .pad:
            return .iPad

        case .mac:
            return .iPhoneMax
        case .phone:
            let screenSize = UIScreen.main.bounds.size
            let height = max(screenSize.width, screenSize.height)

            switch height {
            case 480:
                return .iPhone35
            case 568:
                return .iPhone40
            case 667:
                return .iPhone47
            case 736:
                return .iPhone55
            case 812:
                return .iPhoneX
            case 896:
                return .iPhoneMax
            default:

                return .unspecified
            }

        case .unspecified:
            return .unspecified

        case .carPlay:
            return .carPlay
        }
    }
}

// class PickerTextField: AAPickerView , UITextFieldDelegate {
//    let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 5)
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.textColor = AppColor.Color_TopHeader
//        let customFont =  checkFontAndApply(style: .regular, size: 17)
//        self.font = customFont
//        self.tintColor = AppColor.Color_TopHeader
//        self.layer.masksToBounds = true
//        self.autocorrectionType = .no
//        self.delegate = self
//        self.backgroundColor = AppColor.Color_Cream
//
//        let label = self.pickerRow
//        label.font = checkFontAndApply(style: .regular, size: 17)
//
//        if Language.language.rawValue == AppLanguages.Arabic {
//            print("Language is arbic")
//            if self.textAlignment == .natural {
//                self.textAlignment = .right
//            }
//        }
//        else {
//           // print("Language is other")
//            self.textAlignment = .left
//        }
//    }
//
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        return false
//    }
//    override open func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
//
//    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
//
//    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
//
//
//
//    var imageView: ImgViewTextFldPicker = ImgViewTextFldPicker(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//
//
//
//        @IBInspectable var setImageName: String {
//
//            get {
//                return ""
//            }
//            set {
//                let containerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width:30, height: self.frame.height))
//
//                imageView.image = UIImage(named: newValue)!
//                containerView.isUserInteractionEnabled = false
//                containerView.addSubview(imageView)
//                imageView.contentMode = .scaleAspectFit
//                imageView.tintColor =  self.textColor
//                imageView.center = CGPoint.init(x: containerView.frame.width/2, y:  containerView.frame.height/2)
//
//                self.rightView = containerView
//                                              self.rightViewMode = UITextField.ViewMode.always
//
//                if Language.language == Language(rawValue: "en")! {
//                    self.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
////                    self.rightView = containerView
////                               self.rightViewMode = UITextField.ViewMode.always
//                }
//
//                else {
//                    self.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
//
//
//
////                    self.leftView = containerView
////                    self.leftViewMode = UITextField.ViewMode.always
//                }
////
//
//
//            }
//        }
//    }

class TextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 5)
    override func awakeFromNib() {
        textColor = .black
        let customFont = checkFontAndApply(style: .regular, size: 17)
        font = customFont
        tintColor = AppColor.Color_TopHeader
        layer.masksToBounds = true
        autocorrectionType = .no
        backgroundColor = .clear
        clipsToBounds = true

        if Language.language.rawValue == AppLanguages.Arabic {
            print("Language is arbic")
            if textAlignment == .natural {
                textAlignment = .right
            }
        } else {
            //  print("Language is other")
            textAlignment = .left
        }
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    var imageView: ImgViewTextFldPicker = .init(frame: CGRect(x: 0, y: 0, width: 25, height: 25))

    @IBInspectable var setImageName: String {
        get {
            return ""
        }
        set {
            let containerView: UIView = .init(frame: CGRect(x: 0, y: 0, width: 30, height: frame.height))

            imageView.image = UIImage(named: newValue)!.setTintColor(color: AppColor.Color_TopHeader) // withTintColor(AppColor.Color_TopHeader)
            containerView.isUserInteractionEnabled = false
            containerView.addSubview(imageView)
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = textColor
            imageView.center = CGPoint(x: containerView.frame.width / 2, y: containerView.frame.height / 2)
            leftView = containerView
            leftViewMode = UITextField.ViewMode.always
        }
    }

    func fnSetBottomBorderAndImageColor(bottomBorder _: UIColor) {
        let img = setImageName
        if img != "" {
            setImageName = img
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
    }

    func fnRemoveCursor() {
        (value(forKey: "textInputTraits") as AnyObject).setValue(UIColor.clear, forKey: "insertionPointColor")
    }
}

class TextView: UITextView {
    let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 5)
    override func awakeFromNib() {
        textColor = AppColor.Color_TopHeader
        let customFont = checkFontAndApply(style: .regular, size: 17)
        font = customFont
        tintColor = AppColor.Color_TopHeader
        backgroundColor = AppColor.Color_Cream

        if Language.language.rawValue == AppLanguages.Arabic {
            print("Language is arbic")
            if textAlignment == .natural {
                textAlignment = .right
            }
        } else {
            print("Language is other")
            textAlignment = .left
        }
    }
}

extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }

    func isValidDouble(maxDecimalPlaces: Int) -> Bool {
        // Use NumberFormatter to check if we can turn the string into a number
        // and to get the locale specific decimal separator.
        let formatter = NumberFormatter()
        formatter.allowsFloats = true // Default is true, be explicit anyways
        let decimalSeparator = formatter.decimalSeparator ?? "." // Gets the locale specific decimal separator. If for some reason there is none we assume "." is used as separator.

        // Check if we can create a valid number. (The formatter creates a NSNumber, but
        // every NSNumber is a valid double, so we're good!)
        if formatter.number(from: self) != nil {
            // Split our string at the decimal separator
            let split = components(separatedBy: decimalSeparator)

            // Depending on whether there was a decimalSeparator we may have one
            // or two parts now. If it is two then the second part is the one after
            // the separator, aka the digits we care about.
            // If there was no separator then the user hasn't entered a decimal
            // number yet and we treat the string as empty, succeeding the check
            let digits = split.count == 2 ? split.last ?? "" : ""

            // Finally check if we're <= the allowed digits
            return digits.count <= maxDecimalPlaces // TODO: Swift 4.0 replace with digits.count, YAY!
        }

        return true // couldn't turn string into a valid number
    }

    func removeOccurenceOfString(strToRemove: String) -> String {
        return replacingOccurrences(of: strToRemove, with: "", options: NSString.CompareOptions.literal, range: nil)
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

    var htmlToAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            return try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSMutableAttributedString()
        }
    }
}
