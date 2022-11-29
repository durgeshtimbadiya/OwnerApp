//
//  VisitorsLogVehicleDetailTableCell.swift
//  EmployeeApp
//
//  Created by Jailove on 13/07/22.
//

import UIKit

class VisitorsLogVehicleDetailTableCell: UITableViewCell {
  
    @IBOutlet weak var viewVisitorName: UIView!
    @IBOutlet weak var viewVisitorMobileNo: UIView!
    @IBOutlet weak var viewVisitorType: UIView!
    @IBOutlet weak var viewWhomToMeet: UIView!
    @IBOutlet weak var viewNoOfVisitor: UIView!
    
    
    @IBOutlet weak var lblVehicleName: UITextField!
    @IBOutlet weak var lblVisitorMobileNo: UITextField!
    @IBOutlet weak var lblVisitorType: UITextField!
    @IBOutlet weak var lblWhomToMeet: UITextField!
    @IBOutlet weak var lblNoOfVisitor: UITextField!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        viewVisitorName.layer.cornerRadius = 10
        viewVisitorName.layer.borderWidth = 1
        viewVisitorName.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

        viewVisitorMobileNo.layer.cornerRadius = 10
        viewVisitorMobileNo.layer.borderWidth = 1
        viewVisitorMobileNo.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

        viewVisitorType.layer.cornerRadius = 10
        viewVisitorType.layer.borderWidth = 1
        viewVisitorType.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        viewWhomToMeet.layer.cornerRadius = 10
        viewWhomToMeet.layer.borderWidth = 1
        viewWhomToMeet.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        viewNoOfVisitor.layer.cornerRadius = 10
        viewNoOfVisitor.layer.borderWidth = 1
        viewNoOfVisitor.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
