//
//  AtGateAndAtSiteTableCell.swift
//  EmployeeApp
//
//  Created by Jailove on 21/07/22.
//

import UIKit

class AtGateAndAtSiteTableCell: UITableViewCell {

    @IBOutlet weak var viewSrNo: UIView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewDesignation: UIView!
    @IBOutlet weak var viewContractorName: UIView!
    @IBOutlet weak var viewPunchedIn: UIView!
    
    @IBOutlet weak var lblSrNo: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblContractName: UILabel!
    @IBOutlet weak var lblPunchedIn: UILabel!
    @IBOutlet weak var punchedInBtn: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
