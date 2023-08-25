//
//  MyPackageTableViewCell.swift
//  OwnerApp
//
//  Created by Durgesh on 17/07/23.
//

import UIKit

class MyPackageTableViewCell: UITableViewCell {
    
    static let identifier = "packageCell"
    static let packageBuyCell = "packageBuyCell"
    static let radioCell = "radioCell"
    static let currPackageCell = "currPackageCell"

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var radioImage1: UIImageView!
    @IBOutlet weak var radioImage2: UIImageView!

    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var packageTitleLabel: UILabel!
    @IBOutlet weak var remainTitleLabel: UILabel!
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var packageDescLabel: UILabel!
    @IBOutlet weak var packageAmountLabel: UILabel!
    @IBOutlet weak var validDaysLabel: UILabel!
    @IBOutlet weak var purchaseDateLabel: UILabel!
    @IBOutlet weak var remainingDaysValDLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var packRegionLabel: UILabel!
    @IBOutlet weak var paymentModeLabel: UILabel!
    @IBOutlet weak var autoRenewalLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    
    @IBOutlet weak var statusView: UIStackView!
    @IBOutlet weak var packRegionView: UIStackView!
    @IBOutlet weak var paymentModeView: UIStackView!
    @IBOutlet weak var autoRenewalView: UIStackView!
    @IBOutlet weak var expiryDateView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        selectionStyle = .none
    }
    
    func configure(_ cellData: CurrentPackageModel, row: Int) {
        packageLabel.text = "Current Package"
        packageNameLabel.text = "Package Name :"
        remainTitleLabel.text = "Remaining Days :"
        statusView.isHidden = row == 1
        packRegionView.isHidden = row == 1
        paymentModeView.isHidden = row == 1
        autoRenewalView.isHidden = row == 1
        expiryDateView.isHidden = row == 1
        
        self.packageNameLabel.text = cellData.package_name.uppercased()
        self.validDaysLabel.text = "(Valid for \(cellData.valid_for) Days)"
        self.paymentModeLabel.text = cellData.mode
        self.remainingDaysValDLabel.text = "\(cellData.date_diff)"
        self.expiryDateLabel.text = cellData.end_date
        self.purchaseDateLabel.text = cellData.start_date
        self.packRegionLabel.text = "East India"
        self.autoRenewalLabel.text = "No"
        self.statusLabel.text = "Active"
        if row == 1 {
            packageLabel.text = "Upcoming Package"
            packageTitleLabel.text = "Upcoming Package Name :"
            remainTitleLabel.text = "Validity :"
            
            self.purchaseDateLabel.text = cellData.created_at
            self.remainingDaysValDLabel.text = "\(cellData.start_date) to\n\(cellData.end_date)"
        }
    }
    
    func configureUpgrade(_ cellData: CurrentPackageModel, row: Int) {
        self.mainStackView.borderWidth = 3.0
        self.mainStackView.backgroundColor = .clear
        if row == 0 {
            self.mainStackView.borderWidth = 0.0
            self.mainStackView.backgroundColor = UIColor(displayP3Red: 255.0 / 255.0, green: 215.0 / 255.0, blue: 0.0, alpha: 1.0)
            self.packageNameLabel.text = "CURRENT: \n\(cellData.package_name.uppercased()) PACKAGE"
            self.packageDescLabel.text = cellData.plan == "1" ? "Get all Premium Facilities" : "Gold Advantages Excluding Facility services."
            self.packageAmountLabel.text = cellData.plan == "1" ? "Rs. \(cellData.platinum_package)" : "Rs. \(cellData.gold_package)"
            self.remainingDaysValDLabel.text = "Remaining Days: \(cellData.date_diff)"
            self.expiryDateLabel.text = "Expiry Date: \(cellData.end_date)"
            self.expiryDateLabel.isHidden = false
        } else if row == 1 {
            self.mainStackView.borderWidth = 0.0
            self.mainStackView.backgroundColor = .systemGray4
            var cellDetails = cellData
            cellDetails.plan = cellDetails.plan == "2" ? "1" : "2"
            cellDetails.package_name = cellDetails.plan == "1" ? "platinum" : "gold"
            self.packageNameLabel.text = cellDetails.plan == "2" ? "DOWNGRADE To: \n\(cellDetails.package_name.uppercased()) PACKAGE" : "UPGRADE To: \n\(cellDetails.package_name.uppercased()) PACKAGE"
            self.packageDescLabel.text = cellDetails.plan == "1" ? "Get all Premium Facilities" : "Gold Advantages Excluding Facility services."
            self.packageAmountLabel.text = cellDetails.plan == "1" ? "Rs. \(cellDetails.platinum_package)" : "Rs. \(cellData.gold_package)"
            self.remainingDaysValDLabel.text = "30 Days"
            self.expiryDateLabel.isHidden = true
        }
    }

}
