//
//  SelfieTableCell.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 13/12/21.
//

import UIKit

class SelfieTableCell: UITableViewCell {
    @IBOutlet var viewBig: UIView!
    @IBOutlet var imgVIew: UIImageView!
    @IBOutlet var viewCount: UIView!
    @IBOutlet var lblCount: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
