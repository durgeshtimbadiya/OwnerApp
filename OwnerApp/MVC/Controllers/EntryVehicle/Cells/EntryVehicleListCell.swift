//
//  EntryVehicleListCell.swift
//  EmployeeApp
//
//  Created by Bhupendra Shekhawat on 31/03/22.
//

import UIKit

class EntryVehicleListCell: UITableViewCell {

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

    @IBOutlet var ViewAction: UIView!
    @IBOutlet weak var btnExitApproved: UIButton!
    @IBOutlet var btnApproveForExit: UIButton!

    var selectImageFrom = ""
    var arrOutpassImage = [ImageModel]()
    var arrMeterialImage = [ImageModel]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
