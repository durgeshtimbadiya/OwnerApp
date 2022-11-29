//
//  GlobalImageViews.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import Foundation
import UIKit

// MARK: - ImageView

class ImgViewTextFldPicker: UIImageView {
    override func awakeFromNib() {
        if image != nil {
            image = image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        }
    }
}
