//
//  AttendanceLogTableCell.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 13/12/21.
//

import UIKit

class AttendanceLogTableCell: UITableViewCell {
    @IBOutlet var lblSrCount: UILabel!
    @IBOutlet var lblPunchINDataTime: UILabel!
    @IBOutlet var lblPunchOutStatus: UILabel!
    @IBOutlet var lblTotalHour: UILabel!

    @IBOutlet var viewSrNo: UIView!
    @IBOutlet var viewPunchIN: UIView!
    @IBOutlet var viewPunchOut: UIView!
    @IBOutlet var viewTotalHour: UIView!
    @IBOutlet var viewName: UIView!
    @IBOutlet var lblName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
