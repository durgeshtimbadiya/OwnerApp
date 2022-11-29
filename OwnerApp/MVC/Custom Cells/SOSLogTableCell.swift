//
//  SOSLogTableCell.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 13/12/21.
//

import UIKit

class SOSLogTableCell: UITableViewCell {
    @IBOutlet var viewCorner: UIView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblSOSName: UILabel!
    @IBOutlet var lblDateandTIme: UILabel!
    @IBOutlet weak var lblnoDataFound: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
