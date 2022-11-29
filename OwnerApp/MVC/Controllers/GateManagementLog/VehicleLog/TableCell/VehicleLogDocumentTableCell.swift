//
//  VehicleLogDocumentTableCell.swift
//  EmployeeApp
//
//  Created by Jailove on 22/06/22.
//

import UIKit
import SDWebImage

class VehicleLogDocumentTableCell: UITableViewCell {

    @IBOutlet weak var vwChallanNumber: UIView!
    @IBOutlet weak var vwPONumber: UIView!
    @IBOutlet weak var viewExitMaterialStatus: UIView!
    @IBOutlet weak var viewPurposeOfOutPass: UIView!
    @IBOutlet weak var viewRemark: UIStackView!
    
    @IBOutlet weak var collectionVehicleMeterialList: UICollectionView!
    @IBOutlet weak var vwMaterial: UIView!
    @IBOutlet weak var vwMaterialView: UIStackView!
    @IBOutlet weak var materialimagemsg: UILabel!
    var imageArrVehicleMeterial = [ExitAttechment]()
    
    @IBOutlet weak var collectionInwardChallanList: UICollectionView!
    @IBOutlet weak var vwInwardImage: UIView!
    var imageArrInwardChallan = [Document]()
    
    @IBOutlet weak var collectionOutWardChallanList: UICollectionView!
    @IBOutlet weak var vwOutwardChallan: UIView!
    var imageArrOutWardChallanImage = [ExitEntry]()
    
    @IBOutlet weak var lblChallanNumber: UITextField!
    @IBOutlet weak var lblPONumber: UITextField!
    @IBOutlet weak var txtFieldExitMaterialStatus: UITextField!
    @IBOutlet weak var txtFieldPurposeOfOutPass: UITextField!
    @IBOutlet weak var txtFieldRemarks: UILabel!
    
    @IBOutlet weak var outPassImage: UIImageView!
    @IBOutlet weak var vwOutPassImage: UIView!
    
    @IBOutlet weak var vwChalanDetail: UIView!
    @IBOutlet weak var vwExitmaterialDetail: UIView!
    @IBOutlet weak var vwPurposeOfOutpassDetail: UIView!
    @IBOutlet weak var vwRemakDetail: UIStackView!
    @IBOutlet weak var vwPONumberDetail: UIView!
    
    @IBOutlet weak var outPassImageBtn: UIButton!
    
    @IBOutlet weak var vwChalanDetail1: UIStackView!
    @IBOutlet weak var vwPONumberDetail1: UIStackView!

    @IBOutlet weak var lblChallanMsg: UILabel!
    @IBOutlet weak var lblPONumberMsg: UILabel!
    @IBOutlet weak var lblPOImageMsg: UILabel!
    @IBOutlet weak var lblInvoiceImageMsg: UILabel!

    var documentArr = [Document]()
    var currentViewController: UIViewController = UIViewController()
    
    @IBOutlet weak var collectionPOImageList: UICollectionView!
    var imageArrPOImages = [String]()
    
    @IBOutlet weak var collectionInvoiceList: UICollectionView!
    
    @IBOutlet weak var POImagesView: UIStackView!
    @IBOutlet weak var invoiceImagesView: UIStackView!

    var imageArrInvoices = [String]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vwChallanNumber.layer.cornerRadius = 10
        vwChallanNumber.layer.borderWidth = 1
        vwChallanNumber.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

        viewExitMaterialStatus.layer.cornerRadius = 10
        viewExitMaterialStatus.layer.borderWidth = 1
        viewExitMaterialStatus.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        viewPurposeOfOutPass.layer.cornerRadius = 10
        viewPurposeOfOutPass.layer.borderWidth = 1
        viewPurposeOfOutPass.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        viewRemark.layer.cornerRadius = 10
        viewRemark.layer.borderWidth = 1
        viewRemark.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        vwPONumber.layer.cornerRadius = 10
        vwPONumber.layer.borderWidth = 1
        vwPONumber.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        if collectionInwardChallanList != nil {
            collectionInwardChallanList.delegate = self
            collectionInwardChallanList.dataSource = self
        }
        
        if collectionOutWardChallanList != nil {
            collectionOutWardChallanList.delegate = self
            collectionOutWardChallanList.dataSource = self
        }
        
        if collectionVehicleMeterialList != nil {
            collectionVehicleMeterialList.delegate = self
            collectionVehicleMeterialList.dataSource = self
        }
        
        if collectionPOImageList != nil {
            collectionPOImageList.delegate = self
            collectionPOImageList.dataSource = self
        }
        
        if collectionInvoiceList != nil {
            collectionInvoiceList.delegate = self
            collectionInvoiceList.dataSource = self
        }
              
        if self.documentArr.count > 0 {
            collectionVehicleMeterialList.reloadData()
            collectionInwardChallanList.reloadData()
            collectionOutWardChallanList.reloadData()
        }
        
