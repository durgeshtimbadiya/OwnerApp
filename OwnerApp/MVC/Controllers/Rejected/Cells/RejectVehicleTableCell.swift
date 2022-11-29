//
//  RejectVehicleTableCell.swift
//  EmployeeApp
//
//  Created by Bhupendra Shekhawat on 27/03/22.
//

import UIKit

class RejectVehicleTableCell: UITableViewCell {

    // UIView
    @IBOutlet var viewUniqueID: UIView!
    @IBOutlet var lblUniqueID: UILabel!

    @IBOutlet var viewVehicleNo: UIView!
    @IBOutlet var lblVehicleNo: UILabel!

    @IBOutlet var viewDetail: UIView!
    @IBOutlet var innerViewDetail: UIView!
    @IBOutlet var btnViewDetail: UIButton!

    @IBOutlet var viewStatus: UIView!
    @IBOutlet var lblStatus: UILabel!
    
    @IBOutlet weak var viewEditView: UIView!
    @IBOutlet weak var editButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
