//
//  SiteListTableCell.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 20/11/21.
//

import UIKit

class SiteListTableCell: UITableViewCell {
    @IBOutlet var viewCorner: UIView!
    @IBOutlet var viewInnerImg: UIView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var lblSiteName: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var btnViewSite: UIButton!

    @IBOutlet var viewBlockedStatus: UIView!
    @IBOutlet var lblBlockedStatus: UILabel!
    
    @IBOutlet weak var viewCornerReport: UIView!
    @IBOutlet weak var lblReportCount: UILabel!
    @IBOutlet weak var btnReport: UIButton!
    
    @IBOutlet weak var btnSOS: UIButton!
    @IBOutlet weak var btnLive: UIButton!
    
    @IBOutlet weak var viewMainCornerVehicle: UIView!
    @IBOutlet weak var viewCornerVehicle: UIView!
    @IBOutlet weak var lblVehicleCount: UILabel!
    @IBOutlet weak var btnVehicle: UIButton!
    
    @IBOutlet weak var viewMainCornerVisitor: UIView!
    @IBOutlet weak var viewConrnerVisitor: UIView!
    @IBOutlet weak var lblVisitorCount: UILabel!
    @IBOutlet weak var btnVisitor: UIButton!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