        if self.imageArrPOImages.count > 0 {
            collectionPOImageList.reloadData()
        }
        if self.imageArrInvoices.count > 0 {
            collectionInvoiceList.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension VehicleLogDocumentTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.isEqual(self.collectionInwardChallanList){
            return self.imageArrInwardChallan.count
        }
       
        if collectionView.isEqual(self.collectionOutWardChallanList){
            return self.imageArrOutWardChallanImage.count
        }
        if collectionView.isEqual(self.collectionVehicleMeterialList){
            return self.imageArrVehicleMeterial.count
        }
        if collectionView.isEqual(self.collectionPOImageList){
            return self.imageArrPOImages.count
        }
        if collectionView.isEqual(self.collectionInvoiceList){
            return self.imageArrInvoices.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.isEqual(self.collectionPOImageList) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "POImageCollectionCell", for: indexPath) as! VehicleLogInwardAndOutWardCollectionCell
            DispatchQueue.main.async {
                cell.imgView.round(corners: [.topLeft,.topRight, .bottomRight, .bottomLeft], cornerRadius: 4)
                cell.imgView.contentMode = .scaleAspectFill
            }
            if self.imageArrPOImages[indexPath.row] != "" {
                cell.imgView.sd_setImage(with: URL(string: self.imageArrPOImages[indexPath.row]), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached, completed: nil)
            }
            return cell
        }
        if collectionView.isEqual(self.collectionInvoiceList) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvoiceCollectionCell", for: indexPath) as! VehicleLogInwardAndOutWardCollectionCell
            DispatchQueue.main.async {
                cell.imgView.round(corners: [.topLeft,.topRight, .bottomRight, .bottomLeft], cornerRadius: 4)
                cell.imgView.contentMode = .scaleAspectFill
            }
            if self.imageArrInvoices[indexPath.row] != "" {
                cell.imgView.sd_setImage(with: URL(string: self.imageArrInvoices[indexPath.row]), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached, completed: nil)
            }
            return cell
        }
        var obj : Document? = nil
        var objExitAttachment : ExitAttechment? = nil
        var objExitEntry : ExitEntry? = nil
        if collectionView.isEqual(self.collectionInwardChallanList) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehicleLogInwardAndOutWardCollectionCell", for: indexPath) as! VehicleLogInwardAndOutWardCollectionCell
            obj = self.imageArrInwardChallan[indexPath.row]
            
            DispatchQueue.main.async {
                cell.imgView.round(corners: [.topLeft,.topRight, .bottomRight, .bottomLeft], cornerRadius: 4)
                cell.imgView.contentMode = .scaleAspectFill
            }
            if obj?.url != "" {
                cell.imgView.sd_setImage(with: URL(string:obj?.url ?? ""), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached, completed: nil)
            }
            return cell
        }
       
        if collectionView.isEqual(self.collectionOutWardChallanList) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehicleLogInwardAndOutWardCollectionCell", for: indexPath) as! VehicleLogInwardAndOutWardCollectionCell
            objExitEntry = self.imageArrOutWardChallanImage[indexPath.row]
            
            DispatchQueue.main.async {
                cell.imgView.round(corners: [.topLeft,.topRight, .bottomRight, .bottomLeft], cornerRadius: 4)
                cell.imgView.contentMode = .scaleAspectFill
            }
            if objExitEntry?.challan != "" {
                cell.imgView.sd_setImage(with: URL(string:objExitEntry?.challan ?? ""), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached,
                                      completed: nil)
            }
            return cell
        }
        
        if collectionView.isEqual(self.collectionVehicleMeterialList) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehicleLogMaterialCollectionCell", for: indexPath) as! VehicleLogMaterialCollectionCell
           
            objExitAttachment = self.imageArrVehicleMeterial[indexPath.row]
           
            DispatchQueue.main.async {
                cell.imgMaterial.round(corners: [.topLeft,.topRight, .bottomRight, .bottomLeft], cornerRadius: 4)
                cell.imgMaterial.contentMode = .scaleAspectFill
            }
            if objExitAttachment?.attechment != "" {
                cell.imgMaterial.sd_setImage(with: URL(string:objExitAttachment?.attechment ?? ""), placeholderImage: UIImage(named: "nopreview"),
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
        var imageURL = ""
        if collectionView.isEqual(self.collectionPOImageList) {
           imageURL = self.imageArrPOImages[indexPath.row]
        } else if collectionView.isEqual(self.collectionInvoiceList) {
            imageURL = self.imageArrInvoices[indexPath.row]
        } else if collectionView.isEqual(self.collectionInwardChallanList) {
            imageURL = self.imageArrInwardChallan[indexPath.row].url
        } else if collectionView.isEqual(self.collectionOutWardChallanList) {
            imageURL = self.imageArrOutWardChallanImage[indexPath.row].challan
        } else if collectionView.isEqual(self.collectionVehicleMeterialList) {
            imageURL = self.imageArrVehicleMeterial[indexPath.row].attechment
        }
        if !imageURL.isEmpty, let vc = UIStoryboard(name: "Vehicle", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController {
            vc.imageURL = imageURL
            Functions.pushToViewController(currentViewController, toVC: vc)
        } else {
            currentViewController.view.makeToast("No image found!", duration: 1.0, position: .center)
        }
    }
}
