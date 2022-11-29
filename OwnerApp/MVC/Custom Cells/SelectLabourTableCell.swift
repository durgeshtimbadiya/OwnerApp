//
//  SelectLabourTableCell.swift
//  EmployeeApp
//
//  Created by Jailove on 20/07/22.
//

import UIKit

class SelectLabourTableCell: UITableViewCell {
   
    @IBOutlet var bgView: UIView!
    @IBOutlet var btnCheck: UIButton!
    @IBOutlet var lblSeprator: UILabel!
    @IBOutlet var lblTitle: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
