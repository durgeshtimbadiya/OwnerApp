//
//  ExitVehicleCell.swift
//  EmployeeApp
//
//  Created by Bhupendra Shekhawat on 01/04/22.
//

import UIKit

class ExitVehicleCell: UITableViewCell {

    @IBOutlet weak var vwExitOption: UIView!
    @IBOutlet weak var txtExitOption: UITextField!
    @IBOutlet weak var vwSelectPurpose: UIView!
    @IBOutlet weak var vwIngoreWithMark: UIView!
    @IBOutlet weak var txtIgnoreWithRemark: UITextField!

    @IBOutlet weak var txtPurposeOfoutpass: UITextField!
    
    @IBOutlet weak var collectionUploadOutPassImage: UICollectionView!
    @IBOutlet weak var btnOutPassImage: UIButton!
    @IBOutlet weak var collectionMeterialImage: UICollectionView!
    @IBOutlet weak var btnUploadMeterial: UIButton!
    @IBOutlet weak var btnExitApproval: UIButton!
    
    @IBOutlet weak var vwPurposeOutpass: UIView!
  //  @IBOutlet weak var heightPurposeOfOutPassConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if vwExitOption != nil {
            vwExitOption.layer.cornerRadius = 10
            vwExitOption.layer.borderWidth = 1
            vwExitOption.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        }
       
        if vwSelectPurpose != nil {
            vwSelectPurpose.layer.cornerRadius = 10
            vwSelectPurpose.layer.borderWidth = 1
            vwSelectPurpose.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        }
        
        if vwIngoreWithMark != nil {
            vwIngoreWithMark.layer.cornerRadius = 10
            vwIngoreWithMark.layer.borderWidth = 1
            vwIngoreWithMark.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
