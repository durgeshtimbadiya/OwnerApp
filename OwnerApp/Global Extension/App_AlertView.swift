//
//  App_AlertView.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import Foundation
import SCLAlertView
import UIKit

class App_AlertView: NSObject {
    override private init() {}

    static let shared: App_AlertView = .init()

    public func SimpleMessage(Text: String) {
        let appearance = SCLAlertView.SCLAppearance(kCircleHeight: 55, kCircleIconHeight: 40, kTitleTop: 40, kWindowWidth: 275, kTitleFont: checkFontAndApply(style: .bold, size: 15), kTextFont: checkFontAndApply(style: .regular, size: 15), kButtonFont: checkFontAndApply(style: .regular, size: 15), showCircularIcon: true, contentViewCornerRadius: 7, hideWhenBackgroundViewIsTapped: false, circleBackgroundColor: .white, contentViewColor: .white, contentViewBorderColor: .clear, titleColor: AppColor.Color_TopHeader)

        let alertView = SCLAlertView(appearance: appearance)
        let alertViewIcon = UIImage(named: "logo") // withTintColor(.white) //Replace the IconImage text with the image name

        //        alertView.showCustom(<#T##title: String##String#>, subTitle: <#T##String#>, color: <#T##UIColor#>, icon: <#T##UIImage#>, closeButtonTitle: <#T##String?#>, timeout: <#T##SCLAlertView.SCLTimeoutConfiguration?#>, colorStyle: <#T##UInt#>, colorTextButton: <#T##UInt#>, circleIconImage: <#T##UIImage?#>, animationStyle: <#T##SCLAnimationStyle#>)

        if alertView.isShowing() {
            return
        }

        alertView.showCustom(AppName, subTitle: Text, color: AppColor.Color_TopHeader, icon: alertViewIcon!, closeButtonTitle: Strings.AlertOk, animationStyle: .bottomToTop)
    }

    public func AlertWithDoubleButton(Text: String, Button1Title: String, Button1Action: @escaping () -> Void, Button1BGCOLOR: UIColor, Button2Title: String, Button2Action: @escaping () -> Void, Button2BGCOLOR: UIColor) {
        let appearance = SCLAlertView.SCLAppearance(kCircleHeight: 55, kCircleIconHeight: 40, kTitleTop: 40, kWindowWidth: 275, kWindowHeight: 400, kTitleFont: checkFontAndApply(style: .regular, size: 15), kTextFont: checkFontAndApply(style: .regular, size: 15), kButtonFont: checkFontAndApply(style: .regular, size: 15), showCloseButton: false, showCircularIcon: true, contentViewCornerRadius: 7, hideWhenBackgroundViewIsTapped: false, contentViewBorderColor: AppColor.Color_TopHeader, titleColor: AppColor.Color_TopHeader, buttonsLayout: .horizontal)

        let alertView = SCLAlertView(appearance: appearance)
        let alertViewIcon = UIImage(named: "logo") // Replace the IconImage text with the image name

        alertView.addButton(Button1Title, backgroundColor: Button1BGCOLOR, action: Button1Action)
        alertView.addButton(Button2Title, backgroundColor: Button2BGCOLOR, action: Button2Action)

        if alertView.isShowing() {
            return
        }
        alertView.showCustom(AppName, subTitle: Text, color: AppColor.Color_TopHeader, icon: alertViewIcon!, animationStyle: .bottomToTop)
    }

    public func AlertWithSingleButton(Text: String, Button1Title: String, Button1Action: @escaping () -> Void, Button1BGCOLOR: UIColor = AppColor.Color_TopHeader) {
        let appearance = SCLAlertView.SCLAppearance(kCircleHeight: 55, kCircleIconHeight: 40, kTitleTop: 40, kWindowWidth: 275, kWindowHeight: 400, kTitleFont: checkFontAndApply(style: .regular, size: 20), kTextFont: checkFontAndApply(style: .regular, size: 15), kButtonFont: checkFontAndApply(style: .regular, size: 17), showCloseButton: false, showCircularIcon: true, contentViewCornerRadius: 7, hideWhenBackgroundViewIsTapped: false, contentViewBorderColor: AppColor.Color_TopHeader, titleColor: AppColor.Color_TopHeader, buttonsLayout: .horizontal)

        let alertView = SCLAlertView(appearance: appearance)
        let alertViewIcon = UIImage(named: "logo") // Replace the IconImage text with the image name

        alertView.addButton(Button1Title, backgroundColor: Button1BGCOLOR, action: Button1Action)

        if alertView.isShowing() {
            return
        }
        alertView.showCustom(AppName, subTitle: Text, color: AppColor.Color_TopHeader, icon: alertViewIcon!, animationStyle: .bottomToTop)
    }
}
