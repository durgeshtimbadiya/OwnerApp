//
//  UpdateVehicleImageCell.swift
//  EmployeeApp
//
//  Created by Bhupendra Shekhawat on 01/04/22.
//

import UIKit

class UpdateVehicleImageCell: UITableViewCell {

    @IBOutlet weak var commercialVehImgView: UIStackView!
    @IBOutlet weak var poImageView: UIStackView!
    @IBOutlet weak var invoiceView: UIStackView!
    @IBOutlet weak var materialImageView: UIStackView!

    @IBOutlet weak var collectionCommVehicle: UICollectionView!
    
    private var arrCommercialVehicleImg = [ImageModel]()
    private var arrPOImage = [ImageModel]()
    private var arrMaterialImage = [ImageModel]()
    
    @IBOutlet weak var collectionPoImage: UICollectionView!
    @IBOutlet weak var collectionMaterialImage: UICollectionView!
    @IBOutlet weak var invoiceImageView: UIImageView!

    @IBOutlet weak var commerVehiButton: UIButton!
    @IBOutlet weak var poImageButton: UIButton!
    @IBOutlet weak var invoiceImgButton: UIButton!
    @IBOutlet weak var materialImgButton: UIButton!

    @IBOutlet weak var commerVehiButton1: UIButton!
    @IBOutlet weak var poImageButton1: UIButton!
    @IBOutlet weak var invoiceImgButton1: UIButton!
    @IBOutlet weak var materialImgButton1: UIButton!
    
    private var selectorsCollection = [Selector]()
    private var targetAction: Any?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        collectionCommVehicle.dataSource = self
//        collectionCommVehicle.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(_ commerVehi: [ImageModel], poimages: [ImageModel], materialImages: [ImageModel], selectors: [Selector], target: Any) {
        self.arrCommercialVehicleImg = commerVehi
        self.arrPOImage = poimages
        self.arrMaterialImage = materialImages
        selectorsCollection = selectors
        targetAction = target
        self.collectionCommVehicle.isHidden = self.arrCommercialVehicleImg.count <= 0
        self.collectionPoImage.isHidden = self.arrPOImage.count <= 0
        self.collectionMaterialImage.isHidden = self.arrMaterialImage.count <= 0
        if self.arrCommercialVehicleImg.count > 0 {
                self.collectionCommVehicle.reloadData()
        }
        if self.arrPOImage.count > 0 {
            self.collectionPoImage.reloadData()
        }
        if self.arrMaterialImage.count > 0 {
            self.collectionMaterialImage.reloadData()
        }
    }
}

//MARK:-
extension UpdateVehicleImageCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionCommVehicle {
            return arrCommercialVehicleImg.count
        }
        if collectionView == self.collectionPoImage {
            return arrPOImage.count
        }
        if collectionView == self.collectionMaterialImage {
            return arrMaterialImage.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        if collectionView == self.collectionCommVehicle {
            let obj = self.arrCommercialVehicleImg[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "materialImageCell", for: indexPath) as? materialImageCell
            
            DispatchQueue.main.async {
                cell?.imgView?.contentMode = .scaleAspectFill
            }
            cell?.imgView?.image = obj.image
            cell?.deleteImg?.tag = indexPath.row
            cell?.deleteImg?.addTarget(targetAction, action: selectorsCollection[0], for: .touchUpInside)

            return cell!
        }
        
        if collectionView == self.collectionPoImage {
            let obj = self.arrPOImage[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "materialImageCell", for: indexPath) as? materialImageCell
            
            DispatchQueue.main.async {
                cell?.imgView?.contentMode = .scaleAspectFill
            }
            cell?.imgView?.image = obj.image
            cell?.deleteImg?.tag = indexPath.row
            cell?.deleteImg?.addTarget(targetAction, action: selectorsCollection[1], for: .touchUpInside)

            return cell!
        }
        
        if collectionView == self.collectionMaterialImage {
            let obj = self.arrMaterialImage[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "materialImageCell", for: indexPath) as? materialImageCell
            
            DispatchQueue.main.async {
                cell?.imgView?.contentMode = .scaleAspectFill
            }
            cell?.imgView?.image = obj.image
            cell?.deleteImg?.tag = indexPath.row
            cell?.deleteImg?.addTarget(targetAction, action: selectorsCollection[2], for: .touchUpInside)

            return cell!
        }

        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

//            let width = (collectionView.frame.size.width - 20) / 2.1
        return CGSize(width: 135.0, height: 135.0)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//        return 5
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//    }

   
}
