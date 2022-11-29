//
//  VisitorsLogDocumentTableCell.swift
//  EmployeeApp
//
//  Created by Jailove on 13/07/22.
//

import UIKit
import SDWebImage

class VisitorsLogDocumentTableCell: UITableViewCell {

    @IBOutlet weak var viewMainVehicleNo: UIView!
    @IBOutlet weak var viewVehicleNo: UIView!
    @IBOutlet weak var txtFieldVehicleNumber: UITextField!
    
    @IBOutlet weak var viewVisitors: UIView!
    @IBOutlet weak var imgVisitors: UIImageView!
    
    @IBOutlet weak var imgVisitorsBtn: UIButton!
    @IBOutlet weak var imgOutPassBtn: UIButton!
    @IBOutlet weak var imgOutWardChallanBtn: UIButton!

    @IBOutlet weak var viewOutwardChallan: UIView!
    @IBOutlet weak var imgOutWardChallan: UIImageView!

    @IBOutlet weak var viewMainRemark: UIStackView!
    @IBOutlet weak var viewCornerRemark: UIStackView!
    @IBOutlet weak var txtFieldRemark: UILabel!
    
    @IBOutlet weak var viewMaterialRemark: UIStackView!
    @IBOutlet weak var viewCornerMaterialRemark: UIStackView!
    @IBOutlet weak var txtFieldMaterialRemark: UILabel!
    
    @IBOutlet weak var viewMainMaterialStatus: UIView!
    @IBOutlet weak var viewCornerMaterialStatus: UIView!
    @IBOutlet weak var txtFieldMaterialStatus: UITextField!
    
    @IBOutlet weak var viewMainPurposeofOutpass: UIView!
    @IBOutlet weak var viewCornerPurposeOutPass: UIView!
    @IBOutlet weak var txtfieldPurposeOutPass: UITextField!
    
    @IBOutlet weak var collectionVehicleMeterialList: UICollectionView!
    @IBOutlet weak var vwMaterial: UIView!
    var imageArrVehicleMeterial = [VisitorDocument]()
    var imageArrOutWardChallanImage = [ExitEntry]()

    @IBOutlet weak var viewMainOutPass: UIView!
    @IBOutlet weak var imgOutPass: UIImageView!

    var documentArr = [Document]()
    var currentViewController: UIViewController = UIViewController()

    override func awakeFromNib() {
        super.awakeFromNib()
       
//        // Initialization code
        viewVehicleNo.layer.cornerRadius = 10
        viewVehicleNo.layer.borderWidth = 1
        viewVehicleNo.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

        viewCornerRemark.layer.cornerRadius = 10
        viewCornerRemark.layer.borderWidth = 1
        viewCornerRemark.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

        viewCornerMaterialStatus.layer.cornerRadius = 10
        viewCornerMaterialStatus.layer.borderWidth = 1
        viewCornerMaterialStatus.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

        viewCornerMaterialRemark.layer.cornerRadius = 10
        viewCornerMaterialRemark.layer.borderWidth = 1
        viewCornerMaterialRemark.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        viewCornerPurposeOutPass.layer.cornerRadius = 10
        viewCornerPurposeOutPass.layer.borderWidth = 1
        viewCornerPurposeOutPass.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        
        if collectionVehicleMeterialList != nil {
            collectionVehicleMeterialList.delegate = self
            collectionVehicleMeterialList.dataSource = self
        }
              
        if self.documentArr.count > 0{
        collectionVehicleMeterialList.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension VisitorsLogDocumentTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if collectionView.isEqual(self.collectionVehicleMeterialList){
            return self.imageArrVehicleMeterial.count
        }
       
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        var obj : VisitorDocument? = nil
        var objExitAttachment : VisitorDocument? = nil
   //     var objExitEntry : ExitEntry? = nil
       
        
        if collectionView.isEqual(self.collectionVehicleMeterialList) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VisitorsLogMaterialCollectionCell", for: indexPath) as! VisitorsLogMaterialCollectionCell
           
            objExitAttachment = self.imageArrVehicleMeterial[indexPath.row]
           
            DispatchQueue.main.async {
                cell.imgMaterial.round(corners: [.topLeft,.topRight, .bottomRight, .bottomLeft], cornerRadius: 4)
                cell.imgMaterial.contentMode = .scaleAspectFill
            }
            if objExitAttachment?.url != "" {
                cell.imgMaterial.sd_setImage(with: URL(string:objExitAttachment?.url ?? ""), placeholderImage: UIImage(named: "nopreview"),
                                      options: .refreshCached,
                                      completed: nil)
            }
            return cell
        }
              
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.size.width - 20) / 2.1
       return CGSize(width: width, height: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
            return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
            return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = self.imageArrVehicleMeterial[indexPath.row]
        if !obj.url.isEmpty, let vc = UIStoryboard(name: "Vehicle", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController {
            vc.imageURL = obj.url
            Functions.pushToViewController(currentViewController, toVC: vc)
        } else {
            currentViewController.view.makeToast("No image found!", duration: 1.0, position: .center)
        }
    }
}
