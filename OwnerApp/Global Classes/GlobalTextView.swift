//
//  GlobalTextView.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import Foundation
import UIKit

class RegularBlackTextView: UITextView {
    override func awakeFromNib() {
        let customFont = checkFontAndApply(style: .regular, size: 18)
        font = customFont
        textColor = AppColor.Color_Black
        layoutIfNeeded()
    }
}
