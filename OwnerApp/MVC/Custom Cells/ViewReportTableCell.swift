//
//  ViewReportTableCell.swift
//  EmployeeApp
//
//  Created by Jailove on 20/07/22.
//

import UIKit

class ViewReportTableCell: UITableViewCell {

    @IBOutlet weak var lblSrNo: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnName: UIButton!
    @IBOutlet weak var btnViewRemark: UIButton!
    @IBOutlet weak var lblDateAndTime: UILabel!
    @IBOutlet weak var btnImageDownload: UIButton!
    
    //UIView
    @IBOutlet weak var viewSrNo: UIView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewRemark: UIView!
    @IBOutlet weak var viewDateAndTime: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
