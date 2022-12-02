//
//  NotificationTableCell.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 23/11/21.
//

import UIKit

class NotificationTableCell: UITableViewCell {
    @IBOutlet var viewCorner: UIStackView!
//    @IBOutlet var viewInnerStatus: UIView!
    @IBOutlet var lblStatusName: UILabel!
    @IBOutlet var imgStatus: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDateAndTime: UILabel!
    @IBOutlet weak var imgStatusRIght: UIImageView!
    @IBOutlet weak var imgStatusRightView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if imgStatusRightView != nil {
            imgStatusRightView.layer.masksToBounds = true
            imgStatusRightView.layer.cornerRadius = 10
            imgStatusRightView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//            self.imgStatusRightView.round(corners: [.topLeft, .topRight], cornerRadius: 10)
        }
//        if viewCorner != nil {
//            self.viewCorner.round(corners: .allCorners, cornerRadius: 10)
//        }
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
