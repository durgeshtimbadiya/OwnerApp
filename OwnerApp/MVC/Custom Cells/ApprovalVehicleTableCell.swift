//
//  ApprovalVehicleTableCell.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 21/03/22.
//

import UIKit

class ApprovalVehicleTableCell: UITableViewCell {

    
     // UIView
     @IBOutlet var viewUniqueID: UIView!
     @IBOutlet var viewVehicleNo: UIView!
     @IBOutlet var viewDetail: UIView!
     @IBOutlet var viewStatus: UIView!
     @IBOutlet var viewAction: UIView!

     @IBOutlet var lblUniqueID: UILabel!
     @IBOutlet var lblVehicleNo: UILabel!
     @IBOutlet var innerViewDetail: UIView!
     @IBOutlet var btnViewDetail: UIButton!
     @IBOutlet var lblStatus: UILabel!
     @IBOutlet var lblAction: UILabel!
     @IBOutlet var btnApprove: UIButton!
     @IBOutlet var btnReject: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
