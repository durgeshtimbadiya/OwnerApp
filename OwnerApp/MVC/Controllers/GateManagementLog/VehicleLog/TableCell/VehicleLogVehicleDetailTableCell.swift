//
//  VehicleLogVehicleDetailTableCell.swift
//  EmployeeApp
//
//  Created by Jailove on 22/06/22.
//

import UIKit

class VehicleLogVehicleDetailTableCell: UITableViewCell {
    @IBOutlet weak var vwCommercialVehicleNumber: UIView!
    @IBOutlet weak var vwQtyWithUnit: UIView!
    @IBOutlet weak var vwDriverContactNumber: UIView!
    @IBOutlet weak var lblVehicleNumber: UITextField!
    @IBOutlet weak var lblQtyWithUnit: UITextField!
    @IBOutlet weak var lblDriverNumber: UITextField!
    
    @IBOutlet weak var lblQuantityMsg: UILabel!
    @IBOutlet weak var lblCommercialMsg: UILabel!
    @IBOutlet weak var lblMaterialImgMsg: UILabel!
    
    @IBOutlet weak var materialImagesView: UIStackView!
    @IBOutlet weak var collectionMaterialList: UICollectionView!
    var imageArrMaterials = [String]()
    var currentViewController: UIViewController = UIViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vwCommercialVehicleNumber.layer.cornerRadius = 10
        vwCommercialVehicleNumber.layer.borderWidth = 1
        vwCommercialVehicleNumber.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

        vwQtyWithUnit.layer.cornerRadius = 10
        vwQtyWithUnit.layer.borderWidth = 1
        vwQtyWithUnit.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

        vwDriverContactNumber.layer.cornerRadius = 10
        vwDriverContactNumber.layer.borderWidth = 1
        vwDriverContactNumber.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        if collectionMaterialList != nil {
            collectionMaterialList.delegate = self
            collectionMaterialList.dataSource = self
        }
        if imageArrMaterials.count > 0 {
            collectionMaterialList.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension VehicleLogVehicleDetailTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArrMaterials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehicleMaterialCollectionCell", for: indexPath) as! VehicleLogInwardAndOutWardCollectionCell
        DispatchQueue.main.async {
            cell.imgView.round(corners: [.topLeft,.topRight, .bottomRight, .bottomLeft], cornerRadius: 4)
            cell.imgView.contentMode = .scaleAspectFill
        }
        if self.imageArrMaterials[indexPath.row] != "" {
            cell.imgView.sd_setImage(with: URL(string: self.imageArrMaterials[indexPath.row]), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached, completed: nil)
        }
        return cell
        
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
        if !self.imageArrMaterials[indexPath.row].isEmpty, let vc = UIStoryboard(name: "Vehicle", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController {
            vc.imageURL = self.imageArrMaterials[indexPath.row]
            Functions.pushToViewController(currentViewController, toVC: vc)
        } else {
            currentViewController.view.makeToast("No image found!", duration: 1.0, position: .center)
        }
    }
}
