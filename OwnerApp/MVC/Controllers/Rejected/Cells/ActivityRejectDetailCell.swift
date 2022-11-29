//
//  ActivityRejectDetailCell.swift
//  EmployeeApp
//
//  Created by Bhupendra Shekhawat on 28/03/22.
//

import UIKit

class ActivityRejectDetailCell: UITableViewCell {

    @IBOutlet weak var vwAskedApproval: UIView!
    @IBOutlet weak var lblEntryStatus: UITextField!
    @IBOutlet weak var lblEntrySentName: UILabel!
    @IBOutlet weak var lblEntrySentDate: UILabel!
    @IBOutlet weak var lblEntrySentTime: UILabel!
    @IBOutlet weak var lblEntryApprovalName: UILabel!
    @IBOutlet weak var lblEntryApprovalDate: UILabel!
    @IBOutlet weak var lblEntryApprovalTime: UILabel!
    @IBOutlet weak var lblEntryRejectName: UILabel!
    @IBOutlet weak var lblEntryRejectDate: UILabel!
    @IBOutlet weak var lblEntryRejectTime: UILabel!

    @IBOutlet weak var viewEntryDetail: UIView!
    @IBOutlet weak var viewEntrySentByName: UIView!
    @IBOutlet weak var viewEntryApprovalByName: UIView!
    @IBOutlet weak var viewEntryRejectedByName: UIView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vwAskedApproval.layer.cornerRadius = 10
        vwAskedApproval.layer.borderWidth = 1
        vwAskedApproval.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
