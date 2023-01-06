//
//  RejectedVehicleDetailVC.swift
//  EmployeeApp
//
//  Created by Bhupendra Shekhawat on 28/03/22.
//

import UIKit
import SDWebImage

class RejectedVehicleDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblSiteName: UILabel!

    var hiddenSections = [Bool]()
    var vehicleDetail : VehicleData?
    var imageArrVehicleMeterial = [Document]()
    var imageArrInwardChallan = [Document]()
    var imageArrOutwardImage = [Document]()
    var imageArrPoImage = [Document]()
    var objApproval: ApproveModel? = nil
    let tableViewData = [
        ["1"],
        ["1"],
        ["1"],
        ["1"]
    ]
var site_Name = ""
    var site_id = "" //need to pass
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.GetVehicleEntryApi(UserId: appDelegate.userLoginAccessDetails?.id ?? "", entryId: objApproval?.id ?? "")
        self.lblSiteName.text = site_Name
        
        hiddenSections = [false, false, false, false]
    }
    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            let statusbarView = UIView()
            statusbarView.backgroundColor = AppColor.Color_TopHeader
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = AppColor.Color_TopHeader
        }
    }
    
    func indexPathsForSections() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        for row in 0..<self.tableViewData[3].count {
            indexPaths.append(IndexPath(row: row,
                                        section: 3))
        }
        
        return indexPaths
    }
    
    // MARK: -  Approve Vehicle Entry Api Functionality-------------------------------

    func GetVehicleEntryApi(UserId: String,entryId: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": UserId,
                          "entry_id": entryId,
                          "site_id": site_id
                          ] as [String: Any]

            Webservice.Authentication.vehicleDetailApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["code"] as? Int == 200 {
                            if let entryDetail = body["entry_detail"] as? [String: Any] {

                               if let dataObj = entryDetail["data"] as? [String:Any]{
                                   self.vehicleDetail = VehicleData(fromDictionary: dataObj)
                                }
                                
                                let arrDocument: [Document] = (self.vehicleDetail?.document)!
                                    for obj in arrDocument {
                                        if obj.type == "0"{
                                            self.imageArrVehicleMeterial.append(obj)
                                        }
                                        if obj.type == "1"{
                                            self.imageArrInwardChallan.append(obj)
                                        }
                                        if obj.type == "2"{
                                            self.imageArrOutwardImage.append(obj)
                                        }
                                        if obj.type == "3"{
                                            self.imageArrPoImage.append(obj)
                                        }
                                    }
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                case let .fail(errorMsg):
                    print(errorMsg)
                }
            }
        }
    }
    
    @IBAction func btnbackAction(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    @objc private func tapOnImage(_ sender: UIButton) {
        //1 - Outpass
        //2 - Invoice
        //3 - Outward Chalan
        if sender.tag == 2, let invImag = self.vehicleDetail?.invoiceImg, !invImag.isEmpty {
            if let vc = UIStoryboard(name: "Vehicle", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController {
                vc.imageURL = invImag
                Functions.pushToViewController(self, toVC: vc)
            }
        } else {
            self.view.makeToast("No image found!", duration: 1.0, position: .center)
        }
    }
}
extension RejectedVehicleDetailVC : UITableViewDelegate, UITableViewDataSource{
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.hiddenSections[section] {
            return 0
        }
        return self.tableViewData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "companyDetailsCell", for: indexPath) as? companyDetailsCell
            
            cell?.lblCompanyName.text = self.vehicleDetail?.companyName ?? ""
            cell?.lblRegisterMobileNumber.text = self.vehicleDetail?.companyMobile ?? ""
            cell?.lblMeterialType.text = self.vehicleDetail?.materialType ?? ""
            
            
            return cell!
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "vehicleDetailsCell", for: indexPath) as? vehicleDetailsCell
            cell?.currentViewController = self
            cell?.lblVehicleNumber.text = self.vehicleDetail?.vehicleNumber ?? ""
            cell?.lblDriverNumber.text = self.vehicleDetail?.driverContact ?? ""
            cell?.lblQtyWithUnit.text = self.vehicleDetail?.quantity ?? ""
            
            if self.imageArrVehicleMeterial.count > 0{
                cell?.vwMaterial.isHidden = false
                cell?.imageArrVehicleMeterial = self.imageArrVehicleMeterial
            }else{
                cell?.vwMaterial.isHidden = true
            }
            
            return cell!
        }
        else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentDetailCell", for: indexPath) as? DocumentDetailCell
            cell?.currentViewController = self
            if cell?.outPassImageBtn != nil {
                cell?.outPassImageBtn.tag = 1
                cell?.outPassImageBtn.addTarget(self, action: #selector(tapOnImage(_:)), for: .touchUpInside)
            }
            if cell?.imgInvoiceBtn != nil {
                cell?.imgInvoiceBtn.tag = 2
                cell?.imgInvoiceBtn.addTarget(self, action: #selector(tapOnImage(_:)), for: .touchUpInside)
            }
            if cell?.outwordImageBtn != nil {
                cell?.outwordImageBtn.tag = 3
                cell?.outwordImageBtn.addTarget(self, action: #selector(tapOnImage(_:)), for: .touchUpInside)
            }
           
            cell?.lblChallanNumber.text = ""
            if let challanNo = self.vehicleDetail?.challanNumber {
                cell?.lblChallanNumber.text = challanNo
            }
            
            if self.imageArrInwardChallan.count > 0 {
                cell?.vwInwardImage.isHidden = false
                cell?.imageArrInwardChallan = self.imageArrInwardChallan
            }else{
                cell?.vwInwardImage.isHidden = true
            }
            
            cell?.lblPONumber.text = ""
            if let Po = self.vehicleDetail?.poNumber {
                cell?.lblPONumber.text = Po
            }
            
            if self.imageArrPoImage.count > 0 {
                cell?.viewPOImg.isHidden = false
                cell?.imageArrPOImage = self.imageArrPoImage
            } else {
                cell?.viewPOImg.isHidden = true
            }
            
            cell?.vwMaterialImageDetail.isHidden = true
//            if self.imageArrVehicleMeterial.count > 0 {
//                cell?.vwMaterialImageDetail.isHidden = false
//                cell?.imageArrVehicleMeterial = self.imageArrVehicleMeterial
//            }
            
            cell?.viewInvoice.isHidden = true
            if let invImag = self.vehicleDetail?.invoiceImg, !invImag.isEmpty {
                cell?.viewInvoice.isHidden = false
                cell?.imgInvoice.sd_setImage(with: URL(string: invImag), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached, completed: nil)
            }
            
            /*if let remarks = self.vehicleDetail?.exit[0].materialRejectRemark {
                cell?.viewRemark.isHidden = false
                cell?.txtFieldRemarks.text = remarks
            } else {
                cell?.viewRemark.isHidden = true
            }
                                    
            if self.imageArrOutwardImage.count > 0 {
                cell?.vwOutwardChallan.isHidden = false
                cell?.imageArrOutWardChallanImage = self.imageArrOutwardImage
            } else {
                cell?.vwOutwardChallan.isHidden = true
            }
  
            if let exitMaterialStatus = self.vehicleDetail?.exit[0].materialStatus {
                cell?.viewExitMaterialStatus.isHidden = false
                
                if exitMaterialStatus == "1" {
                    cell?.txtFieldExitMaterialStatus.text = "Exit With Material"
                } else if exitMaterialStatus == "0" {
                    cell?.txtFieldExitMaterialStatus.text = "Exit Without Material"
                } else {
                    
                }
            } else {
                cell?.viewExitMaterialStatus.isHidden = true
            }
            
            
            
            if let url = self.vehicleDetail?.exit[0].outpass {
                cell?.vwOutPassImage.isHidden = false
                cell?.outPassImage.sd_setImage(with: URL(string:url), placeholderImage: UIImage(named: "nopreview"),
                                                                        options: .refreshCached,
                                                                        completed: nil)
            } else {
                cell?.vwOutwardChallan.isHidden = true
            }
            
            */
            
            return cell!
        }
        
        else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityRejectDetailCell", for: indexPath) as? ActivityRejectDetailCell
            
            
            let askApproval = self.vehicleDetail?.askApproval ?? ""
            let entryStatus = self.vehicleDetail?.status ?? ""
            let entry = self.vehicleDetail?.entry ?? ""
            cell?.lblEntryStatus.text = ""
            
           /* var askExitApproval = ""
            var exitStatus = ""

            if let exitObjs = self.vehicleDetail?.exit, exitObjs.count > 0 {
                askExitApproval = exitObjs[0].askApproval
                exitStatus = exitObjs[0].exitStatus
            }
*/
            if askApproval == "1" {
                cell?.lblEntryStatus.text = "Asked Approval"
            }/* else if askExitApproval == "0" && exitStatus == "1" {
                cell?.lblEntryStatus.text = "Direct Exit"
            } */else if entryStatus == "0" && askApproval == "0" && entry == "1" {
                cell?.lblEntryStatus.text = "Direct Entry"
            } else if entryStatus == "2" {
                cell?.lblEntryStatus.text = "Reject Approval"
            }
            
            cell?.lblEntrySentName.text = "\(self.vehicleDetail?.addedBy ?? "") (Gate)"
            let dateTimeArr = (self.vehicleDetail?.createdDate ?? "").components(separatedBy: " ")
            if dateTimeArr.count > 1 {
                cell?.lblEntrySentDate.text = dateTimeArr[0]
                cell?.lblEntrySentTime.text = dateTimeArr[1]
            } else {
                cell?.lblEntrySentTime.text = self.vehicleDetail?.createdDate ?? ""
            }

            cell?.lblEntryApprovalName.text = self.vehicleDetail?.approvedBy ?? ""
            let dateTimeArr1 = (self.vehicleDetail?.approvalDate ?? "").components(separatedBy: " ")
            if dateTimeArr1.count > 1 {
                cell?.lblEntryApprovalDate.text = dateTimeArr1[0]
                cell?.lblEntryApprovalTime.text = dateTimeArr1[1]
            } else {
                cell?.lblEntryApprovalTime.text = self.vehicleDetail?.approvalDate ?? ""
            }
          
            if self.vehicleDetail?.status == "2" && self.vehicleDetail?.entry == "0" {
                cell?.lblEntryRejectName.text = "Pending"
                cell?.lblEntryRejectName.textColor = UIColor.systemRed
                cell?.lblEntryRejectTime.text = "Pending"
                cell?.lblEntryRejectTime.textColor = UIColor.systemRed
                cell?.lblEntryRejectDate.text = "Pending"
                cell?.lblEntryRejectDate.textColor = UIColor.systemRed
            } else {
                cell?.lblEntryRejectName.text = "\(self.vehicleDetail?.entryBySecurity ?? "") (Gate)"
                let dateTimeArr = (self.vehicleDetail?.updatedDate ?? "").components(separatedBy: " ")
                if dateTimeArr.count > 1 {
                    cell?.lblEntryRejectDate.text = dateTimeArr[0]
                    cell?.lblEntryRejectTime.text = dateTimeArr[1]
                } else {
                    cell?.lblEntryRejectTime.text =  self.vehicleDetail?.updatedDate ?? ""
                }
            }

            return cell!
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = self.tableViewData[indexPath.section][indexPath.row]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300
        }
       else if indexPath.section == 3 {
           return 537.0//580
        }else{
        return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIButton(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width - 40, height: 60))
        let imageView = UIImageView()
        if #available(iOS 13.0, *) {
            imageView.image = UIImage(systemName: self.hiddenSections[section] ? "chevron.up" : "chevron.down")
        }
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: SCREEN_WIDTH-50, y: 0, width: 18, height: view.frame.height)
        view.addSubview(imageView)
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.width - 20, height: 60))
        if section == 0 {
            label.text = "COMPANY DETAILS"
        } else if section == 1 {
            label.text = "VEHICLE DETAILS"
        } else if section == 2 {
            label.text = "DOCUMENT DETAILS"
        } else if section == 3 {
            label.text = "ACTIVITY DETAILS"
        }

        label.textColor = .white
        view.addSubview(label)
        view.backgroundColor = AppColor.Color_TopHeader
        
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            view.round(corners: .allCorners, cornerRadius: 10)
            self.view.layoutIfNeeded()
        }
        view.tag = section
        view.addTarget(self, action: #selector(self.hideSection(sender:)), for: .touchUpInside)
        return view

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    @objc private func hideSection(sender: UIButton) {
        var isSame = false
        for hidS in 0..<hiddenSections.count {
            if hiddenSections[hidS] {
                hiddenSections[hidS] = false
                isSame = hidS == sender.tag
                self.tableView.deleteRows(at: [IndexPath(row: 0, section: hidS)], with: .fade)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                    self.tableView.reloadSections(IndexSet(integer: hidS), with: .none)
//                }
                break
            }
        }
        if !isSame {
            hiddenSections[sender.tag] = true
            self.tableView.insertRows(at: [IndexPath(row: 0, section: sender.tag)], with: .fade)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                self.tableView.reloadSections(IndexSet(integer: sender.tag), with: .none)
//            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.tableView.reloadData()
        }
    }
}
