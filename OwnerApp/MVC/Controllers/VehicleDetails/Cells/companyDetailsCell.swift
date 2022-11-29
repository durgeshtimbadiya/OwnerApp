//
//  companyDetailsCell.swift
//  EmployeeApp
//
//  Created by Bhupendra Shekhawat on 24/03/22.
//

import UIKit

class companyDetailsCell: UITableViewCell {

    @IBOutlet weak var vwNameOFCompany: UIView!
    @IBOutlet weak var vwRegisterMobile: UIView!
    @IBOutlet weak var vwMeterial: UIView!
    
    @IBOutlet weak var lblCompanyName: UITextField!
    @IBOutlet weak var lblRegisterMobileNumber: UITextField!
    @IBOutlet weak var lblMeterialType: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vwNameOFCompany.layer.cornerRadius = 10
        vwNameOFCompany.layer.borderWidth = 1
        vwNameOFCompany.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

        vwRegisterMobile.layer.cornerRadius = 10
        vwRegisterMobile.layer.borderWidth = 1
        vwRegisterMobile.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

        vwMeterial.layer.cornerRadius = 10
        vwMeterial.layer.borderWidth = 1
        vwMeterial.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
