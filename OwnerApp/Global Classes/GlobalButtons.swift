//
//  GlobalButtons.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import Foundation
import UIKit

class APPLightGrayButtonBlueFont: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_LightGrey
        layer.cornerRadius = 25
        clipsToBounds = true
        setTitleColor(AppColor.Color_TopHeader, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPYellowButtonBlackFont: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_TopHeader
        layer.cornerRadius = 30
        clipsToBounds = true
        setTitleColor(UIColor.black, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPSimpleGoldButtonWhiteFont: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_TopHeader
        clipsToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPYellowButtonWhiteFont: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_TopHeader
        clipsToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPORANGEButtonWhiteFont: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_OrangeButtonBG
        clipsToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPGreenButtonBlueFontWithoutSize: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_LightGreenButtonBG
        clipsToBounds = true
        setTitleColor(AppColor.Color_TopHeader, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPOrangeButtonWhiteFont: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_OrangeButtonBG
        layer.cornerRadius = 25
        clipsToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPPlaneOrangeButtonWhiteFont: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_OrangeButtonBG
        clipsToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPBlueButtonCreamFont: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_TopHeader
        clipsToBounds = true
        setTitleColor(AppColor.Color_Cream, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPskyblueButtonWhiteFont: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_SkyBlueTitle
        layer.cornerRadius = 25
        clipsToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPRedButtonWhiteFont: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_Red
        layer.cornerRadius = 25
        clipsToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPBlueButtonOrangeFont: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_TopHeader
        layer.cornerRadius = 25
        clipsToBounds = true
        setTitleColor(AppColor.Color_OrangeButtonBG, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPGreenButtonWhiteFont: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_LightGreenButtonBG
        layer.cornerRadius = 25
        clipsToBounds = true
        setTitleColor(.white, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPCommonRegularButton: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPCommonButton: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPCommonBOldButton: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPOrangeButton: UIButton {
    override func awakeFromNib() {
        setTitleColor(AppColor.Color_OrangeButtonBG, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPGreenButton: UIButton {
    override func awakeFromNib() {
        setTitleColor(AppColor.Color_LightGreenButtonBG, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPWHiteButton: UIButton {
    override func awakeFromNib() {
        setTitleColor(.white, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class AppRegularBlackButton: UIButton {
    override func awakeFromNib() {
        setTitleColor(AppColor.Color_Black, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .regular, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .regular, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPRegularOrangeButton: UIButton {
    override func awakeFromNib() {
        setTitleColor(AppColor.Color_OrangeButtonBG, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPOrangeButtonRegularWhiteFont: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_OrangeButtonBG
        layer.cornerRadius = 25
        clipsToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: 22)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPskyblueButtonRegularWhiteFont: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_SkyBlueTitle
        layer.cornerRadius = 25
        clipsToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: 22)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPRedButtonRegularWhiteFont: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_Red
        layer.cornerRadius = 25
        clipsToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: 22)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPRedButtonSImpleWhiteFont: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_Red
        clipsToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPGoldButtonWhiteRegular: UIButton {
    override func awakeFromNib() {
        backgroundColor = AppColor.Color_TopHeader
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPWhiteButtonGrayRegular: UIButton {
    override func awakeFromNib() {
        backgroundColor = .white
        setTitleColor(AppColor.Color_Grey, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPWhiteButtonLightGrayRegular: UIButton {
    override func awakeFromNib() {
        backgroundColor = .white
        setTitleColor(UIColor.lightGray, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .light, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .light, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPRedButtonBoldFont: UIButton {
    override func awakeFromNib() {
        clipsToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        setTitleColor(AppColor.Color_TopHeader, for: .normal)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}

class APPWhiteButtonGoldBold: UIButton {
    override func awakeFromNib() {
        backgroundColor = .white
        setTitleColor(AppColor.Color_Gold, for: .normal)
        titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)!)
        if Language.language.rawValue == AppLanguages.Arabic {
            titleLabel?.font = checkFontAndApply(style: .bold, size: (titleLabel?.font.pointSize)! + 2)
        }
    }
}
