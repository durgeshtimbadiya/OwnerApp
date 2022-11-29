//
//  GlobalLabel.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import Foundation
import UIKit

extension UILabel {
    func setAlignmentBasedOnSelectedalnguage() {
        if Language.language.rawValue == AppLanguages.Arabic {
            print("Language is arbic")
            if textAlignment == .natural {
                textAlignment = .right
            }
        } else {
            //  print("Language is other")
        }
    }
}

class LoginFlowTitleLabel: UILabel {
    override func awakeFromNib() {
        let customFont = UIFont(name: "Intro Bold Italic", size: 25)
        textColor = AppColor.Color_SkyBlueTitle
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .regular, size: font.pointSize)
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleWhiteLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .regular, size: font.pointSize)
        textColor = UIColor.white

        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleWhiteBoldLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .bold, size: font.pointSize)
        textColor = UIColor.white
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleGreenLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .regular, size: font.pointSize)
        textColor = AppColor.Color_LightGreenButtonBG
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleSkyBlueLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .regular, size: font.pointSize)
        textColor = AppColor.Color_SkyBlueTitle
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleSkyBlueBoldLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .bold, size: font.pointSize)
        textColor = AppColor.Color_SkyBlueTitle
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleGreyLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .regular, size: font.pointSize)
        textColor = .lightGray
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleDARKGreyLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .regular, size: font.pointSize)
        textColor = .darkGray
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleBlueLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .regular, size: font.pointSize)
        textColor = AppColor.Color_TopHeader
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleBlackLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .regular, size: font.pointSize)
        textColor = AppColor.Color_Black
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleGoldLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .regular, size: font.pointSize)
        textColor = AppColor.Color_Gold
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleBlackBoldLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .bold, size: font.pointSize)
        textColor = AppColor.Color_Black
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleYellowBoldLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .bold, size: font.pointSize)
        textColor = AppColor.Color_TopHeader
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleStrikeThroughLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .regular, size: font.pointSize)
        textColor = AppColor.Color_StrikeCoor
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

enum Strings_ECWishListVC {
    static var NavTitle: String { return "Wishlists".localized }
}

class SimpleRedLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .regular, size: font.pointSize)
        textColor = AppColor.Color_Red
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleOrangeLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .regular, size: font.pointSize)
        textColor = AppColor.Color_OrangeButtonBG

        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleGreenBoldLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .bold, size: font.pointSize)
        textColor = AppColor.Color_LightGreenButtonBG
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleGreyReviewsLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .regular, size: font.pointSize)
        textColor = AppColor.Color_Grey
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleWhitePoppinsMidiumLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkPopinsFontAndApply(style: .medium, size: font.pointSize)
        textColor = UIColor.white
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleWhitePoppinsRegularLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkPopinsFontAndApply(style: .regular, size: font.pointSize)
        textColor = UIColor.white
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleWhitePoppinsRegularSkyBlueLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkPopinsFontAndApply(style: .regular, size: font.pointSize)
        textColor = AppColor.Color_SkyBlueTitle
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}

class SimpleWhitePoppinsMediumSkyBlueLabel: UILabel {
    override func awakeFromNib() {
        let customFont = checkPopinsFontAndApply(style: .medium, size: font.pointSize)
        textColor = AppColor.Color_SkyBlueTitle
        font = customFont
        layoutIfNeeded()
        setAlignmentBasedOnSelectedalnguage()
    }
}
