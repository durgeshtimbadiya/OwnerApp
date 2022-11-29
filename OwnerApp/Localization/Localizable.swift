//
//  Localizable.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import UIKit

private let appleLanguagesKey = "AppleLanguages"

enum Language: String {
    case english = "en"
    case arabic = "ar"
    case ukrainian = "uk"

    var semantic: UISemanticContentAttribute {
        switch self {
        case .english, .ukrainian:
            return .forceLeftToRight
        case .arabic:
            return .forceRightToLeft
        }
    }

    static var language: Language {
        get {
            if let languageCode = UserDefaults.standard.string(forKey: appleLanguagesKey),
               let language = Language(rawValue: languageCode)
            {
                return language
            } else {
                let preferredLanguage = NSLocale.preferredLanguages[0] as String
                let index = preferredLanguage.index(
                    preferredLanguage.startIndex,
                    offsetBy: 2
                )
                guard let localization = Language(
                    rawValue: preferredLanguage.substring(to: index)
                ) else {
                    return Language.english
                }
                return localization
            }
        }
        set {
            guard language != newValue else {
                return
            }

            // change language in the app
            // the language will be changed after restart
            UserDefaults.standard.set([newValue.rawValue], forKey: appleLanguagesKey)
            UserDefaults.standard.synchronize()

            // Changes semantic to all views
            // this hack needs in case of languages with different semantics: leftToRight(en/uk) & rightToLeft(ar)

//            MethodSwizzleGivenClassName(cls: UITextField.self, originalSelector: #selector(UITextField.layoutSubviews), overrideSelector: #selector(UITextField.cstmlayoutSubviews))
//            MethodSwizzleGivenClassName(cls: UILabel.self, originalSelector: #selector(UILabel.layoutSubviews), overrideSelector: #selector(UILabel.cstmlayoutSubviews))
            // initialize the app from scratch
            // show initial view controller
            // so it seems like the is restarted
            // NOTE: do not localize storboards
            // After the app restart all labels/images will be set
            // see extension String below

            UIView.appearance().semanticContentAttribute = newValue.semantic

            UIApplication.shared.windows[0].rootViewController = UIStoryboard(name: StoryBoard.StoryBoardHome, bundle: nil).instantiateInitialViewController()
        }
    }

//    static func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
//        let origMethod: Method = class_getInstanceMethod(cls, originalSelector)!;
//        let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)!;
//        if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
//            class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
//        } else {
//            method_exchangeImplementations(origMethod, overrideMethod);
//        }
//    }
}

extension String {
    var localized: String {
        return Bundle.localizedBundle.localizedString(forKey: self, value: nil, table: nil)
    }

    var localizedImage: UIImage? {
        return localizedImage()
            ?? localizedImage(type: ".png")
            ?? localizedImage(type: ".jpg")
            ?? localizedImage(type: ".jpeg")
            ?? UIImage(named: self)
    }

    private func localizedImage(type: String = "") -> UIImage? {
        guard let imagePath = Bundle.localizedBundle.path(forResource: self, ofType: type) else {
            return nil
        }
        return UIImage(contentsOfFile: imagePath)
    }
}

extension Bundle {
    // Here magic happens
    // when you localize resources: for instance Localizable.strings, images
    // it creates different bundles
    // we take appropriate bundle according to language
    static var localizedBundle: Bundle {
        let languageCode = Language.language.rawValue
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") else {
            return Bundle.main
        }
        return Bundle(path: path)!
    }
}

extension UIApplication {
    class func isRTL() -> Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
}
