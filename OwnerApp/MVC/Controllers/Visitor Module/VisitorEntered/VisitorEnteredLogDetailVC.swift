//
//  VisitorEnteredLogDetailVC.swift
//  EmployeeApp
//
//  Created by Jailove on 15/07/22.


import UIKit
import AVFoundation
import SDWebImage

class VisitorEnteredLogDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblSiteName: UILabel!

    var hiddenSections = [Bool]()
    var vehicleDetail : VisitorLogGateModel?
    var imageArrVehicleMeterial = [VisitorDocument]()
    var imageArrInwardChallan = [VisitorDocument]()
    var imageArrOutwardImage = [ExitEntry]()
    var objApproval: VisitorApprovalModel? = nil
    var site_Name = ""
    var site_id = ""
    var isApprovalForExit : Bool = false

    var selectImageFrom = ""
    var arrOutpassImage = [ImageModel]()
    var arrMeterialImage = [ImageModel]()
    var selectedExitOption = ""
    var purposeStr = ""
    var ignoreWithRemark = ""

    var outpassImageArrStr = [String]()
    var materialImageArrStr = [String]()
    var visitor_Image : String!
    var outward_challan_Image : String!
    var dataObj = NSDictionary()
    
    // Picker
    enum PickerType : String {
        case option
        case purpose
    }
    
    var currentPickerType : PickerType?
    var arrOption = ["Exit With Material","Exit Without Material"]
    var arrPurpose = ["Returnable","Rejected","Replaced","Repairing","Ignore With Remark"]
   
    let tableViewData = [
        ["1"],
        ["1"],
        ["1"],
        ["1"]
    ]
    
    let tableViewDataWithExit = [
        ["1"],
        ["1"],
        ["1"],
        ["1"],
        ["1"]
    ]
    
    var isMaterialStatusFrom : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.lblSiteName.text = site_Name
        
        hiddenSections = [false, false, false, false]
        if isApprovalForExit {
            self.hiddenSections.append(false)
        }
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
        self.GetVehicleEntryApi(UserId: appDelegate.userLoginAccessDetails?.id ?? "", entryId: objApproval?.id ?? "")

    }
    
    func indexPathsForSections() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        for row in 0..<self.tableViewData[3].count {
            indexPaths.append(IndexPath(row: row,
                                        section: 3))
        }
        
        return indexPaths
    }
    
    func indexPathsForSectionss() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        for row in 0..<self.tableViewDataWithExit[4].count {
            indexPaths.append(IndexPath(row: row,
                                        section: 4))
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

            Webservice.Authentication.visitorDetailLogApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["code"] as? Int == 200 {
                            if let entryDetail = body["entry_detail"] as? [String: Any] {

                                self.dataObj = entryDetail["data"] as! NSDictionary
                                self.imageArrVehicleMeterial = [VisitorDocument]()
                               if let dataObj = entryDetail["data"] as? [String:Any]{
                                   self.vehicleDetail = VisitorLogGateModel(fromDictionary: dataObj)
                                }
                                
//                                let arrExitAttachment: [Exit] = (self.vehicleDetail?.exit)!
//                                for obj in arrExitAttachment {
//                                    self.imageArrVehicleMeterial.append(obj)
//                                }
//
//                                let arrOutWard: [Exit] = (self.vehicleDetail?.exit)!
//
//                                for obj in arrOutWard {
//                                    self.imageArrOutwardImage.append(obj)
//                                }
                                
                                let arrDocument: [VisitorDocument] = (self.vehicleDetail?.document)!
                                    for obj in arrDocument {
                                        
                                        if obj.type == "5"{
                                            self.imageArrVehicleMeterial.append(obj)
                                        }
                                        
//                                        if obj.type == "1"{
//                                            self.imageArrInwardChallan.append(obj)
//                                        }
                                        
                                        if obj.type == "0" {
                                            self.visitor_Image = obj.url
                                        }
                                        
//                                        if obj.type == "3"{
//                                            self.imageArrOutwardImage.append(obj)
//                                        }
                                    }
                                
                                DispatchQueue.main.async {
                                    self.view.layoutIfNeeded()
                                    self.tableView.dataSource = self
                                    self.tableView.delegate = self
                                    self.tableView.reloadData()
                                    self.view.layoutIfNeeded()
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
    
    func showPicker(type:PickerType) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 280,height: 280)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 280, height: 280))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: nil, message:"Choose Exit \(type)", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            let row = pickerView.selectedRow(inComponent: 0)
            guard  let exitViewCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? ExitVehicleCell else { return }

            if type == .option {
                if self.arrOption.count > 0 {
                    let element = self.arrOption[row]
                    exitViewCell.txtExitOption.text = element
                    self.selectedExitOption = element
                }
                else { return }
            }
            else if type == .purpose {
                if self.arrPurpose.count > 0 {
                    let element = self.arrPurpose[row]
                    exitViewCell.txtPurposeOfoutpass.text = element
                    self.purposeStr = element
                }
                else { return }
            }
            else {
                
            }
            self.tableView.reloadData()
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        self.present(editRadiusAlert, animated: true)
    }

}
extension VisitorEnteredLogDetailVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let inputType = currentPickerType else { return 0 }
        if inputType == .option {
            return self.arrOption.count
        } else if inputType == .purpose  {
            return self.arrPurpose.count
        }
        else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let inputType = currentPickerType else { return "" }
        if inputType == .option   {
            let element = self.arrOption[row]
            return element
        } else if inputType == .purpose {
            let element = self.arrPurpose[row]
            return element
        } else {
            return ""
        }
    }
    
    @objc private func tapOnImage(_ sender: UIButton) {
        //1 - Visitors
        //2 - Outpass
        //3 - Outward Chalan
        var imageURL = ""
        if sender.tag == 1, let url = visitor_Image {
            imageURL = url
        } else if sender.tag == 2, let url = vehicleDetail?.exit.outpass as? String, !url.isEmpty {
            imageURL = "\(BaseURL_Img)\(url)"
        } else if sender.tag == 3, let url = vehicleDetail?.exit.challan as? String, !url.isEmpty {
            imageURL = "\(BaseURL_Img)\(url)"
        }
        if !imageURL.isEmpty, let vc = UIStoryboard(name: "Vehicle", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController {
            vc.imageURL = imageURL
            Functions.pushToViewController(self, toVC: vc)
        } else {
            self.view.makeToast("No image found!", duration: 1.0, position: .center)
        }
    }
}
extension VisitorEnteredLogDetailVC : UITableViewDelegate, UITableViewDataSource{
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return hiddenSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hiddenSections[section] {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VisitorsLogCompanyDetailTableCell", for: indexPath) as? VisitorsLogCompanyDetailTableCell
            
            cell?.lblCompanyName.text = self.vehicleDetail?.companyName ?? ""
            return cell!
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VisitorsLogDocumentTableCell", for: indexPath) as? VisitorsLogDocumentTableCell
            cell?.currentViewController = self
            if cell?.imgVisitorsBtn != nil {
                cell?.imgVisitorsBtn.tag = 1
                cell?.imgVisitorsBtn.addTarget(self, action: #selector(tapOnImage(_:)), for: .touchUpInside)
            }
            if cell?.imgOutPassBtn != nil {
                cell?.imgOutPassBtn.tag = 2
                cell?.imgOutPassBtn.addTarget(self, action: #selector(tapOnImage(_:)), for: .touchUpInside)
            }
            if cell?.imgOutWardChallanBtn != nil {
                cell?.imgOutWardChallanBtn.tag = 3
                cell?.imgOutWardChallanBtn.addTarget(self, action: #selector(tapOnImage(_:)), for: .touchUpInside)
            }
            
            if let vehicleNo = vehicleDetail?.vehicleNumber as? String {
                cell?.viewMainVehicleNo.isHidden  = false
                cell?.txtFieldVehicleNumber.text = vehicleNo
            } else {
                cell?.viewMainVehicleNo.isHidden  = true
            }
            
            if let url = visitor_Image {
                cell?.imgVisitors.layer.cornerRadius = 2
                cell?.viewVisitors.isHidden = false
                cell?.imgVisitors.sd_setImage(with: URL(string:url), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached, completed: nil)
            } else {
                cell?.viewVisitors.isHidden = true
            }
            
//            if let url = vehicleDetail?.exit.challan as? String {
//                cell?.imgOutWardChallan.layer.cornerRadius = 2
//                cell?.viewOutwardChallan.isHidden = false
//
//                cell?.imgOutWardChallan.sd_setImage(with: URL(string:"\(BaseURL_Img)\(url)"), placeholderImage: UIImage(named: "nopreview"),
//                                                                        options: .refreshCached,
//                                                                        completed: nil)
//            } else {
//                cell?.viewOutwardChallan.isHidden = true
//            }
            
//            if let visitorRemark = vehicleDetail?.visitorRemark as? String {
//                cell?.viewMainRemark.isHidden  = false
//                cell?.txtFieldRemark.text = visitorRemark
//            } else {
//                cell?.viewMainRemark.isHidden  = true
//            }
            if let visitorRemark = vehicleDetail?.visitorRemark as? String, !visitorRemark.isEmpty {
//                cell?.viewMainRemark.isHidden  = false
                cell?.txtFieldRemark.text = visitorRemark
                cell?.txtFieldRemark.textColor = .black
            } else {
                cell?.txtFieldRemark.text = "Visitor Remark"
                cell?.txtFieldRemark.textColor = .lightGray
//                cell?.viewMainRemark.isHidden  = true
            }
            
//            var exitMatStatus = ""
            if let exitMaterialStatus = self.vehicleDetail?.exit?.materialStatus {
//                exitMatStatus = exitMaterialStatus
                cell?.viewMainMaterialStatus.isHidden = true
                if exitMaterialStatus == "1" {
                    cell?.txtFieldMaterialStatus.text = "Exit With Material"
                } else if exitMaterialStatus == "0" {
                    cell?.txtFieldMaterialStatus.text = "Exit Without Material"
                }
                if let matRejRemark = self.vehicleDetail?.exit.materialRejectRemark, !matRejRemark.isEmpty {
                    cell?.viewMainMaterialStatus.isHidden = false
                }
//                if let materStatus = self.vehicleDetail?.exit.materialStatus, materStatus == "0", let matRejRemark = self.vehicleDetail?.exit.materialRejectRemark, matRejRemark.isEmpty {
//                    cell?.viewMainMaterialStatus.isHidden = false
//                }
                if let materStatus = self.vehicleDetail?.exit.materialStatus, materStatus == "0", let matImageStatus = self.vehicleDetail?.exit.materialImgStatus, matImageStatus == "0", let exitApp = self.vehicleDetail?.exit.exitApprovedBy, !exitApp.isEmpty {
                    cell?.viewMainMaterialStatus.isHidden = false
                }
                if let askAppExit = self.vehicleDetail?.exit.askApproval, askAppExit == "0", let exitStatus = self.vehicleDetail?.exit.exitStatus, exitStatus == "1" {
                    cell?.viewMainMaterialStatus.isHidden = false
                }
               
            } else {
                cell?.viewMainMaterialStatus.isHidden = true
            }
            
            
            
//            var exitMatRemark = ""
            if let exitMaterialRemark = self.vehicleDetail?.exit?.materialRejectRemark, !exitMaterialRemark.isEmpty {
//                exitMatRemark = exitMaterialRemark
                cell?.viewMaterialRemark.isHidden = false
                cell?.txtFieldMaterialRemark.text = exitMaterialRemark
//                cell?.viewMainMaterialStatus.isHidden = false
            } else {
                cell?.viewMaterialRemark.isHidden = true
//                cell?.viewMainMaterialStatus.isHidden = true
            }
            
            
            
          /*  if exitMatStatus == "0", exitMatRemark == "" {
                cell?.viewMainMaterialStatus.isHidden = false
            } else {
                cell?.viewMainMaterialStatus.isHidden = true
            }
            
            if exitMatStatus == "0", let materialImgStatus = self.vehicleDetail?.exit?.materialImgStatus, materialImgStatus == "0", let exitApprovedBy = self.vehicleDetail?.exit.exitApprovedBy, !exitApprovedBy.isEmpty {
                cell?.viewMainMaterialStatus.isHidden = false
            } else {
                cell?.viewMainMaterialStatus.isHidden = true
            }
            */
            if let purposeOfOutPass = self.vehicleDetail?.exit.purposeOfOutPass {
                cell?.viewMainPurposeofOutpass.isHidden = false
                if purposeOfOutPass == "1" {
                    cell?.txtfieldPurposeOutPass.text = "Rejected"
                } else if purposeOfOutPass == "2" {
                    cell?.txtfieldPurposeOutPass.text = "Replaced"
                } else if purposeOfOutPass == "3" {
                    cell?.txtfieldPurposeOutPass.text = "Repairing"
                } else if purposeOfOutPass == "4" {
                    cell?.txtfieldPurposeOutPass.text = "Ignore With Remark"
                } else if purposeOfOutPass == "5" {
                    cell?.txtfieldPurposeOutPass.text = "Returnable"
                } else {
                    cell?.viewMainPurposeofOutpass.isHidden = true
                }
            } else {
                cell?.viewMainPurposeofOutpass.isHidden = true
            }
            
            if self.imageArrVehicleMeterial.count > 0 {
                cell?.vwMaterial.isHidden = false
                cell?.imageArrVehicleMeterial = self.imageArrVehicleMeterial
            } else {
                cell?.vwMaterial.isHidden = true
            }

            if let url = vehicleDetail?.exit.outpass as? String, !url.isEmpty {
                cell?.imgOutPass.layer.cornerRadius = 2
                cell?.viewMainOutPass.isHidden = false
                cell?.imgOutPass.sd_setImage(with: URL(string:"\(BaseURL_Img)\(url)"), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached, completed: nil)
            } else {
                cell?.viewMainOutPass.isHidden = true
            }
            return cell!
        }
        
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VisitorsLogVehicleDetailTableCell", for: indexPath) as? VisitorsLogVehicleDetailTableCell
            
            if let visitorName = vehicleDetail?.visitors[0].visitorName as? String {
                cell?.viewVisitorName.isHidden  = false
                cell?.lblVehicleName.text = visitorName
            } else {
                cell?.viewVisitorName.isHidden  = true
            }
            
            if let visitorMobileNo = vehicleDetail?.visitors[0].mobile as? String {
                cell?.viewVisitorMobileNo.isHidden  = false
                cell?.lblVisitorMobileNo.text = visitorMobileNo
            } else {
                cell?.viewVisitorMobileNo.isHidden  = true
            }
        
            if let visitorType = vehicleDetail?.visitors[0].visitorType as? String {
                cell?.viewVisitorType.isHidden  = false
                
                if visitorType == "1" {
                    cell?.lblVisitorType.text = "Others"
                } else if visitorType == "2" {
                    cell?.lblVisitorType.text = "Agents/Brokers"
                } else if visitorType == "3" {
                    cell?.lblVisitorType.text = "Sales Representative"
                } else if visitorType == "4" {
                    cell?.lblVisitorType.text = "Official"
                } else if visitorType == "5" {
                    cell?.lblVisitorType.text = "Govt Officials"
                } else if visitorType == "6" {
                    cell?.lblVisitorType.text = "Registered Vendors"
                } else if visitorType == "7" {
                    cell?.lblVisitorType.text = "Personal Visit"
                } else if visitorType == "8" {
                    cell?.lblVisitorType.text = "Delivery"
                }
            } else {
                cell?.viewVisitorType.isHidden  = true
            }
            
            if let whomToMeet = vehicleDetail?.whomToMeet as? String {
                cell?.viewWhomToMeet.isHidden  = false
                cell?.lblWhomToMeet.text = whomToMeet
            } else {
                cell?.viewWhomToMeet.isHidden  = true
            }
            
            if let NoOfVisitor = vehicleDetail?.visitorNo as? String {
                cell?.viewNoOfVisitor.isHidden  = false
                cell?.lblNoOfVisitor.text = NoOfVisitor
            } else {
                cell?.viewNoOfVisitor.isHidden  = true
            }
                    
            return cell!
        }
        
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VisitorsLogEnteredTableCell", for: indexPath) as? VisitorsLogEnteredTableCell
            
            let askApproval = self.vehicleDetail?.askApproval ?? ""
            let entryStatus = self.vehicleDetail?.status ?? ""
            let entry = self.vehicleDetail?.entry ?? ""
            cell?.lblEntryStatus.text = ""
            let askExitApproval = self.vehicleDetail?.exit.askApproval ?? ""
            let exitStatus = self.vehicleDetail?.exit.exitStatus ?? ""


            if askApproval == "1" {
                cell?.lblEntryStatus.text = "Asked Approval"
            } else if entryStatus == "0" && askApproval == "0" && entry == "1" {
                cell?.lblEntryStatus.text = "Direct Entry"
            } else if entryStatus == "2" {
                cell?.lblEntryStatus.text = "Reject Approval"
            }
            
            cell?.lblEntrySentName.text = "-"
            cell?.lblEntrySentTime.text = "-"
            cell?.lblEntrySentDate.text = "-"
            if self.vehicleDetail?.addedBy != "" {
                cell?.lblEntrySentName.text = "\(self.vehicleDetail?.addedBy ?? "") (Gate)"
                let dateTimeArr = (self.vehicleDetail?.createdDate ?? "").components(separatedBy: " ")
                if dateTimeArr.count > 1 {
                    cell?.lblEntrySentDate.text = dateTimeArr[0]
                    cell?.lblEntrySentTime.text = dateTimeArr[1]
                } else {
                    cell?.lblEntrySentTime.text = self.vehicleDetail?.createdDate ?? ""
                }
            }
            
//            if isMaterialStatusFrom == true {
//                cell?.viewEntryApprovalByName.isHidden = true
//            } else {
//                cell?.viewEntryApprovalByName.isHidden = false
//            }
            
            cell?.viewEntryApprovalByName.isHidden = true
            cell?.lblEntryApprovalName.text = "-"
            cell?.lblEntryApprovalTime.text = "-"
            cell?.lblEntryApprovalDate.text = "-"
            if self.vehicleDetail?.approvedBy != "" && self.vehicleDetail?.approvedBy != "0" {
               cell?.viewEntryApprovalByName.isHidden = false
                cell?.lblEntryApprovalName.text = self.dataObj.value(forKey: "approval_given_by") as? String ?? ""
                let dateTimeArr = (self.vehicleDetail?.approvalDate ?? "").components(separatedBy: " ")
                if dateTimeArr.count > 1 {
                    cell?.lblEntryApprovalDate.text = dateTimeArr[0]
                    cell?.lblEntryApprovalTime.text = dateTimeArr[1]
                } else {
                    cell?.lblEntryApprovalTime.text = self.vehicleDetail?.approvalDate ?? ""
                }
            }

            
            cell?.viewEntryGrantByName.isHidden = true
            if self.vehicleDetail?.status != "2" && self.vehicleDetail?.entry != "0" && self.vehicleDetail?.entryBySecurity ?? "" != "" {
                cell?.viewEntryGrantByName.isHidden = false
                cell?.lblEntryGrantedName.text = "\(self.vehicleDetail?.entryBySecurity ?? "") (Gate)"
                let dateTimeArr = (self.vehicleDetail?.updatedDate ?? "").components(separatedBy: " ")
                if dateTimeArr.count > 1 {
                    cell?.lblEntryGrantedDate.text = dateTimeArr[0]
                    cell?.lblEntryGrantedTime.text = dateTimeArr[1]
                } else {
                    cell?.lblEntryGrantedTime.text = vehicleDetail?.updatedDate ?? ""
                }
            }
            
            cell?.viewExitDetails.isHidden = false
            if askExitApproval == "1"  && exitStatus == "0" {
                cell?.lblApprovalForExit.text = "Approval For Exit"
            } else if askExitApproval == "0" && exitStatus == "1" {
                cell?.viewExitDetails.isHidden = false
                cell?.lblApprovalForExit.text = "Direct Exit"
            } else if exitStatus == "1" && vehicleDetail?.entry == "1" {
                cell?.viewExitDetails.isHidden = false
                cell?.lblApprovalForExit.text = "Approval For Exit"
            } else {
                cell?.lblApprovalForExit.text = ""
                cell?.viewExitDetails.isHidden = true
            }
            
//            if isMaterialStatusFrom == true {
//                cell?.viewExitDetails.isHidden = true
//
//            } else {
//                cell?.viewExitDetails.isHidden = false
//            }
             
            cell?.viewExitApprovedByname.isHidden = true
            if self.vehicleDetail?.exit.exitApprovedBy != "" &&  self.vehicleDetail?.exit.exitApprovedBy != nil {
                cell?.viewExitApprovedByname.isHidden = false
                cell?.lblExitAprrovalName.text = vehicleDetail?.exit.exitApprovedBy ?? ""
                let dateTimeArr = (self.vehicleDetail?.exit.approvedDate ?? "").components(separatedBy: " ")
                if dateTimeArr.count > 1 {
                    cell?.lblExitApprovalDate.text = dateTimeArr[0]
                    cell?.lblExitApprovalTime.text = dateTimeArr[1]
                } else {
                    cell?.lblExitApprovalTime.text = vehicleDetail?.exit.approvedDate ?? ""
                }
            }
           
            cell?.viewExitGrantByName.isHidden = true
            if self.vehicleDetail?.exit.exitBySecurity != "" &&  self.vehicleDetail?.exit.exitBySecurity != nil {
                cell?.viewExitGrantByName.isHidden = false
                cell?.lblExitGrantName.text = "\(self.vehicleDetail?.exit.exitBySecurity ?? "") (Gate)"
                let dateTimeArr = (self.vehicleDetail?.exit.updatedDate ?? "").components(separatedBy: " ")
                if dateTimeArr.count > 1 {
                    cell?.lblExitGrantDate.text = dateTimeArr[0]
                    cell?.lblExitGrantTime.text = dateTimeArr[1]
                } else {
                    cell?.lblExitGrantTime.text = self.vehicleDetail?.exit.updatedDate ?? ""
                }
            }
            return cell!

        }
        
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExitVehicleCell", for: indexPath) as? ExitVehicleCell
           
            cell?.btnOutPassImage.addTarget(self, action: #selector(btnOutPassImageClick(_:)), for: .touchUpInside)
            cell?.btnUploadMeterial.addTarget(self, action: #selector(btnMeterialImageClicked(_:)), for: .touchUpInside)
            cell?.collectionMeterialImage.delegate = self
            cell?.collectionMeterialImage.dataSource = self
            cell?.collectionUploadOutPassImage.delegate = self
            cell?.collectionUploadOutPassImage.dataSource = self
            cell?.txtExitOption.delegate = self
            cell?.txtPurposeOfoutpass.delegate = self
            cell?.txtIgnoreWithRemark.delegate = self
            cell?.txtPurposeOfoutpass.text = self.purposeStr
            cell?.txtIgnoreWithRemark.text = self.ignoreWithRemark
            cell?.txtExitOption.text = self.selectedExitOption
            if cell?.txtExitOption.text == "" || cell?.txtExitOption.text == "Exit Without Material" {
//                DispatchQueue.main.async {
//                    self.view.layoutIfNeeded()
                    cell?.vwPurposeOutpass.isHidden = true
                   // cell?.heightPurposeOfOutPassConstraint.constant = 0
//                    self.view.layoutIfNeeded()
//                }
//
                }
             else {
//                 DispatchQueue.main.async {
//                     self.view.layoutIfNeeded()
                // cell?.heightPurposeOfOutPassConstraint.constant = 320
                 cell?.vwPurposeOutpass.isHidden = false
//                 self.view.layoutIfNeeded()
//                 }
            }
            cell?.btnExitApproval.tag = indexPath.row
            
            cell?.btnExitApproval.addTarget(self, action: #selector(btnExitApprovalClicked(_:)), for: .touchUpInside)
            return cell!

        }

    else{
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0  {
            return 107
        }
//        if indexPath.section == 1 {
//            return UITableView.automaticDimension
//        }
        else if indexPath.section == 2 {
            return 452
        }
//        else if indexPath.section == 3 {
//            return UITableView.automaticDimension
//        }
        else if indexPath.section == 4 {
            var height = 200.0
            
            if selectedExitOption == "Exit With Material" {
                height = 550.0
            } else {
                height = 180.0
            }
            if selectImageFrom != ""{
                height = 800
            }
            return height
        }
        return UITableView.automaticDimension
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
            label.text = "VEHICLE NO. & DOCS."
        }  else if section == 2 {
            label.text = "VISITOR DETAILS"
        } else if section == 3 {
            label.text = "ACTIVITY DETAILS"
        } else if section == 4 {
            label.text = "EXIT VISITOR"
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

extension VisitorEnteredLogDetailVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Image Selection ------------------------------------
    @objc func btnOutPassImageClick(_ sender: UIButton) {
        self.selectImageFrom = "1" // Means Outpass Image Selection
        self.openCameraSwitch()
    }
    
    @objc func btnMeterialImageClicked(_ sender: UIButton) {
        self.selectImageFrom = "2" // Means Meterial Image Selection
        self.openCameraSwitch()
    }
    @objc func btnExitApprovalClicked(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        let cell = tableView.cellForRow(at: indexPath) as! ExitVehicleCell
        
        if cell.txtExitOption.text != "" {
            
            let exitWithMaterial = self.selectedExitOption
            
            if exitWithMaterial == "Exit With Material" {
                if self.purposeStr.isEmpty {
                    self.view.makeToast("Please select purpose of outpss option", duration: 1.0, position: .bottom)
                    return
                }
                if self.ignoreWithRemark.isEmpty {
                    self.view.makeToast("Please enter ignore with remark", duration: 1.0, position: .bottom)
                    return
                }
                if outpassImageArrStr.count <= 0 {
                    self.view.makeToast("Please capture outpass image", duration: 1.0, position: .bottom)
                    return
                }
                if materialImageArrStr.count <= 0 {
                    self.view.makeToast("Please capture material image", duration: 1.0, position: .bottom)
                    return
                }
                
                let purposeOfoutpass = self.purposeStr
                var purpose = ""
                if purposeOfoutpass == "Returnable" {
                    purpose = "5"
                }
                else if purposeOfoutpass == "Rejected"{
                    purpose = "1"
                }
                else if purposeOfoutpass == "Replaced"{
                    purpose = "2"
                }
                else if purposeOfoutpass == "Repairing"{
                    purpose = "3"
                }
                else if purposeOfoutpass == "Ignore With Remark"{
                    purpose = "4"
                } else {
                    purpose = "0"
                }
                
                let params = ["user_id": appDelegate.userLoginAccessDetails?.id ?? "",
                              "entry_id": objApproval?.uniqueId ?? "",
                              "exit_status":"0",
                              "material_status":"1",
                              "ask_approval":"1",
                              "outpass":outpassImageArrStr.joined(separator: ","),
                              "material_img":materialImageArrStr.joined(separator: ","),
                              "purpose_of_out_pass":purpose,
                              "challan":"",
                              "material_reject_remark":self.ignoreWithRemark,
                              "site_id": site_id
                ] as [String: Any]
                
                ExitApprovalAPI(params: params)
                
            } else {
                let params = ["user_id": appDelegate.userLoginAccessDetails?.id ?? "",
                              "entry_id": objApproval?.uniqueId ?? "",
                              "exit_status":"0",
                              "material_status":"0",
                              "ask_approval":"1",
                              "outpass":outpassImageArrStr.joined(separator: ","),
                              "rejected_material_img":materialImageArrStr.joined(separator: ","),
                              "purpose_of_out_pass":"",
                              "challan":"",
                              "material_reject_remark":"",
                              "site_id": site_id
                ] as [String: Any]
                
                ExitApprovalAPI(params: params)
            }
        } else {
            self.view.makeToast("please select exit option", duration: 1.0, position: .bottom)
            return
        }
    }

    func ExitApprovalAPI(params:[String:Any]) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            Webservice.Authentication.exitVisitorApprovalApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["code"] as? Int == 200 {
                           
                            let alertcontroller = UIAlertController(title: nil, message: "Visitor Exit Successfully.", preferredStyle: .alert)
                            let yes = UIAlertAction(title: "OK", style: .default) { _ in
                    
                                self.navigationController?.popViewController(animated: true)
                            }
                            alertcontroller.addAction(yes)
                            self.present(alertcontroller, animated: true)
                           
                        }
                    }
                case let .fail(errorMsg):
                    print(errorMsg)
                    self.view.makeToast(errorMsg, duration: 1.0, position: .center)
                }
            }
        }
    }
    
    func openCameraSwitch() {
        //Reload for height of collectionview
         if self.arrOutpassImage.count == 0 && self.arrMeterialImage.count == 0{
           self.tableView.reloadSections(IndexSet(integer: 4), with: .none)
         }

        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .camera
        myPickerController.allowsEditing = false
        present(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        guard  let exitTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? ExitVehicleCell else { return }
        
        picker.dismiss(animated: true) {
            guard let selectedImage = info[.originalImage] as? UIImage else {
                print("Image not found!")
                return
            }
            guard let resizedImage = selectedImage.resized(withPercentage: 0.2) else { return }
            guard let imageData = resizedImage.jpegData(compressionQuality: 0.75) else { return }
//            guard let imageData = selectedImage.jpegData(compressionQuality: 0.4) else { return }

            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)

            if self.selectImageFrom == "1" { // Means Outpass
                if picker.sourceType == UIImagePickerController.SourceType.camera {
                    self.arrOutpassImage.removeAll()
                    self.outpassImageArrStr.removeAll()
                    let dic = ["image": selectedImage, "isDeleted": false] as [String : Any]
                    let model = ImageModel(fromDictionary: dic)
                    self.arrOutpassImage.append(model)
                    exitTableViewCell.collectionUploadOutPassImage.isHidden = false
                    exitTableViewCell.collectionUploadOutPassImage.reloadData()
                    self.uploadImage(outpass_image: strBase64, meterial_image: "")
                }
            }
            
            if self.selectImageFrom == "2" { // Means Inward
                if picker.sourceType == UIImagePickerController.SourceType.camera {
                    let dic = ["image": selectedImage, "isDeleted": false] as [String : Any]
                    let model = ImageModel(fromDictionary: dic)
                    self.arrMeterialImage.append(model)
                    exitTableViewCell.collectionMeterialImage.isHidden = false
                    exitTableViewCell.collectionMeterialImage.reloadData()
                    self.uploadImage(outpass_image: "", meterial_image: strBase64)
                }
            }
        }
    }
    
    // MARK: - Upload image Api Functionality -------------------------------------------
    
    func uploadImage(outpass_image: String, meterial_image: String) {
        if !outpass_image.isEmpty {
            self.outpassImageArrStr.append(outpass_image)
        } else if !meterial_image.isEmpty {
            self.materialImageArrStr.append(meterial_image)
        }
        /*if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id":appDelegate.userLoginAccessDetails?.id ?? "","outpass": outpass_image, "material": meterial_image, "site_id": site_id] as [String: Any]
            //            print(params)
            Webservice.Authentication.UploadImage(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["code"] as? Int ?? 0 == 200 {
                            if (body["outpass"] as? String) != "" {
                                let imgName = body["outpass"] as? String ?? ""
                                self.outpassImageArrStr.removeAll()
                                self.outpassImageArrStr.append(imgName)
                            }
                            if (body["material"] as? String) != "" {
                                let imgName = body["material"] as? String ?? ""
                                self.materialImageArrStr.append(imgName)
                            }
                            
                        } else {
                            App_AlertView.shared.SimpleMessage(Text: body["message"] as? String ?? "")
                        }
                    }
                case let .fail(errorMsg):
                    self.view.makeToast(errorMsg, duration: 1.0, position: .center)
                }
            }
        }*/
    }
}
//MARK:-
extension VisitorEnteredLogDetailVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         let exitTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? ExitVehicleCell

        if collectionView == exitTableViewCell?.collectionUploadOutPassImage {
            return arrOutpassImage.count
        }
        if collectionView == exitTableViewCell?.collectionMeterialImage {
            return arrMeterialImage.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let exitTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? ExitVehicleCell

        if collectionView == exitTableViewCell?.collectionUploadOutPassImage {
            let obj = self.arrOutpassImage[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "outpassImageCell", for: indexPath) as? outpassImageCell
            
            DispatchQueue.main.async {
                cell?.imgView?.contentMode = .scaleAspectFill
            }
            cell?.imgView?.image = obj.image
            
            return cell!
        }
        
        if collectionView == exitTableViewCell?.collectionMeterialImage {
            let obj = self.arrMeterialImage[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "materialImageCell", for: indexPath) as? materialImageCell
            
            DispatchQueue.main.async {
                cell?.imgView?.contentMode = .scaleAspectFill
            }
            cell?.imgView?.image = obj.image
            cell?.deleteImg?.tag = indexPath.row
            cell?.deleteImg?.addTarget(self, action: #selector(btnDeleteVehicleImgAction(sender:)), for: .touchUpInside)

            return cell!
        }

        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let width = (collectionView.frame.size.width - 20) / 2.1
            return CGSize(width: width, height: 128)
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

    @objc func btnDeleteVehicleImgAction(sender: UIButton) {
        guard  let exitTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? ExitVehicleCell else { return }
        self.arrMeterialImage.remove(at: sender.tag)
        self.materialImageArrStr.remove(at: sender.tag)
        if self.arrMeterialImage.count > 0 {
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
                exitTableViewCell.collectionMeterialImage.reloadData()
                self.view.layoutIfNeeded()
            }
        } else {
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
                exitTableViewCell.collectionMeterialImage.isHidden = true
                exitTableViewCell.collectionMeterialImage.reloadData()
                self.view.layoutIfNeeded()
            }
        }
    }
}
extension VisitorEnteredLogDetailVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard  let exitTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? ExitVehicleCell else { return }

        if textField.isEqual(exitTableViewCell.txtExitOption){
            self.currentPickerType = .option
            self.showPicker(type: .option)
        }
        if textField.isEqual(exitTableViewCell.txtPurposeOfoutpass){
            self.currentPickerType = .purpose
            self.showPicker(type: .purpose)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard  let exitTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? ExitVehicleCell else { return }
        if textField.isEqual(exitTableViewCell.txtIgnoreWithRemark){
            self.ignoreWithRemark = textField.text ?? ""
        }
    }
}

