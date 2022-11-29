//
//  DocumentDetailCell.swift
//  EmployeeApp
//
//  Created by Bhupendra Shekhawat on 25/03/22.
//

import UIKit

class DocumentDetailCell: UITableViewCell {

    @IBOutlet weak var vwChallanNumber: UIView!
    @IBOutlet weak var viewMainPO: UIView!
    @IBOutlet weak var vwPONumber: UIView!
    @IBOutlet weak var viewExitMaterialStatus: UIView!
    @IBOutlet weak var viewPurposeOfOutPass: UIView!
    @IBOutlet weak var viewRemark: UIStackView!
    
    @IBOutlet weak var innerRemarkStackview: UIStackView!
    @IBOutlet weak var lblRemarkM: UILabel!

    @IBOutlet weak var collectionVehicleMeterialList: UICollectionView!
    @IBOutlet weak var vwMaterial: UIView!
    @IBOutlet weak var imgMaterialImg: UIImageView!
    var imageArrVehicleMeterial = [Document]()
    

    @IBOutlet weak var collectionInwardChallanList: UICollectionView!
    @IBOutlet weak var vwInwardImage: UIView!
    var imageArrInwardChallan = [Document]()
    
    @IBOutlet weak var collectionOutWardChallanList: UICollectionView!
    @IBOutlet weak var vwOutwardChallan: UIView!
    var imageArrOutWardChallanImage = [Document]()
    var imageArrPOImage = [Document]()
    
    
    @IBOutlet weak var lblChallanNumber: UITextField!
    @IBOutlet weak var lblPONumber: UITextField!
    @IBOutlet weak var txtFieldExitMaterialStatus: UITextField!
    @IBOutlet weak var txtFieldPurposeOfOutPass: UITextField!
    @IBOutlet weak var txtFieldRemarks: UITextField!
    
    @IBOutlet weak var outPassImage: UIImageView!
    @IBOutlet weak var vwOutPassImage: UIView!
    
    @IBOutlet weak var outPassImageBtn: UIButton!
    @IBOutlet weak var imgInvoiceBtn: UIButton!
    @IBOutlet weak var outwordImageBtn: UIButton!

    @IBOutlet weak var viewInvoice: UIView!
    @IBOutlet weak var imgInvoice: UIImageView!

    @IBOutlet weak var viewPOImg: UIView!
    @IBOutlet weak var collectionPOList: UICollectionView!
    
    @IBOutlet weak var viewMaterialSingleIng: UIView!
    @IBOutlet weak var imgSingleMaterialImg: UIImageView!
    
    
    //TextField Outer View Functionality-------------->
    @IBOutlet weak var InnerExitMaterialStatus: UIView!
    @IBOutlet weak var InnerPurposeofOutPassView: UIView!
    @IBOutlet weak var InnerReviewRemark: UIView!

    
    @IBOutlet weak var vwChalanDetail: UIView!
    @IBOutlet weak var vwOutwordImageDetail: UIView!
    @IBOutlet weak var outwordImage: UIImageView!
    @IBOutlet weak var vwMaterialImageDetail: UIView!
    @IBOutlet weak var vwPONumberDetail: UIView!
    
    var documentArr = [Document]()
    var currentViewController: UIViewController = UIViewController()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if vwChallanNumber != nil {
            vwChallanNumber.layer.cornerRadius = 10
            vwChallanNumber.layer.borderWidth = 1
            vwChallanNumber.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        }
        if InnerExitMaterialStatus != nil {
            InnerExitMaterialStatus.layer.cornerRadius = 10
            InnerExitMaterialStatus.layer.borderWidth = 1
            InnerExitMaterialStatus.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        }
        if InnerPurposeofOutPassView != nil {
            InnerPurposeofOutPassView.layer.cornerRadius = 10
            InnerPurposeofOutPassView.layer.borderWidth = 1
            InnerPurposeofOutPassView.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        }
        
        if InnerReviewRemark != nil {
            InnerReviewRemark.layer.cornerRadius = 10
            InnerReviewRemark.layer.borderWidth = 1
            InnerReviewRemark.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        }
        
        if innerRemarkStackview != nil {
            innerRemarkStackview.layer.cornerRadius = 10
            innerRemarkStackview.layer.borderWidth = 1
            innerRemarkStackview.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        }
        
        if vwPONumber != nil {
            vwPONumber.layer.cornerRadius = 10
            vwPONumber.layer.borderWidth = 1
            vwPONumber.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        }
        
//        if viewExitMaterialStatus != nil {
//            viewExitMaterialStatus.layer.cornerRadius = 10
//            viewExitMaterialStatus.layer.borderWidth = 1
//            viewExitMaterialStatus.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
//        }

        
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
        
        if collectionPOList != nil {
            collectionPOList.delegate = self
            collectionPOList.dataSource = self
        }
              
        if self.documentArr.count > 0{
            collectionVehicleMeterialList.reloadData()
            collectionInwardChallanList.reloadData()
            collectionOutWardChallanList.reloadData()
            collectionPOList.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension DocumentDetailCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        if collectionView.isEqual(self.collectionPOList){
            return self.imageArrPOImage.count
        }
       
       
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        var obj : Document? = nil
        if collectionView.isEqual(self.collectionInwardChallanList){
            obj = self.imageArrInwardChallan[indexPath.item]
        }
       
        if collectionView.isEqual(self.collectionOutWardChallanList){
            obj = self.imageArrOutWardChallanImage[indexPath.item]
        }
        
        if collectionView.isEqual(self.collectionVehicleMeterialList){
            obj = imageArrVehicleMeterial[indexPath.item]
        }
        
        if collectionView.isEqual(self.collectionPOList){
            obj = imageArrPOImage[indexPath.item]
        }
        
       
        DispatchQueue.main.async {
            cell.imgOutward.contentMode = .scaleAspectFill
        }
        if obj?.url != "" {
            cell.imgOutward.sd_setImage(with: URL(string:obj?.url ?? ""), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached, completed: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let width = (collectionView.frame.size.width - 20) / 2.1
       return CGSize(width: 135, height: 135)
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
        if collectionView.isEqual(self.collectionInwardChallanList){
            imageURL = self.imageArrInwardChallan[indexPath.item].url
        } else if collectionView.isEqual(self.collectionOutWardChallanList){
            imageURL = self.imageArrOutWardChallanImage[indexPath.item].url
        } else if collectionView.isEqual(self.collectionVehicleMeterialList){
            imageURL = imageArrVehicleMeterial[indexPath.item].url
        } else if collectionView.isEqual(self.collectionPOList){
            imageURL = imageArrPOImage[indexPath.item].url
        }
        if !imageURL.isEmpty, let vc = UIStoryboard(name: "Vehicle", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController {
            vc.imageURL = imageURL
            Functions.pushToViewController(currentViewController, toVC: vc)
        } else {
            currentViewController.view.makeToast("No image found!", duration: 1.0, position: .center)
        }
    }
}
