//
//  InHoueseTabelCell.swift
//  EmployeeApp
//
//  Created by Jailove on 21/07/22.
//

import UIKit

class InHoueseTabelCell: UITableViewCell {

    @IBOutlet weak var viewSrNo: UIView!
    @IBOutlet weak var viewUniqueID: UIView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewVehicleNo: UIView!
    @IBOutlet weak var viewStatus: UIView!
    
    @IBOutlet weak var lblSrNo: UILabel!
    @IBOutlet weak var lblUniqueID: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblVehicleNo: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var removeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
