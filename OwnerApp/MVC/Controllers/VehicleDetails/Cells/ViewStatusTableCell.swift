//
//  ViewStatusTableCell.swift
//  EmployeeApp
//
//  Created by Jailove on 17/06/22.
//

import UIKit

class ViewStatusTableCell: UITableViewCell {
    @IBOutlet weak var vwAskedApproval: UIView!
    @IBOutlet weak var vwApprovalForExit: UIView!
    @IBOutlet weak var lblEntryStatus: UITextField!
    @IBOutlet weak var lblEntrySentName: UILabel!
    @IBOutlet weak var lblEntrySentTime: UILabel!
    @IBOutlet weak var lblEntryApprovalName: UILabel!
    @IBOutlet weak var lblEntryApprovalTime: UILabel!
    @IBOutlet weak var lblEntryGrantedName: UILabel!
    @IBOutlet weak var lblEntryGrantedTime: UILabel!
    @IBOutlet weak var lblApprovalForExit: UITextField!
    @IBOutlet weak var lblExitAprrovalName: UILabel!
    @IBOutlet weak var lblExitApprovalTime: UILabel!
    @IBOutlet weak var lblExitGrantName: UILabel!
    @IBOutlet weak var lblExitGrantTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
      
        // Initialization code
        vwAskedApproval.layer.cornerRadius = 10
        vwAskedApproval.layer.borderWidth = 1
        vwAskedApproval.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

        vwApprovalForExit.layer.cornerRadius = 10
        vwApprovalForExit.layer.borderWidth = 1
        vwApprovalForExit.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
