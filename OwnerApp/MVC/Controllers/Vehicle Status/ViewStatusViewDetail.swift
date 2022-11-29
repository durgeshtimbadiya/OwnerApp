//
//  ViewStatusViewDetail.swift
//  EmployeeApp
//
//  Created by Jailove on 17/06/22.
//

import UIKit

class ViewStatusViewDetail: UIViewController {
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
    var site_id = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.GetVehicleEntryApi(UserId: appDelegate.userLoginAccessDetails?.id ?? "", entryId: objApproval?.id ?? "")
        lblSiteName.text = self.site_Name
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
                                self.imageArrVehicleMeterial = [Document]()
                                if let exits = self.vehicleDetail?.exitAttechment, exits.count > 0 {
                                    exits.forEach { object in
                                        if object.type == "5", let att = object.attechment, !att.isEmpty {
                                            self.imageArrVehicleMeterial.append(Document(fromDictionary: ["type": "5", "url": att]))
                                        }
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
    
    func indexPathsForSections() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        for row in 0..<self.tableViewData[3].count {
            indexPaths.append(IndexPath(row: row,
                                        section: 3))
        }
        
        return indexPaths
    }
    
    @objc private func tapOnImage(_ sender: UIButton) {
        //1 - Outpass
        //2 - Invoice
        //3 - Outward Chalan
        var imageURL = ""
        if sender.tag == 1, let url = self.vehicleDetail?.exit[0].outpass, !url.isEmpty {
            imageURL = url
        } else if sender.tag == 2, let url = self.vehicleDetail?.invoiceImg, !url.isEmpty {
            imageURL = url
        } else if sender.tag == 3, let exits = self.vehicleDetail?.exit, exits.count > 0, let challanImage = exits[0].challan, !challanImage.isEmpty  {
            imageURL = challanImage
        }
        if !imageURL.isEmpty, let vc = UIStoryboard(name: "Vehicle", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController {
            vc.imageURL = imageURL
            Functions.pushToViewController(self, toVC: vc)
        } else {
            self.view.makeToast("No image found!", duration: 1.0, position: .center)
        }
    }

}
extension ViewStatusViewDetail : UITableViewDelegate, UITableViewDataSource{
  
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
        
        if indexPath.section == 0 {
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
            
            return cell!
        }
        else if indexPath.section == 2 {
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
            
            if let challanNo = self.vehicleDetail?.challanNumber {
                cell?.vwChalanDetail.isHidden = false
                cell?.lblChallanNumber.text = challanNo
            } else {
                cell?.vwChalanDetail.isHidden = true
            }
            
            if self.imageArrInwardChallan.count > 0 {
                cell?.vwInwardImage.isHidden = false
                cell?.imageArrInwardChallan = self.imageArrInwardChallan
            } else {
                cell?.vwInwardImage.isHidden = true
            }
            
            if let exits = self.vehicleDetail?.exit, exits.count > 0, let challanImage = exits[0].challan, !challanImage.isEmpty  {
                cell?.vwOutwordImageDetail.isHidden = false
                cell?.outwordImage.sd_setImage(with: URL(string: challanImage), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached, completed: nil)
            } else {
                cell?.vwOutwordImageDetail.isHidden = true
            }
            
            cell?.vwMaterial.isHidden = true
            if let exitMaterialStatus = self.vehicleDetail?.exit[0].materialStatus {
                    cell?.vwMaterial.isHidden = false
                if exitMaterialStatus == "1" {
                    cell?.txtFieldExitMaterialStatus.text = "Exit with Material"
                } else if exitMaterialStatus == "0" {
                    cell?.txtFieldExitMaterialStatus.text = "Exit Without Material"
                } else {
                    cell?.txtFieldExitMaterialStatus.text = "Exit Without Material"
                }
            }
            
            if let purposeOfOutPass = self.vehicleDetail?.exit[0].purposeOfOutPass {
                cell?.viewPurposeOfOutPass.isHidden = false
                if purposeOfOutPass == "1" {
                    cell?.txtFieldPurposeOfOutPass.text = "Rejected"
                }
                else if purposeOfOutPass == "2" {
                    cell?.txtFieldPurposeOfOutPass.text = "Replaced"
                }
                else if purposeOfOutPass == "3" {
                    cell?.txtFieldPurposeOfOutPass.text = "Repairing"
                }
                else if purposeOfOutPass == "4" {
                    cell?.txtFieldPurposeOfOutPass.text = "Ignore With Remark"
                }
                else if purposeOfOutPass == "5" {
                    cell?.txtFieldPurposeOfOutPass.text = "Returnable"
                } else {
                    cell?.viewPurposeOfOutPass.isHidden = true
                }
            } else {
                cell?.viewPurposeOfOutPass.isHidden = true
            }
            
            cell?.viewRemark.isHidden = true
            if let remarks = self.vehicleDetail?.exit[0].materialRejectRemark, !remarks.isEmpty {
                cell?.viewRemark.isHidden = false
                cell?.lblRemarkM.text = remarks
            }
            
            cell?.vwOutPassImage.isHidden = true
            if let url = self.vehicleDetail?.exit[0].outpass, !url.isEmpty {
                cell?.vwOutPassImage.isHidden = false
                cell?.outPassImage.sd_setImage(with: URL(string:url), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached, completed: nil)
            }
                        
            cell?.vwMaterialImageDetail.isHidden = true
            if self.imageArrVehicleMeterial.count > 0 {
                cell?.vwMaterialImageDetail.isHidden = false
                cell?.imageArrVehicleMeterial = self.imageArrVehicleMeterial
            }
        
            if self.imageArrPoImage.count > 0 {
                cell?.viewPOImg.isHidden = false
                cell?.imageArrPOImage = self.imageArrPoImage
            } else {
                cell?.viewPOImg.isHidden = true
            }
            
            cell?.viewInvoice.isHidden = true
            if let url = self.vehicleDetail?.invoiceImg, !url.isEmpty {
                cell?.viewInvoice.isHidden = false
                cell?.imgInvoice.sd_setImage(with: URL(string:url), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached, completed: nil)
            }
            
            if let Po = self.vehicleDetail?.poNumber {
//                cell?.vwPONumberDetail.isHidden = false
                cell?.lblPONumber.text = Po
            } else {
//                cell?.vwPONumberDetail.isHidden = true
            }
            
            /*var ask_approval_exit = ""
            var exit_status = ""
            let entry = self.vehicleDetail?.entry ?? ""
            var exitMaterialStatus = ""
            if let exitEntry =  self.vehicleDetail?.exit, let exitDetail = exitEntry.first {
                ask_approval_exit = exitDetail.askApproval
                exit_status = exitDetail.exitStatus
            }
            if let exitMaterialStatus1 = self.vehicleDetail?.exit[0].materialStatus {
                exitMaterialStatus = exitMaterialStatus1
            }
            cell?.vwRemakDetail.isHidden = true
            cell?.vwExitmaterialDetail.isHidden = true
            cell?.vwPurposeOfOutpassDetail.isHidden = true
            if ask_approval_exit == "1" && exit_status == "0" {
                if exitMaterialStatus == "0" {
                    cell?.vwExitmaterialDetail.isHidden = false
                } else if exitMaterialStatus == "1" {
                    cell?.vwRemakDetail.isHidden = true
                    cell?.vwExitmaterialDetail.isHidden = false
                    cell?.vwPurposeOfOutpassDetail.isHidden = false
                }
            } else if ask_approval_exit == "1" && exit_status == "1" && entry == "1" {
                if exitMaterialStatus == "0" {
                    cell?.vwRemakDetail.isHidden = true
                    cell?.vwExitmaterialDetail.isHidden = false
                } else if exitMaterialStatus == "1" {
                    cell?.vwRemakDetail.isHidden = true
                    cell?.vwExitmaterialDetail.isHidden = false
                    cell?.vwPurposeOfOutpassDetail.isHidden = false
                }
            }*/
            return cell!
        }
        
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityDetailCell", for: indexPath) as? ActivityDetailCell
            
            let askApproval = self.vehicleDetail?.askApproval ?? ""
            let entryStatus = self.vehicleDetail?.status ?? ""
            let entry = self.vehicleDetail?.entry ?? ""
            cell?.lblEntryStatus.text = ""

            if askApproval == "1" {
                cell?.lblEntryStatus.text = "Asked Approval"
            } else if entryStatus == "0" && askApproval == "0" && entry == "1" {
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
            
            if self.vehicleDetail?.askApproval == "1" && self.vehicleDetail?.entry == "0" && self.vehicleDetail?.status == "0" {
                cell?.lblEntryApprovalName.text = "Pending"
                cell?.lblEntryApprovalName.textColor = UIColor.systemRed
                cell?.lblEntryApprovalTime.text = "Pending"
                cell?.lblEntryApprovalTime.textColor = UIColor.systemRed
                cell?.lblEntryApprovalDate.text = "Pending"
                cell?.lblEntryApprovalDate.textColor = UIColor.systemRed
            } else {
                cell?.lblEntryApprovalName.text = self.vehicleDetail?.approvedBy ?? ""
                let dateTimeArr = (self.vehicleDetail?.approvalDate ?? "").components(separatedBy: " ")
                if dateTimeArr.count > 1 {
                    cell?.lblEntryApprovalDate.text = dateTimeArr[0]
                    cell?.lblEntryApprovalTime.text = dateTimeArr[1]
                } else {
                    cell?.lblEntryApprovalTime.text = self.vehicleDetail?.approvalDate ?? ""
                }
            }
            cell?.entryApprovedView.isHidden = true
            if self.vehicleDetail?.approvedBy != "" && self.vehicleDetail?.approvedBy != "0" && self.vehicleDetail?.approvedBy.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "") != "" {
                cell?.entryApprovedView.isHidden = false
            }
            
            if self.vehicleDetail?.entry == "0" {
                cell?.lblEntryGrantedName.text = "Pending"
                cell?.lblEntryGrantedName.textColor = UIColor.systemRed
                cell?.lblEntryGrantedTime.text = "Pending"
                cell?.lblEntryGrantedTime.textColor = UIColor.systemRed
                cell?.lblEntryGrantedDate.text = "Pending"
                cell?.lblEntryGrantedDate.textColor = UIColor.systemRed
            } else {
                cell?.lblEntryGrantedName.text = "\(self.vehicleDetail?.entryBySecurity ?? "") (Gate)"
                let dateTimeArr = (self.vehicleDetail?.updatedDate ?? "").components(separatedBy: " ")
                if dateTimeArr.count > 1 {
                    cell?.lblEntryGrantedDate.text = dateTimeArr[0]
                    cell?.lblEntryGrantedTime.text = dateTimeArr[1]
                } else {
                    cell?.lblEntryGrantedTime.text = self.vehicleDetail?.updatedDate ?? ""
                }
            }
            
            if let exitEntry =  self.vehicleDetail?.exit, let exitDetail = exitEntry.first {
                
                let exitStatus = exitDetail.exitStatus ?? ""
                let askExitApproval = exitDetail.askApproval ?? ""                
                if askExitApproval == "1" && exitStatus == "0" {
                    cell?.lblApprovalForExit.text = "Approval For Exit"
                } else if askExitApproval == "0" && exitStatus == "1" {
                    cell?.lblApprovalForExit.text = "Direct Exit"
                } else if exitStatus == "1" && vehicleDetail?.entry == "1" {
                    cell?.lblApprovalForExit.text = "Approval For Exit"
                } else {
                    cell?.lblApprovalForExit.text = ""
                }
                
//                if exitDetail.exitStatus == "1" {
//                    cell?.lblApprovalForExit.text = "Vehicle Exited"
//                }
                cell?.exitApprovedView.isHidden = true

                if exitDetail.approvedBy != nil && exitDetail.approvedBy != "" && exitDetail.approvedBy != "0" {
                    cell?.exitApprovedView.isHidden = false
                }
                cell?.lblExitAprrovalName.text = exitDetail.approvedBy ?? ""
                let dateTimeArr = (exitDetail.approvedDate ?? "").components(separatedBy: " ")
                if dateTimeArr.count > 1 {
                    cell?.lblExitApprovalDate.text = dateTimeArr[0]
                    cell?.lblExitApprovalTime.text = dateTimeArr[1]
                } else {
                    cell?.lblExitApprovalTime.text = exitDetail.approvedDate ?? ""
                }
                
                cell?.lblExitGrantName.text = "\(exitDetail.exitBySecurity ?? "") (Gate)"
                let dateTimeArr1 = (exitDetail.updatedDate ?? "").components(separatedBy: " ")
                if dateTimeArr1.count > 1 {
                    cell?.lblExitGrantDate.text = dateTimeArr1[0]
                    cell?.lblExitGrantTime.text = dateTimeArr1[1]
                } else {
                    cell?.lblExitGrantTime.text = exitDetail.updatedDate ?? ""
                }
            }
            return cell!

        }
        else{
            let cell = UITableViewCell()
            cell.textLabel?.text = self.tableViewData[indexPath.section][indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 1 {
            return 300
        }
//        else if indexPath.section == 3 {
//            return 1000
//        }
//        else{
        return UITableView.automaticDimension
//        }
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

    @objc
    private func hideSection(sender: UIButton) {
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
