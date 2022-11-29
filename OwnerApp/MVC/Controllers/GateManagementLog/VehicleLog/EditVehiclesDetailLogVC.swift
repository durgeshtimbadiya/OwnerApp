
import UIKit
import AVFoundation

class EditVehiclesDetailLogVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblSiteName: UILabel!

    var hiddenSections = [Bool]()
    var vehicleDetail : VehicleData?
    var imageArrVehicleMeterial = [ExitAttechment]()
    var poImages = [String]()
    var vehicleMateriImages = [String]()
    var imageArrInwardChallan = [Document]()
    var imageArrOutwardImage = [ExitEntry]()
    var objApproval: ApproveModel? = nil
    var site_Name = ""
    var site_id = ""//need to pass

    var selectImageFrom = ""
    
    var arrCommercialVehicleImg = [ImageModel]()
    var arrPOImage = [ImageModel]()
    var arrMaterialImage = [ImageModel]()

    var arrCommercialVehicleBase64 = [String]()
    var arrPOImageBase64 = [String]()
    var arrMaterialImageBase64 = [String]()
    var invoiceImageBase64 = ""

    var selectedExitOption = ""
    var purposeStr = ""
    var ignoreWithRemark = ""
    
    private var quantityWithUnitTxt = ""
    private var chalanNumberTxt = ""
    private var poNumberTxt = ""

    private var challan_msg = ""
    private var po_no_msg = ""
    private var material_img_msg = ""
    private var commercial_vehicle_img_msg = ""
    private var quantity_msg = ""
    private var po_msg = ""
    private var invoice_msg = ""
    private var invoice_img_msg = ""
    private var commercial_msg = ""
    
    
    private var isCommVehiImageEnbl = false
    private var isPOImageEnbl = false
    private var isInvoiceImageEnbl = false
    private var isMaterialImageEnbl = false
    
    var invoiceImageModel = ImageModel(fromDictionary: ["image": nil, "isDeleted": false ?? false] as [String : Any])

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
        ["1"],
        ["1"],
        ["1"]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.GetVehicleEntryApi(UserId: appDelegate.userLoginAccessDetails?.id ?? "", entryId: objApproval?.id ?? "")
        self.lblSiteName.text = site_Name
            
        hiddenSections = [false, false, false, false, false, false]
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
                                self.quantityWithUnitTxt = self.vehicleDetail?.quantity ?? ""
                                self.chalanNumberTxt = self.vehicleDetail?.challanNumber ?? ""
                                self.poNumberTxt = self.vehicleDetail?.poNumber ?? ""
                                
                                var fieldUpdates = [FieldData]()
                                if let fieldUpdt = entryDetail["field_update"] as? [[String:Any]] {
                                    fieldUpdt.forEach { object in
                                        fieldUpdates.append(FieldData(fromDictionary: object))
                                    }
                                }
                                
                                fieldUpdates.forEach({ fieldData in
                                    if fieldData.field == "challan_number" {
                                        self.challan_msg = fieldData.msg
                                    } /*else if fieldData.field == "commercial_vehicle" {
                                        self.commercial_msg = fieldData.msg
                                    }*/ else if fieldData.field == "po_number" {
                                        self.po_no_msg = fieldData.msg
                                    } else if fieldData.field == "quantity" {
                                        self.quantity_msg = fieldData.msg
                                    } else if fieldData.field == "po_img" {
                                        self.po_msg = fieldData.msg
                                    } else if fieldData.field == "Invoice_img" {
                                        self.invoice_msg = fieldData.msg
                                    } else if fieldData.field == "invoice_img_status" {
                                        self.invoice_img_msg = fieldData.msg
                                    } else if fieldData.field == "commercial_vehicle_image" {
                                        self.commercial_vehicle_img_msg = fieldData.msg
                                    } else if fieldData.field == "material_img" {
                                        self.material_img_msg = fieldData.msg
                                    }
                                })
                                
                                let arrExitAttachment: [ExitAttechment] = (self.vehicleDetail?.exitAttechment)!
                                for obj in arrExitAttachment {
                                    self.imageArrVehicleMeterial.append(obj)
                                }
                                
                                let arrOutWard: [ExitEntry] = (self.vehicleDetail?.exit)!
                                
                                for obj in arrOutWard {
                                    if obj.challan != nil && obj.challan != "" {
                                        self.imageArrOutwardImage.append(obj)
                                    }
                                }
                                
                                let arrDocument: [Document] = (self.vehicleDetail?.document)!
                                    for obj in arrDocument {
                                        if obj.type == "0" {
                                            if let urlStr = obj.url, !urlStr.isEmpty {
                                                self.vehicleMateriImages.append(urlStr)
                                            }
                                        }
                                        if obj.type == "1" {
                                            self.imageArrInwardChallan.append(obj)
                                        }
//                                        if obj.type == "2" {
//                                            self.imageArrOutwardImage.append(obj)
//                                        }
                                        if obj.type == "3" {
                                            if let urlStr = obj.url, !urlStr.isEmpty {
                                                self.poImages.append(urlStr)
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
extension EditVehiclesDetailLogVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        //Outpass
        if let url = self.vehicleDetail?.exit[0].outpass, !url.isEmpty, let vc = UIStoryboard(name: "Vehicle", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController {
            vc.imageURL = url
            Functions.pushToViewController(self, toVC: vc)
        } else {
            self.view.makeToast("No image found!", duration: 1.0, position: .center)
        }
    }
}
extension EditVehiclesDetailLogVC : UITableViewDelegate, UITableViewDataSource{
  
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleLogCompanyDetailTableCell", for: indexPath) as? VehicleLogCompanyDetailTableCell
            
            let company_name = self.vehicleDetail?.companyName ?? ""
            let company_mobile = self.vehicleDetail?.companyMobile ?? ""
            
            cell?.lblCompanyName.text = self.vehicleDetail?.companyName ?? ""
            cell?.lblRegisterMobileNumber.text = self.vehicleDetail?.companyMobile ?? ""
            cell?.lblMeterialType.text = self.vehicleDetail?.materialType ?? ""
            return cell!
        }
        else if indexPath.section == 1{
            
//            let driver_contact = self.vehicleDetail?.driverContact ?? ""
//            let vehicle_number = self.vehicleDetail?.vehicleNumber ?? ""
            let quantity = self.vehicleDetail?.quantity ?? ""
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleLogVehicleDetailTableCell", for: indexPath) as? VehicleLogVehicleDetailTableCell
            cell?.currentViewController = self

            cell?.lblVehicleNumber.text = self.vehicleDetail?.vehicleNumber ?? ""
            cell?.lblDriverNumber.text = self.vehicleDetail?.driverContact ?? ""
            cell?.lblQtyWithUnit.text = self.vehicleDetail?.quantity ?? ""
            cell?.lblQtyWithUnit.tag = 11
            cell?.lblQtyWithUnit.isUserInteractionEnabled = quantity.isEmpty
            
            cell?.lblCommercialMsg.isHidden = true
            if !commercial_msg.isEmpty && commercial_msg != "0" {
                cell?.lblCommercialMsg.isHidden = false
                cell?.lblCommercialMsg.text = commercial_msg
            }
            
            cell?.lblQuantityMsg.isHidden = true
            if !quantity_msg.isEmpty && quantity_msg != "0" {
                cell?.lblQuantityMsg.isHidden = false
                cell?.lblQuantityMsg.text = quantity_msg
            }
            
            cell?.materialImagesView.isHidden = true
            if self.vehicleMateriImages.count > 0 {
                cell?.imageArrMaterials = vehicleMateriImages
                cell?.materialImagesView.isHidden = false
            }
            
            cell?.lblMaterialImgMsg.isHidden = true
            if !commercial_vehicle_img_msg.isEmpty && commercial_vehicle_img_msg != "0" {
                cell?.lblMaterialImgMsg.isHidden = false
                cell?.lblMaterialImgMsg.text = commercial_vehicle_img_msg
            }
            
            return cell!
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleLogDocumentTableCell", for: indexPath) as? VehicleLogDocumentTableCell
            
            let challan_number = self.vehicleDetail?.challanNumber ?? ""
            let po_number = self.vehicleDetail?.poNumber ?? ""

            cell?.lblChallanNumber.isUserInteractionEnabled = challan_number.isEmpty
            cell?.lblChallanNumber.tag = 22

            cell?.lblPONumber.isUserInteractionEnabled = po_number.isEmpty
            cell?.lblPONumber.tag = 33

            cell?.lblChallanMsg.isHidden = true
            if !challan_msg.isEmpty && challan_msg != "0" {
                cell?.lblChallanMsg.isHidden = false
                cell?.lblChallanMsg.text = challan_msg
            }
            
            cell?.lblPONumberMsg.isHidden = true
            if !po_no_msg.isEmpty && po_no_msg != "0" {
                cell?.lblPONumberMsg.isHidden = false
                cell?.lblPONumberMsg.text = po_no_msg
            }
            
            cell?.lblPOImageMsg.isHidden = true
            if !po_msg.isEmpty && po_msg != "0" {
                cell?.lblPOImageMsg.isHidden = false
                cell?.lblPOImageMsg.text = po_msg
            }
            
            cell?.lblInvoiceImageMsg.isHidden = true
            if !invoice_img_msg.isEmpty && invoice_img_msg != "0" {
                cell?.lblInvoiceImageMsg.isHidden = false
                cell?.lblInvoiceImageMsg.text = invoice_img_msg
            }
            
            cell?.materialimagemsg.isHidden = true
            if !material_img_msg.isEmpty && material_img_msg != "0" {
                cell?.materialimagemsg.isHidden = false
                cell?.materialimagemsg.text = material_img_msg
            }
        
            cell?.currentViewController = self
            if cell?.outPassImageBtn != nil {
                cell?.outPassImageBtn.addTarget(self, action: #selector(tapOnImage(_:)), for: .touchUpInside)
            }
            
            if self.imageArrInwardChallan.count > 0 {
                cell?.vwInwardImage.isHidden = false
                cell?.imageArrInwardChallan = self.imageArrInwardChallan
            }else{
                cell?.vwInwardImage.isHidden = true
            }
            
            if self.imageArrOutwardImage.count > 0 {
                cell?.vwOutwardChallan.isHidden = false
                cell?.imageArrOutWardChallanImage = self.imageArrOutwardImage
            } else {
                cell?.vwOutwardChallan.isHidden = true
            }
            
            if self.imageArrVehicleMeterial.count > 0 {
                cell?.vwMaterialView.isHidden = false
                cell?.imageArrVehicleMeterial = self.imageArrVehicleMeterial
            }else{
                cell?.vwMaterialView.isHidden = true
            }
           
            if let challanNo = self.vehicleDetail?.challanNumber {
                cell?.vwChallanNumber.isHidden = false
                cell?.lblChallanNumber.text = challanNo
            } else {
                cell?.vwChallanNumber.isHidden = true
            }
            
            cell?.invoiceImagesView.isHidden = true
            if let invoiceImage = self.vehicleDetail?.invoiceImg, !invoiceImage.isEmpty {
                cell?.imageArrInvoices = [invoiceImage]
                cell?.invoiceImagesView.isHidden = false
            }
            
            cell?.POImagesView.isHidden = true
            if self.poImages.count > 0 {
                cell?.imageArrPOImages = poImages
                cell?.POImagesView.isHidden = false
            }
            
            if let exitMaterialStatus = self.vehicleDetail?.exit[0].materialStatus {
                cell?.vwExitmaterialDetail.isHidden = false
                
                if exitMaterialStatus == "1" {
                    cell?.txtFieldExitMaterialStatus.text = "Exit with Material"
                } else if exitMaterialStatus == "0" {
                    cell?.txtFieldExitMaterialStatus.text = "Exit Without Material"
                } else {
                    cell?.txtFieldExitMaterialStatus.text = "Exit Without Material"
                }
            } else {
                cell?.vwExitmaterialDetail.isHidden = true
            }
    
            cell?.viewPurposeOfOutPass.isHidden = true
            if let purposeOfOutPass = self.vehicleDetail?.exit[0].purposeOfOutPass {
                cell?.viewPurposeOfOutPass.isHidden = false
                if purposeOfOutPass == "1" {
                    cell?.txtFieldPurposeOfOutPass.text = "Rejected"
                } else if purposeOfOutPass == "2" {
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
            
            if let remarks = self.vehicleDetail?.exit[0].materialRejectRemark {
                cell?.viewRemark.isHidden = false
                cell?.txtFieldRemarks.text = remarks
            } else {
                cell?.viewRemark.isHidden = true
            }
            
            if let url = self.vehicleDetail?.exit[0].outpass, !url.isEmpty {
                cell?.outPassImage.layer.cornerRadius = 2
                cell?.vwOutPassImage.isHidden = false
                cell?.outPassImage.sd_setImage(with: URL(string:url), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached, completed: nil)
            } else {
                cell?.vwOutPassImage.isHidden = true
            }
            
            if let Po = self.vehicleDetail?.poNumber {
                cell?.vwPONumber.isHidden = false
                cell?.lblPONumber.text = Po
            } else {
                cell?.vwPONumber.isHidden = true
            }
            
            var ask_approval_exit = ""
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
            }
            if ask_approval_exit == "0" && exit_status == "0" && exitMaterialStatus == "0" {
                cell?.vwExitmaterialDetail.isHidden = true
            }
            return cell!
        }
        
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleLogEnteredTableCell", for: indexPath) as? VehicleLogEnteredTableCell
            
            let askApproval = self.vehicleDetail?.askApproval ?? ""
            let entryStatus = self.vehicleDetail?.status ?? ""
            let entry = self.vehicleDetail?.entry ?? ""
            cell?.lblEntryStatus.text = ""
//            var askExitApproval = ""
//            var exitStatus = ""
//
//            if let exitObjs = self.vehicleDetail?.exit, exitObjs.count > 0 {
//                askExitApproval = exitObjs[0].askApproval
//                exitStatus = exitObjs[0].exitStatus
//            }

            if askApproval == "1" {
                cell?.lblEntryStatus.text = "Asked Approval"
            } else if entryStatus == "0" && askApproval == "0" && entry == "1" {
                cell?.lblEntryStatus.text = "Direct Entry"
            } else if entryStatus == "2" {
                cell?.lblEntryStatus.text = "Reject Approval"
            }
            
            cell?.lblEntrySentName.text = "-"
            cell?.lblEntrySentDate.text = "-"
            cell?.lblEntrySentTime.text = "-"
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
            
            cell?.entryApprovedView.isHidden = true
            cell?.lblEntryApprovalName.text = "-"
            cell?.lblEntryApprovalDate.text = "-"
            cell?.lblEntryApprovalTime.text = "-"
            if self.vehicleDetail?.approvedBy.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ")", with: "") != "" {
                cell?.entryApprovedView.isHidden = false
                cell?.lblEntryApprovalName.text = self.vehicleDetail?.approvedBy ?? ""
                let dateTimeArr = (self.vehicleDetail?.approvalDate ?? "").components(separatedBy: " ")
                if dateTimeArr.count > 1 {
                    cell?.lblEntryApprovalDate.text = dateTimeArr[0]
                    cell?.lblEntryApprovalTime.text = dateTimeArr[1]
                } else {
                    cell?.lblEntryApprovalTime.text = self.vehicleDetail?.approvalDate ?? ""
                }
            }

            cell?.lblEntryGrantedName.text = "-"
            cell?.lblEntryGrantedDate.text = "-"
            cell?.lblEntryGrantedTime.text = "-"
            if self.vehicleDetail?.entryBySecurity != "" && self.vehicleDetail?.entryBySecurity != nil {
                cell?.lblEntryGrantedName.text = "\(self.vehicleDetail?.entryBySecurity ?? "") (Gate)"
                let dateTimeArr = (self.vehicleDetail?.updatedDate ?? "").components(separatedBy: " ")
                if dateTimeArr.count > 1 {
                    cell?.lblEntryGrantedDate.text = dateTimeArr[0]
                    cell?.lblEntryGrantedTime.text = dateTimeArr[1]
                } else {
                    cell?.lblEntryGrantedTime.text = self.vehicleDetail?.updatedDate ?? ""
                }
            }
          
            cell?.exitDetailView.isHidden = true
            if let exitEntry =  self.vehicleDetail?.exit, let exitDetail = exitEntry.first {
                            
                if exitDetail.askApproval == "1"  && exitDetail.exitStatus == "0" {
                    cell?.lblApprovalForExit.text = "Approval For Exit"
                    cell?.exitDetailView.isHidden = false
                } else if exitDetail.askApproval == "0" && exitDetail.exitStatus == "1" {
                    cell?.lblApprovalForExit.text = "Approval For Exit"
                    cell?.lblApprovalForExit.text = "Direct Exit"
                } else if exitDetail.exitStatus == "1" && vehicleDetail?.entry == "1" {
                    cell?.lblApprovalForExit.text = "Approval For Exit"
                    cell?.exitDetailView.isHidden = false
                } else {
                    cell?.lblApprovalForExit.text = ""
                }
                
                cell?.lblExitAprrovalName.text = "-"
                cell?.lblExitApprovalTime.text = "-"
                cell?.exitApprovedView.isHidden = true
                if exitDetail.approvedBy != "" && exitDetail.approvedBy != "0" {
                    cell?.exitApprovedView.isHidden = false
                    cell?.exitDetailView.isHidden = false
                    cell?.lblExitAprrovalName.text = exitDetail.approvedBy ?? ""
                    let dateTimeArr = (exitDetail.approvedDate ?? "").components(separatedBy: " ")
                    if dateTimeArr.count > 1 {
                        cell?.lblExitApprovalDate.text = dateTimeArr[0]
                        cell?.lblExitApprovalTime.text = dateTimeArr[1]
                    } else {
                        cell?.lblExitApprovalTime.text = exitDetail.approvedDate ?? ""
                    }
                }
               
                cell?.exitGrantedView.isHidden = true
                if exitDetail.exitBySecurity != "" &&  exitDetail.exitBySecurity != nil {
                    cell?.exitGrantedView.isHidden = false
                    cell?.exitDetailView.isHidden = false
                    cell?.lblExitGrantName.text = "\(exitDetail.exitBySecurity ?? "") (Gate)"
                    let dateTimeArr = (exitDetail.updatedDate ?? "").components(separatedBy: " ")
                    if dateTimeArr.count > 1 {
                        cell?.lblExitGrantDate.text = dateTimeArr[0]
                        cell?.lblExitGrantTime.text = dateTimeArr[1]
                    } else {
                        cell?.lblExitGrantTime.text = exitDetail.updatedDate ?? ""
                    }
                }
               
            }
            return cell!
        }
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateVehicleImageCell", for: indexPath) as? UpdateVehicleImageCell

            let invoice_img = self.vehicleDetail?.invoiceImg ?? ""
            let commercial_vehicle_image = self.vehicleDetail?.commercialVehicleImage ?? ""
//            let inward_challan_image = self.vehicleDetail?.inwardChallanImage ?? ""
            let po_img = self.vehicleDetail?.poImg ?? ""
            let invoice_img_status = self.vehicleDetail?.invoiceImgStatus ?? ""
            let material_type = self.vehicleDetail?.materialType ?? ""
            var materialImgStatus = "0"
            if let exits = self.vehicleDetail?.exit, exits.count > 0, let exit = exits.first {
                materialImgStatus = exit.materialImgStatus
            }
            cell?.materialImageView.isHidden = !(materialImgStatus == "1" && imageArrVehicleMeterial.count == 0)
            
            if invoice_img != "0" && commercial_vehicle_image != "0" && po_img != "0" {
                cell?.invoiceView.isHidden = true
                cell?.commercialVehImgView.isHidden = true
                cell?.poImageView.isHidden = true
            }
            cell?.invoiceView.isHidden = invoice_img_status != "0"
            cell?.commercialVehImgView.isHidden = commercial_vehicle_image != "0"
            cell?.poImageView.isHidden = po_img != "0"

            cell?.configure(self.arrCommercialVehicleImg, poimages: self.arrPOImage, materialImages: self.arrMaterialImage, selectors: [#selector(btnDeleteCommVehicleImgAction(sender:)), #selector(btnDeletePOImgAction(sender:)), #selector(btnDeleteMaterialImgAction(sender:))], target: self)
            
            cell?.commerVehiButton.setTitle("COMMERCIAL VEHICLE IMAGE +", for: .normal)
            if self.arrCommercialVehicleImg.count > 0 {
                cell?.commerVehiButton.setTitle("ADD NEW +", for: .normal)
            }
            
            cell?.poImageButton.setTitle("PO IMAGE +", for: .normal)
            if self.arrPOImage.count > 0 {
                cell?.poImageButton.setTitle("ADD NEW +", for: .normal)
            }
            
            cell?.materialImgButton.setTitle("MATERIAL +", for: .normal)
            if self.arrMaterialImage.count > 0 {
                cell?.materialImgButton.setTitle("ADD NEW +", for: .normal)
            }
            
            cell?.invoiceImgButton.setTitle("INVOICE +", for: .normal)
            if self.invoiceImageModel.image != nil {
                cell?.invoiceImageView.isHidden = false
                cell?.invoiceImageView.image = self.invoiceImageModel.image
                cell?.invoiceImgButton.setTitle("INVOICE UPLOADED", for: .normal)
            }

            cell?.commerVehiButton.addTarget(self, action: #selector(btnCommercialVehicle(_:)), for: .touchUpInside)
            cell?.commerVehiButton1.addTarget(self, action: #selector(btnCommercialVehicle(_:)), for: .touchUpInside)
            
            cell?.poImageButton.addTarget(self, action: #selector(btnPOImage(_:)), for: .touchUpInside)
            cell?.poImageButton1.addTarget(self, action: #selector(btnPOImage(_:)), for: .touchUpInside)
            
            cell?.invoiceImgButton.addTarget(self, action: #selector(btnInvoiceImage(_:)), for: .touchUpInside)
            cell?.invoiceImgButton1.addTarget(self, action: #selector(btnInvoiceImage(_:)), for: .touchUpInside)
            
            cell?.materialImgButton.addTarget(self, action: #selector(btnMaterialImage(_:)), for: .touchUpInside)
            cell?.materialImgButton1.addTarget(self, action: #selector(btnMaterialImage(_:)), for: .touchUpInside)
            
            return cell!
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 {
            return 300
        }
//        else if indexPath.section == 3 {
//            return 1000
//        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExitVehicleCell") as? ExitVehicleCell
            
            cell?.btnExitApproval.addTarget(self, action: #selector(btnUpdateVehicleClicked(_:)), for: .touchUpInside)
            return cell!
        }
        
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
        } else if section == 4 {
            label.text = "UPDATE IMAGES"
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
        if hiddenSections.count == sender.tag - 1 {
            return
        }
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

extension EditVehiclesDetailLogVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Image Selection ------------------------------------
    @objc func btnCommercialVehicle(_ sender: UIButton) {
        self.selectImageFrom = "1" // Means Outpass Image Selection
        self.openCameraSwitch()
    }
    
    @objc func btnPOImage(_ sender: UIButton) {
        self.selectImageFrom = "2" // Means Meterial Image Selection
        self.openCameraSwitch()
    }
    
    @objc func btnMaterialImage(_ sender: UIButton) {
        self.selectImageFrom = "3" // Means Meterial Image Selection
        self.openCameraSwitch()
    }
    
    @objc func btnInvoiceImage(_ sender: UIButton) {
        self.selectImageFrom = "4" // Means Meterial Image Selection
        self.openCameraSwitch()
    }
    
    @objc func btnUpdateVehicleClicked(_ sender: UIButton) {
//        let point = sender.convert(CGPoint.zero, to: tableView)
//        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
//        let cell = tableView.cellForRow(at: indexPath) as! ExitVehicleCell
        let params = ["user_id": appDelegate.userLoginAccessDetails?.id ?? "",
                      "entry_id": objApproval?.uniqueId ?? "",
                      "company_name": self.vehicleDetail?.companyId ?? "",
                      "vendor_mobile": self.vehicleDetail?.vendorMobile ?? "",//Mobile number
                      "material_type": self.vehicleDetail?.materialType ?? "",
                      "driver_mobile_no": self.vehicleDetail?.driverContact ?? "",
                      "vehicle_number": self.vehicleDetail?.vehicleNumber ?? "",
                      "quantity": self.quantityWithUnitTxt,
                      "challan_number": self.chalanNumberTxt,
                      "po_number": self.poNumberTxt,
                      "inward_challan_image": "",
                      "invoice_img": invoiceImageBase64,
                      "commercial_vehicle_image": arrCommercialVehicleBase64.joined(separator: ","),
                      "po_img": arrPOImageBase64.joined(separator: ","),
                      "marterial": arrMaterialImageBase64.joined(separator: ","),
                      "outward_challan_image": "",
                          ] as [String: Any]
        updateVehicleAPI(params: params)
    }

    func updateVehicleAPI(params:[String:Any]) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            Webservice.Authentication.updateVehiclelApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["code"] as? Int == 200 {
                            let alertcontroller = UIAlertController(title: nil, message: "Vehicle Updated Successfully.", preferredStyle: .alert)
                            let yes = UIAlertAction(title: "OK", style: .default) { _ in
                                self.navigationController?.popViewController(animated: true)
                            }
                            alertcontroller.addAction(yes)
                            self.present(alertcontroller, animated: true)
                        }
                    }
                case let .fail(errorMsg):
                    self.view.makeToast(errorMsg, duration: 1.0, position: .center)
                }
            }
        }
    }
    
    func openCameraSwitch() {
        //Reload for height of collectionview
//         if self.arrOutpassImage.count == 0 && self.arrMeterialImage.count == 0 {
//           self.tableView.reloadSections(IndexSet(integer: 4), with: .none)
//         }

        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .camera
        myPickerController.allowsEditing = false
        present(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

//        guard  let exitTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? UpdateVehicleImageCell else { return }
        
        picker.dismiss(animated: true) {
            guard let selectedImage = info[.originalImage] as? UIImage else {
                print("Image not found!")
                return
            }
            guard let resizedImage = selectedImage.resized(withPercentage: 0.2) else { return }
            guard let imageData = resizedImage.jpegData(compressionQuality: 0.75) else { return }
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            if self.selectImageFrom == "1" { // Commercial Vehicle
                if picker.sourceType == UIImagePickerController.SourceType.camera {
                    let dic = ["image": selectedImage, "isDeleted": false] as [String : Any]
                    let model = ImageModel(fromDictionary: dic)
                    self.arrCommercialVehicleImg.append(model)
//                    exitTableViewCell.collectionCommVehicle.isHidden = false
//                    exitTableViewCell.collectionCommVehicle.reloadData()
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 4)], with: .none)
                    self.arrCommercialVehicleBase64.append(strBase64)
//                    self.uploadImage(outpass_image: strBase64, meterial_image: "")
                }
            } else if self.selectImageFrom == "2" { // PO Image
                if picker.sourceType == UIImagePickerController.SourceType.camera {
                    let dic = ["image": selectedImage, "isDeleted": false] as [String : Any]
                    let model = ImageModel(fromDictionary: dic)
                    self.arrPOImage.append(model)
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 4)], with: .none)
                    self.arrPOImageBase64.append(strBase64)
//                    self.uploadImage(outpass_image: "", meterial_image: strBase64)
                }
            } else if self.selectImageFrom == "3" { // Material
                if picker.sourceType == UIImagePickerController.SourceType.camera {
                    let dic = ["image": selectedImage, "isDeleted": false] as [String : Any]
                    let model = ImageModel(fromDictionary: dic)
                    self.arrMaterialImage.append(model)
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 4)], with: .none)
                    self.arrMaterialImageBase64.append(strBase64)
//                    self.uploadImage(outpass_image: strBase64, meterial_image: "")
                }
            } else if self.selectImageFrom == "4" { // Invoice
                if picker.sourceType == UIImagePickerController.SourceType.camera {
                    let dic = ["image": selectedImage, "isDeleted": false] as [String : Any]
                    self.invoiceImageModel = ImageModel(fromDictionary: dic)
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 4)], with: .none)
                    self.invoiceImageBase64 = strBase64
