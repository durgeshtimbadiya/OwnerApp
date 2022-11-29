//
//  VisitorsLogCompanyDetailTableCell.swift
//  EmployeeApp
//
//  Created by Jailove on 13/07/22.
//

import UIKit

class VisitorsLogCompanyDetailTableCell: UITableViewCell {
    @IBOutlet weak var vwNameOFCompany: UIView!
    @IBOutlet weak var lblCompanyName: UITextField!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vwNameOFCompany.layer.cornerRadius = 10
        vwNameOFCompany.layer.borderWidth = 1
        vwNameOFCompany.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