//                    self.uploadImage(outpass_image: strBase64, meterial_image: "")
                }
            }
        }
    }
    
    // MARK: - Upload image Api Functionality -------------------------------------------
    
    func uploadImage(outpass_image: String, meterial_image: String) {
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
extension EditVehiclesDetailLogVC {

    @objc func btnDeleteCommVehicleImgAction(sender: UIButton) {
        self.arrCommercialVehicleImg.remove(at: sender.tag)
        self.arrCommercialVehicleBase64.remove(at: sender.tag)
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 4)], with: .none)
    }
    
    @objc func btnDeletePOImgAction(sender: UIButton) {
        self.arrPOImage.remove(at: sender.tag)
        self.arrPOImageBase64.remove(at: sender.tag)
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 4)], with: .none)
    }
    
    @objc func btnDeleteMaterialImgAction(sender: UIButton) {
        self.arrMaterialImage.remove(at: sender.tag)
        self.arrMaterialImageBase64.remove(at: sender.tag)
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 4)], with: .none)
    }
}

extension EditVehiclesDetailLogVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        guard  let exitTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? ExitVehicleCell else { return }
//        if textField.isEqual(exitTableViewCell.txtIgnoreWithRemark){
//            self.ignoreWithRemark = textField.text ?? ""
//        }
      
        if textField.tag == 11 { // Quantity with unit
            self.quantityWithUnitTxt = textField.text ?? ""
        } else if textField.tag == 22 { // Challan Number
            self.chalanNumberTxt = textField.text ?? ""
        } else if textField.tag == 33 { // PO Number
            self.poNumberTxt = textField.text ?? ""
        }
    }
}
