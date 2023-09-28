//
//  ReportViewAndUploadVC.swift
//  EmployeeApp
//
//  Created by Jailove on 18/07/22.
//

import UIKit
import AVKit
import UniformTypeIdentifiers
import AVFoundation
import MobileCoreServices
import Alamofire
import Photos
import ProgressHUD

class ReportViewAndUploadVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    var site_ID = ""
    var sitePackage = ""
    @IBOutlet weak var scrollingViewUploadReport: UIScrollView!
    
    @IBOutlet weak var btnUploadReport: UIButton!
    @IBOutlet weak var btnViewReport: UIButton!
    @IBOutlet weak var btnUploadFile: UIButton!
    @IBOutlet weak var viewTxtView: UIView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var viewSelectName: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var lblUploadedFilePath: UILabel!
    @IBOutlet weak var lblStaffName: UILabel!
    
    
   var admin_Array = [AdminModel]()
   var employee_Array = [EmployeeModel]()
    var staff_Array = [StaffNameModel]()
    var staff_Array_UploadReport = [StaffNameModel]()
   var admin_Deleted_Array = [AdminDeletedModel]()
    var employee_Deleted_Array = [AdminDeletedModel]()
    
    var select_Labour_List_Array = [StaffNameModel]()
    var staff_ids = ""
    var staff_names = ""
    var staff_types = ""
    
    let imagepicker = UIImagePickerController()
    var captureImage: UIImage?
    var selectFileType = ""
    
    //MARK:- ScrollView View Report
    @IBOutlet weak var scrollingViewReport: UIScrollView!
    @IBOutlet weak var viewFilteDate: UIView!
    @IBOutlet weak var viewStartMonth: UIView!
    @IBOutlet weak var viewEndMonth: UIView!
    @IBOutlet weak var heightStackViewConstraint: NSLayoutConstraint! // 115
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var txtFieldDateFilter: UITextField!
    @IBOutlet weak var txtFieldStartMonth: UITextField!
    @IBOutlet weak var txtFieldEndMonth: UITextField!
    
    var search_Filter_vehicle_Log_Array = [String]()
    var select_Staff_Type_Array = [String]()
    var select_Staff_Name_Array : NSMutableArray = []
    
    var searchFilter_Value = ""
    var select_Staff_Type_value = ""
    var select_Staff_Name_value = ""
    var selecte_staff_Name_ID = ""
    var selected_Picker_Staff_Type = ""
    
    enum PickerType: String {
        case searchFilterPicker
        case select_Staff_Type_Picker
        case select_Staff_Name_Picker
    }

    var start_Date_Value = ""
    var end_Date_Value = ""
    var isCustomDateActive: Bool = false
    var currentPickerType: PickerType?
    @IBOutlet weak var TBLVIewRport: UITableView!
    @IBOutlet weak var heightTBLViewReportConstrinat: NSLayoutConstraint!
    var viewReport_Array = [ReportReceiveModel]()
    var count = Int()
    private var selectedSegStaffType = ""
    @IBOutlet weak var viewSelectStaff: UIView!
    @IBOutlet weak var viewSelectStaffSubCategory: UIView!
    
    @IBOutlet weak var txtFieldSelectStaff: UITextField!
    @IBOutlet weak var txFieldSelectStaffSubCategory: UITextField!
    @IBOutlet weak var viewNoDataFound: UIView!
    var k_files_Type = ""
    @IBOutlet weak var btnReceived: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnUploadReport.isEnabled = sitePackage != "0"
        if sitePackage == "0" {
            self.btnUploadReport.backgroundColor = .systemGray5
            self.btnUploadReport.setTitleColor(.lightGray, for: .disabled)
        }
        USERDEFAULTS.set(true, forKey: "ReportViewed")
        globleStaffNameList = [StaffNameModel]()
        scrollingViewUploadReport.isHidden = true
        scrollingViewReport.isHidden = true
        
        viewStartMonth.isHidden = true
        viewEndMonth.isHidden = true
       
        search_Filter_vehicle_Log_Array = ["Today", "Yesterday", "Last 7 Days", "Last 30 Days", "This Month", "Last Month", "Custom Range"]
        
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.heightStackViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        txtView.text = "Max 150 Characters"
        txtView.textColor = UIColor.lightGray
        
        btnUploadReport.layer.cornerRadius = 10
        btnViewReport.layer.cornerRadius = 10
        btnUploadFile.layer.cornerRadius = 10
        
        viewTxtView.layer.cornerRadius = 10
        viewTxtView.layer.borderWidth = 1
        viewTxtView.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        viewSelectName.layer.cornerRadius = 10
        viewSelectName.layer.borderWidth = 1
        viewSelectName.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        btnSubmit.layer.cornerRadius = 10
        btnSubmit.layer.borderWidth = 1
        btnSubmit.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        reportSeenFuncApi(user_type: "2", user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_ID, types: "1")
        staffNameFuncApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_ID)
        
        NotificationCenter.default.addObserver(self, selector: #selector(brandReceivedNotification(notification:)), name: Notification.Name("NotificationSelectedLabour"), object: nil)
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
    
    
    @objc func brandReceivedNotification(notification: Notification) {
        self.select_Labour_List_Array.removeAll()
        select_Labour_List_Array = notification.object as! [StaffNameModel]
        var idArray = [String]()
        var nameArray = [String]()
        var staffType = [String]()
        if select_Labour_List_Array.count > 0 {
            for i in 0 ..< select_Labour_List_Array.count {
                let id = select_Labour_List_Array[i].staff_id ?? ""
                let name = select_Labour_List_Array[i].name ?? ""
                let departMent = select_Labour_List_Array[i].department ?? ""
                let type = select_Labour_List_Array[i].staff_type ?? ""
                idArray.append(id)
                nameArray.append(departMent.isEmpty ? name : "\(name) (\(departMent))")
                staffType.append(type)
                staff_ids = idArray.joined(separator: ",")
                staff_types = staffType.joined(separator: ",")
                staff_names = nameArray.joined(separator: ",")
            }

            self.lblStaffName.text = "Selected Staff: \n\(staff_names)"
//            print("Staff IDS------>",staff_ids)
//            print("Staff Names------>",staff_names)
//            print("Staff Types------>",staff_types)
            if staff_names.contains("Owner") {
                
            }
        } else {
            self.lblStaffName.text = ""
//            print(staff_ids)
//            print(staff_names)
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnReloadAction(_ sender: Any) {
        scrollingViewUploadReport.isHidden = true
        scrollingViewReport.isHidden = true
    }
    
    func photoLibrary() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        present(myPickerController, animated: true, completion: nil)
    }
    
    // MARK: - Camera and Photo Library Image Selection ------------------------------------

    func cameraSwitch() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .camera
        myPickerController.allowsEditing = false
        present(myPickerController, animated: true, completion: nil)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 150    // 10 Limit Value
    }

    //MARK:- Select Upload File Type----------------------->
    func ShowDocumentTypeSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let Image = UIAlertAction(title: "Image", style: .default, handler: {
            (_: UIAlertAction) in
                self.selectFileType = "2"
                self.photoLibrary()
        })

        let PDF = UIAlertAction(title: "PDF", style: .default, handler: {
            (_: UIAlertAction) in

                let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
                importMenu.delegate = self
                importMenu.modalPresentationStyle = .formSheet
                self.present(importMenu, animated: true, completion: nil)
        })

        let Word = UIAlertAction(title: "Word", style: .default, handler: {
            (_: UIAlertAction) in

                let importMenu = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
                importMenu.delegate = self
                importMenu.modalPresentationStyle = .formSheet
                self.present(importMenu, animated: true, completion: nil)
        })

        let camera = UIAlertAction(title: "Camera", style: .default, handler: {
            (_: UIAlertAction) in
                self.selectFileType = "2"
                self.cameraSwitch()
        })

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (_: UIAlertAction) in

        })

        actionSheet.addAction(Image)
        actionSheet.addAction(PDF)
        actionSheet.addAction(Word)
        actionSheet.addAction(camera)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var imageUrl: URL!

        picker.dismiss(animated: true) {
            guard let selectedImage = info[.originalImage] as? UIImage else {
                print("Image not found!")
                return
            }
          
            if self.selectFileType == "2" {
                if picker.sourceType == UIImagePickerController.SourceType.camera {
                    let imgName = "\(UUID().uuidString).jpg"
                    let documentDirectory = NSTemporaryDirectory()
                    let localPath = documentDirectory.appending(imgName)
                    let data = selectedImage.jpegData(compressionQuality: 0.2)! as NSData
                    data.write(toFile: localPath, atomically: true)
                    imageUrl = URL(fileURLWithPath: localPath)
//                    print(selectedImage)
                  
                } else if let selectedImageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                    imageUrl = selectedImageUrl
                }

//                print(imageUrl as Any)

                let fullName: String = imageUrl.lastPathComponent
                let urlString = imageUrl.absoluteString
//                print(urlString)
                self.lblUploadedFilePath.text = urlString
                self.k_files_Type = urlString
//                print("fullname", fullName)
//                print("URL PATH--------->", urlString)
            }
        }
    }

    @objc func image(_: UIImage, didFinishSavingWithError error: Error?, contextInfo _: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            print("no guardada")
        } else {
            print("guardada")
        }
    }
    
    @IBAction func btnSelectStaffAction(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchLabourPopUpVC") as! SearchLabourPopUpVC
        popOverVC.staff_List_Array = staff_Array_UploadReport
        addChild(popOverVC)
        popOverVC.view.frame = view.frame
        view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    //MARK:- Upload File Action--------------------------->
    @IBAction func btnUploadAction(_ sender: Any) {
        ShowDocumentTypeSheet()
    }
    
    //MARK:- Sent And Receive Action Functionality--------------------------->
    
    @IBAction func btnRecivedAction(_ sender: Any) {
        btnReceived.setTitleColor(UIColor.blue, for: .normal)
        btnSend.setTitleColor(UIColor.black, for: .normal)
        selectedSegStaffType = ""
        uploadReportListFuncApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_ID, start_date: start_Date_Value, end_date: end_Date_Value, staff_type: selectedSegStaffType, staff_id: selecte_staff_Name_ID)
    }
    
    @IBAction func btnSentAction(_ sender: Any) {
        btnReceived.setTitleColor(UIColor.black, for: .normal)
        btnSend.setTitleColor(UIColor.blue, for: .normal)
        selectedSegStaffType = "2"
        uploadReportListFuncApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_ID, start_date: start_Date_Value, end_date: end_Date_Value, staff_type: selectedSegStaffType, staff_id: selecte_staff_Name_ID)
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        if staff_names == "" {
            self.view.makeToast("please select staff name", duration: 1.0, position: .center)
            return
        } else if k_files_Type == "" {
            self.view.makeToast("please upload a file", duration: 1.0, position: .center)
            return
        } else if txtView.text.isEmpty || txtView.text == "Max 150 Characters" {
            self.view.makeToast("please enter remark", duration: 1.0, position: .center)
            return
        } else {
            let url = NSURL(string: k_files_Type)
            let fileData = try! Data(contentsOf: url! as URL)
            let urlString = fileData.base64EncodedString()
            
            if k_files_Type.contains("pdf") {
                submitUploadReportApi(site_id: site_ID, user_id: appDelegate.userLoginAccessDetails?.id ?? "", staff: staff_ids, staff_type: staff_types, file: urlString, file_type: "pdf", remark: txtView.text ?? "")
            } else if k_files_Type.contains("docx") {
                submitUploadReportApi(site_id: site_ID, user_id: appDelegate.userLoginAccessDetails?.id ?? "", staff: staff_ids, staff_type: staff_types, file: urlString, file_type: "docx", remark: txtView.text ?? "")
            } else if k_files_Type.contains("jpg")  {
                submitUploadReportApi(site_id: site_ID, user_id: appDelegate.userLoginAccessDetails?.id ?? "", staff: staff_ids, staff_type: staff_types, file: urlString, file_type: "jpg", remark: txtView.text ?? "")
            } else if k_files_Type.contains("jpeg") {
                submitUploadReportApi(site_id: site_ID, user_id: appDelegate.userLoginAccessDetails?.id ?? "", staff: staff_ids, staff_type: staff_types, file: urlString, file_type: "jpeg", remark: txtView.text ?? "")
            } else if k_files_Type.contains("png") {
                submitUploadReportApi(site_id: site_ID, user_id: appDelegate.userLoginAccessDetails?.id ?? "", staff: staff_ids, staff_type: staff_types, file: urlString, file_type: "png", remark: txtView.text ?? "")
            }
        }
    }
    
    //MARK:- Upload Report Action------------------------------>
    @IBAction func btnUploadReportAction(_ sender: Any) {
        scrollingViewUploadReport.isHidden = false
        scrollingViewReport.isHidden = true
    }
    
    //MARK:- Select Staff Button Action Functionality---------------------------->
    @IBAction func btnViewReportSelectStaffAction(_ sender: Any) {
        currentPickerType = .select_Staff_Type_Picker
        showPicker(type: .select_Staff_Type_Picker, selectType: "Select Type")
    }
   
    @IBAction func btnViewReportSelectNameAction(_ sender: Any) {
        currentPickerType = .select_Staff_Name_Picker
        showPicker(type: .select_Staff_Name_Picker, selectType: "Select Name")
    }
    
    //MARK:- Search Button Action Functionality------------------>
    @IBAction func btnSearchAction(_ sender: Any) {
        uploadReportListFuncApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_ID, start_date: start_Date_Value, end_date: end_Date_Value, staff_type: selectedSegStaffType, staff_id: selecte_staff_Name_ID)
    }
        
  
    //MARK:- View Report Action------------------------------>
    @IBAction func btnViewReportAction(_ sender: Any) {
        self.txFieldSelectStaffSubCategory.text = ""
        self.selecte_staff_Name_ID = ""
        self.selected_Picker_Staff_Type = ""
        selectedSegStaffType = ""
        scrollingViewUploadReport.isHidden = true
        scrollingViewReport.isHidden = false
        self.TBLVIewRport.isHidden = false
        self.viewNoDataFound.isHidden = true
        btnSearch.layer.cornerRadius = 10
        
        viewFilteDate.layer.cornerRadius = 10
        viewFilteDate.layer.borderWidth = 1
        viewFilteDate.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        viewStartMonth.layer.cornerRadius = 10
        viewStartMonth.layer.borderWidth = 1
        viewStartMonth.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        viewEndMonth.layer.cornerRadius = 10
        viewEndMonth.layer.borderWidth = 1
        viewEndMonth.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        viewSelectStaff.layer.cornerRadius = 10
        viewSelectStaff.layer.borderWidth = 1
        viewSelectStaff.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        viewSelectStaffSubCategory.layer.cornerRadius = 10
        viewSelectStaffSubCategory.layer.borderWidth = 1
        viewSelectStaffSubCategory.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
                
        start_Date_Value = "\(Date.getCurrentDate())"
        end_Date_Value = "\(Date.getCurrentDate())"
        txtFieldDateFilter.text = "\(Date.getCurrentDate())"
        uploadReportListFuncApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_ID, start_date: start_Date_Value, end_date: end_Date_Value, staff_type: "", staff_id: "")
        
    }
    
    // MARK: - Report Seen Functionality -------------------------------------------

    func reportSeenFuncApi(user_type: String, user_id: String, site_id: String, types: String) { // Login Type 7 means Labor/Facility
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_type": user_type, "user_id": user_id, "site_id": site_id, "type": types] as [String: Any]

//            print(params)
            Webservice.Authentication.reportSeenApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {

//                            print("Report Seen Successfully------------>")
                        } else {
                            App_AlertView.shared.SimpleMessage(Text: body["message"] as? String ?? "")
                        }
                    }
                case let .fail(errorMsg):
                    self.view.makeToast(errorMsg, duration: 1.0, position: .center)
                }
            }
        }
    }
    
    
    // MARK: - Staff Name List Api Functionality -------------------------------------------

    func staffNameFuncApi(user_id: String, site_id: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": user_id, "site_id": site_id] as [String: Any]

//            print(params)
            Webservice.Authentication.StaffListApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {

                            self.staff_Array.removeAll()
                            self.staff_Array_UploadReport.removeAll()
                            
                            self.admin_Array.removeAll()
                            self.employee_Array.removeAll()
                            self.select_Labour_List_Array.removeAll()
                            self.staff_Array.append(StaffNameModel(fromDictionary: ["staff_id":"0","name": "Select Staff", "department":"","staff_type": ""]))
                            
                            if let userDataObj = body["user_data"] as? NSDictionary {
                                
                                if let ownerID = userDataObj.value(forKey: "owner_id") as? String, let owerName = userDataObj.value(forKey: "owner") as? String {
                                    let obj = StaffNameModel(fromDictionary: ["staff_id":ownerID,"name": owerName, "department":"","staff_type": "2"])
                                    self.staff_Array.append(obj)
                                    self.staff_Array_UploadReport.append(obj)
                                }
                                
                                if let dictionary = userDataObj.value(forKey: "admin_list") as? NSArray {
                                    
                                    for Dict in dictionary {
                                        let obj = AdminModel(fromDictionary: Dict as! [String: AnyObject])
                                        self.admin_Array.append(obj)
                                    }
                                    
                                    if self.admin_Array.count > 0 {
                                        for i in 0 ... self.admin_Array.count - 1 {
                                            let adminID = self.admin_Array[i].id ?? ""
                                            let adminName = self.admin_Array[i].name ?? ""
                                            let department = self.admin_Array[i].department ?? ""
                                            let obj = StaffNameModel(fromDictionary: ["staff_id":adminID,"name": "\(adminName)", "department":department,"staff_type": "3"])
                                            self.staff_Array.append(obj)
                                            self.staff_Array_UploadReport.append(obj)
                                        }
                                    }
                                }
                                
                                if let employeeDic = userDataObj.value(forKey: "employee_list") as? NSArray {
                                    
                                    for Dict in employeeDic {
                                        let obj = EmployeeModel(fromDictionary: Dict as! [String: AnyObject])
                                        self.employee_Array.append(obj)
                                    }
                                    
                                    if self.employee_Array.count > 0 {
                                        for i in 0 ... self.employee_Array.count - 1 {
                                            let employeeID = self.employee_Array[i].id ?? ""
                                            let employeeName = self.employee_Array[i].name ?? ""
                                            let department = self.employee_Array[i].department ?? ""
                                            let obj = StaffNameModel(fromDictionary: ["staff_id":employeeID,"name": "\(employeeName)", "department":department,"staff_type": "4"])
                                            self.staff_Array.append(obj)
                                            self.staff_Array_UploadReport.append(obj)
                                        }
                                    }
                                }
                                
                                if let adminDeletdeDic = userDataObj.value(forKey: "admin_deleted_list") as? NSArray  {
                                    
                                    for Dict in adminDeletdeDic {
                                        let obj = AdminDeletedModel(fromDictionary: Dict as! [String: AnyObject])
                                        self.admin_Deleted_Array.append(obj)
                                    }
                                    
                                    if self.admin_Deleted_Array.count > 0 {
                                        self.staff_Array.append(StaffNameModel(fromDictionary: ["staff_id":"2001","name": "-------------", "department":"","staff_type": ""]))
                                        self.staff_Array.append(StaffNameModel(fromDictionary: ["staff_id":"2002","name": "-- Admin Deleted List --", "department":"","staff_type": ""]))

                                        for i in 0 ... self.admin_Deleted_Array.count - 1 {
                                            let adminDeleteID = self.admin_Deleted_Array[i].id ?? ""
                                            let adminDeleteName = self.admin_Deleted_Array[i].name ?? ""
                                            let department = self.admin_Deleted_Array[i].department ?? ""
                                            let obj = AdminDeletedModel(fromDictionary: ["staff_id":adminDeleteID,"name": adminDeleteName, "department":department,"staff_type": "3"])
                                            self.admin_Deleted_Array.append(obj)
                                            let obj1 = StaffNameModel(fromDictionary: ["staff_id":adminDeleteID,"name": "\(adminDeleteName)", "department": department,"staff_type": "3"])
                                            self.staff_Array.append(obj1)
                                        }
                                    }
                                }
                                
                                if let employeeDeletedDic = userDataObj.value(forKey: "employee_deleted_list") as? NSArray {
                                    
                                    for Dict in employeeDeletedDic {
                                        let obj = AdminDeletedModel(fromDictionary: Dict as! [String: AnyObject])
                                        self.employee_Deleted_Array.append(obj)
                                    }
                                    
                                    if self.employee_Deleted_Array.count > 0 {
                                        self.staff_Array.append(StaffNameModel(fromDictionary: ["staff_id":"2003","name": "-------------", "department":"","staff_type": ""]))
                                        self.staff_Array.append(StaffNameModel(fromDictionary: ["staff_id":"2004","name": "-- Employee Deleted List --", "department":"","staff_type": ""]))
                                        for i in 0 ... self.employee_Deleted_Array.count - 1 {
                                            let adminDeleteID = self.employee_Deleted_Array[i].id ?? ""
                                            let adminDeleteName = self.employee_Deleted_Array[i].name ?? ""
                                            let department = self.employee_Deleted_Array[i].department ?? ""
                                            let obj = AdminDeletedModel(fromDictionary: ["staff_id":adminDeleteID,"name": adminDeleteName, "department":department,"staff_type": "3"])
                                            self.employee_Deleted_Array.append(obj)
                                            let obj1 = StaffNameModel(fromDictionary: ["staff_id":adminDeleteID,"name": "\(adminDeleteName)", "department": department,"staff_type": "4"])
                                            self.staff_Array.append(obj1)
                                        }
                                    }
                                }
                                
                                
                                if self.staff_Array.count > 0 && self.admin_Deleted_Array.count > 0 && self.employee_Deleted_Array.count > 0 {
                                    self.select_Staff_Type_Array = ["Select Name", "-- Admin Deleted List -- ", "-- Employee Deleted List -- "]
                                }
                                else if self.admin_Deleted_Array.count > 0 && self.employee_Deleted_Array.count > 0 {
                                    self.select_Staff_Type_Array = ["-- Admin Deleted List -- ", "-- Employee Deleted List -- "]
                                }
                                else if self.staff_Array.count > 0 && self.employee_Deleted_Array.count > 0 {
                                    self.select_Staff_Type_Array = ["Select Name", "-- Employee Deleted List --"]
                                }
                                else if self.staff_Array.count > 0 && self.admin_Deleted_Array.count > 0 {
                                    self.select_Staff_Type_Array = ["Select Name", "-- Admin Deleted List -- "]
                                }
                                else if self.employee_Deleted_Array.count > 0 {
                                    self.select_Staff_Type_Array = [ "-- Employee Deleted List -- "]
                                }
                                else  if self.staff_Array.count > 0 {
                                    self.select_Staff_Type_Array = ["Select Name"]
                                }
                                else if self.admin_Deleted_Array.count > 0 {
                                    self.select_Staff_Type_Array = ["-- Admin Deleted List -- "]
                                } else {
                                    //TODO Nothing
                                }
                                
                            }
                                                
                        } else {
                            App_AlertView.shared.SimpleMessage(Text: body["message"] as? String ?? "")
                        }
                    }
                case let .fail(errorMsg):
                    self.view.makeToast(errorMsg, duration: 1.0, position: .center)
                }
            }
        }
    }
    
    
    // MARK: - Upload Report Action Functionality *********************************************

    func submitUploadReportApi(site_id: String, user_id: String, staff: String, staff_type: String, file: String, file_type: String, remark: String) {
      
        DispatchQueue.main.async {
       
            if ProjectUtilities.checkInternateAvailable(viewController: self) {
                ProgressHUD.animationType = .circleStrokeSpin
                ProgressHUD.colorBackground = .white
                ProgressHUD.colorAnimation = AppColor.Color_SkyBlueTitle
                ProgressHUD.show("Uploading...")
            var params = [String: Any]()
            
            params = ["site_id": site_id,
                      "user_id": user_id,
                      "staff": staff,
                      "staff_type": staff_type,
                      "file": file,
                      "file_type": file_type,
                      "remark": remark,
            ] as [String: Any]

//            print("Upload Report Parameter----------->",params)

            let headers: HTTPHeaders = [
                "token": "c7d3965d49d4a59b0da80e90646aee77548458b3377ba3c0fb43d5ff91d54ea28833080e3de6ebd4fde36e2fb7175cddaf5d8d018ac1467c3d15db21c11b6909",
                "Content-Type": "application/json",
            ]

            let URL = try! URLRequest(url: "https://dev.sitepay.co.in/api/Owner/upload_report", method: .post, headers: headers)

            Alamofire.upload(multipartFormData: { multipartFormdata in

                for (key, value) in params {
                    multipartFormdata.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }

            }, with: URL) { result in

                switch result {
                case let .success(upload, _, _):

                    upload.uploadProgress(closure: { progress in
//                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    upload.responseJSON { [self] response in
//                        print(response)
//                        print("Response Get Successfully")
                        if let JSON = response.result.value {
//                            print("JSON: \(JSON)")
                            if let dic = JSON as? NSDictionary {
                                if dic.value(forKey: "code") as? Int == 200 {
                                    self.view.makeToast("Report Uploaded Successfully", duration: 1.0, position: .center)
                                    staff_names = ""
                                    k_files_Type = ""
                                    txtView.text = ""
                                    staff_ids = ""
                                    staff_types = ""
                                    txtFieldSelectStaff.text = ""
                                    txFieldSelectStaffSubCategory.text = ""
                                    self.lblStaffName.text =  ""
                                    self.lblUploadedFilePath.text = ""
                                    self.select_Labour_List_Array.removeAll()
                                    globleStaffNameList = [StaffNameModel]()
                                  //  self.perform(#selector(self.RedirectToSiteList), with: nil, afterDelay: 1.1)
                                } else  {
                                    self.view.makeToast(dic.value(forKey: "message") as? String ?? "", duration: 1.0, position: .center)
                                }
                            }
                        }
                        ProgressHUD.dismiss()
                    }

                case let .failure(encodingError):
//                    print(encodingError)
                    ProgressHUD.dismiss()
                }
            }
        }
      }
   }
    
    @objc
    func RedirectToSiteList() {
        self.navigationController?.popViewController(animated: true)
    }

    
    
    // MARK: - View Report List Api Functionality -------------------------------------------

    func uploadReportListFuncApi(user_id: String, site_id: String,start_date: String, end_date: String,staff_type: String, staff_id: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": user_id, "site_id": site_id,
                          "start_date": start_date, "end_date": end_date,
                          "staff_type": selected_Picker_Staff_Type, "staff_id": staff_id] as [String: Any]

//            print(params)
            Webservice.Authentication.uploadReportList(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["list"] as? String ?? "" == "Success" {
//                            self.TBLVIewRport.isHidden = true
//                            self.viewNoDataFound.isHidden = false
                            self.viewReport_Array.removeAll()
                            
                            if let userDataObj = body["message"] as? NSDictionary {
                                if staff_type == "", let dictionary = userDataObj.value(forKey: "receive") as? NSArray {
                                    for Dict in dictionary {
                                        let obj = ReportReceiveModel(fromDictionary: Dict as! [String: AnyObject])
                                        self.viewReport_Array.append(obj)
                                    }
                                } else if staff_type == "2", let dictionary = userDataObj.value(forKey: "send") as? NSArray {
                                    for Dict in dictionary {
                                        let obj = ReportReceiveModel(fromDictionary: Dict as! [String: AnyObject])
                                        self.viewReport_Array.append(obj)
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.view.layoutIfNeeded()
                                    self.TBLVIewRport.dataSource = self
                                    self.TBLVIewRport.delegate = self
                                    self.TBLVIewRport.reloadData()
                                    self.view.layoutIfNeeded()
                                    self.heightTBLViewReportConstrinat.constant = self.TBLVIewRport.contentSize.height
                                    self.view.layoutIfNeeded()
//                                            self.TBLVIewRport.isHidden = false
//                                            self.viewNoDataFound.isHidden = true
                                }
                            }
                        }
                    }
                case let .fail(errorMsg):
                    self.view.makeToast(errorMsg, duration: 1.0, position: .center)
                }
            }
        }
    }
    
    
    //MARK:- View Report Functionality--------------------------->
    @IBAction func btnDateFilterAction(_ sender: Any) {
        currentPickerType = .searchFilterPicker
        showPicker(type: .searchFilterPicker, selectType: "Select Date")
    }
    
    func showPicker(type: PickerType, selectType: String) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 280, height: 280)

        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 280, height: 280))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: nil, message: selectType, preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            let row = pickerView.selectedRow(inComponent: 0)
            if type == .searchFilterPicker {
            if self.search_Filter_vehicle_Log_Array.count > 0 {
                let element = self.search_Filter_vehicle_Log_Array[row]
                self.searchFilter_Value = element
                if element == "Today" {
                    self.isCustomDateActive = false
                    self.txtFieldDateFilter.text = "\(Date.getCurrentDate())"
                    self.start_Date_Value = "\(Date.getCurrentDate())"
                    self.end_Date_Value = "\(Date.getCurrentDate())"
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartMonth.isHidden = true
                        self.viewEndMonth.isHidden = true
                        self.heightStackViewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "Yesterday" {
                    self.isCustomDateActive = false
//                    print("\(Date.yesterday)")
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartMonth.isHidden = true
                        self.viewEndMonth.isHidden = true
                        self.heightStackViewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                    self.txtFieldDateFilter.text = self.convertDateFormater("\(Date.yesterday)")
                    self.start_Date_Value = self.convertDateFormater("\(Date.yesterday)")
                    self.end_Date_Value = self.convertDateFormater("\(Date.yesterday)")

                } else if element == "Last 7 Days" {
                    self.isCustomDateActive = false
                    self.getLast7Dates()
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartMonth.isHidden = true
                        self.viewEndMonth.isHidden = true
                        self.heightStackViewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }

                } else if element == "Last 30 Days" {
                    self.isCustomDateActive = false
                    self.getLast30Dates()
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartMonth.isHidden = true
                        self.viewEndMonth.isHidden = true
                        self.heightStackViewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "This Month" {
                    self.isCustomDateActive = false
                    let firstdate = "\(Date().startOfMonth())"
                    //  let lastdate = "\(Date().endOfMonth())"
                    self.txtFieldDateFilter.text = "\(self.convertDateFormater(firstdate)) To \(self.convertDateFormater("\(Date.yesterday)"))"

                    self.start_Date_Value = "\(self.convertDateFormater(firstdate))"
                    self.end_Date_Value = "\(self.convertDateFormater("\(Date.yesterday)"))"

                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartMonth.isHidden = true
                        self.viewEndMonth.isHidden = true
                        self.heightStackViewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "Last Month" {
                    self.isCustomDateActive = false
                    let first = "\(Date().getPreviousMonth().startOfMonth())"
                    let last = "\(Date().getPreviousMonth().endOfMonth())"

                    self.txtFieldDateFilter.text = "\(self.convertDateFormater(first)) To \(self.convertDateFormater(last))"

                    self.start_Date_Value = "\(self.convertDateFormater(first))"
                    self.end_Date_Value = "\(self.convertDateFormater(last))"

                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartMonth.isHidden = true
                        self.viewEndMonth.isHidden = true
                        self.heightStackViewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "Custom Range" {
                    self.isCustomDateActive = true
                    self.txtFieldDateFilter.text = "Custom Range"
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.heightStackViewConstraint.constant = 115
                        self.view.layoutIfNeeded()
                    }
                    self.viewStartMonth.isHidden = false
                    self.viewStartMonth.layer.cornerRadius = 10
                    self.viewStartMonth.layer.borderWidth = 1
                    self.viewStartMonth.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
                    self.txtFieldStartMonth.datePicker(target: self,
                                                       doneAction: #selector(self.startDoneAction),
                                                       cancelAction: #selector(self.startCancelAction),
                                                       datePickerMode: .date)
                    
                    self.viewEndMonth.isHidden = false
                    self.viewEndMonth.layer.cornerRadius = 10
                    self.viewEndMonth.layer.borderWidth = 1
                    self.viewEndMonth.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
                    
                    self.txtFieldEndMonth.datePicker(target: self,
                                                     doneAction: #selector(self.endDoneAction),
                                                     cancelAction: #selector(self.endCancelAction),
                                                     datePickerMode: .date)
                    
                } else {
                    self.isCustomDateActive = false
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.heightStackViewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                }
//                print("searchFilter_Value status-->", self.searchFilter_Value)
              }
            }
            else if type == .select_Staff_Type_Picker {
                if self.select_Staff_Type_Array.count > 0 {
                    let element = self.select_Staff_Type_Array[row]
                    self.select_Staff_Type_value = element
                    self.txtFieldSelectStaff.text = element
                }
            }  else if type == .select_Staff_Name_Picker {
                self.txFieldSelectStaffSubCategory.text = ""
                self.selecte_staff_Name_ID = ""
                self.selected_Picker_Staff_Type = ""
                let element = self.staff_Array[row]

                if element.staff_type ?? "" != "" {
                    self.txFieldSelectStaffSubCategory.text = element.department.isEmpty ? element.name ?? "" : "\(element.name ?? "") (\(element.department ?? ""))"
                    self.selecte_staff_Name_ID = element.staff_id ?? ""
                    self.selected_Picker_Staff_Type = element.staff_type ?? ""
                }
//                print("Selected Staff Type Value------->",self.select_Staff_Type_value)
               // self.select_Staff_Name_value = element.name ?? ""
                
                /*if self.select_Staff_Type_value.contains("Owner") {
                    let element = self.staff_Array[row]
                   // self.select_Staff_Name_value = element.name ?? ""
                    self.txFieldSelectStaffSubCategory.text = element.name ?? ""
                    self.selecte_staff_Name_ID = element.staff_id ?? ""
                    self.selected_Picker_Staff_Type = element.staff_type ?? ""
                    self.selected_Picker_Staff_Type = "2"
                }
                else if self.select_Staff_Type_value.contains("Select Name") {
                    let element = self.staff_Array[row]
                  //  self.select_Staff_Name_value = element.name ?? ""
                    if element.staff_type == "2" {
                        self.txFieldSelectStaffSubCategory.text = element.name ?? ""
                        self.selecte_staff_Name_ID = element.staff_id ?? ""
                        self.selected_Picker_Staff_Type = "2"
                    }
                   else if element.staff_type == "3" {
                        self.txFieldSelectStaffSubCategory.text = "\(element.name ?? "") (Admin)"
                        self.selected_Picker_Staff_Type = "3"
                    } else if  element.staff_type == "4" {
                        self.txFieldSelectStaffSubCategory.text = "\(element.name ?? "") (BACKEND)"
                        self.selected_Picker_Staff_Type = "4"
                    }
                   
                    self.selecte_staff_Name_ID = element.staff_id ?? ""
                }
//                -- Admin Deleted List --
                else if self.select_Staff_Type_value.contains("-- Admin Deleted List --") {
                    let element = self.admin_Deleted_Array[row]
                  //  self.select_Staff_Name_value = element.name ?? ""
                    if element.department == "Admin" {
                    self.txFieldSelectStaffSubCategory.text = "\(element.name ?? "") (Admin)"
                        self.selected_Picker_Staff_Type = "3"
                    } else  if element.department == "BACKEND" {
                        self.txFieldSelectStaffSubCategory.text = "\(element.name ?? "") (BACKEND)"
                        self.selected_Picker_Staff_Type = "4"
                    }
                    self.selecte_staff_Name_ID = element.id ?? ""
                }
                else if self.select_Staff_Type_value.contains("-- Employee Deleted List --") {
                    let element = self.employee_Deleted_Array[row]
                  //  self.select_Staff_Name_value = element.name ?? ""
                    if element.department == "Admin" {
                    self.txFieldSelectStaffSubCategory.text = "\(element.name ?? "") (Admin)"
                        self.selected_Picker_Staff_Type = "3"
                    } else  if element.department == "BACKEND" {
                        self.txFieldSelectStaffSubCategory.text = "\(element.name ?? "") (BACKEND)"
                        self.selected_Picker_Staff_Type = "4"
                    }
                    self.selecte_staff_Name_ID = element.id ?? ""
                }*/
            }
            else { return }
            
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))
        present(editRadiusAlert, animated: true)
    }
    
    func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date!)
    }
    
    func getLast7Dates() {
        let cal = Calendar.current
        let date = cal.startOfDay(for: Date())
        var days = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        for i in 1 ... 6 {
            let newdate = cal.date(byAdding: .day, value: -i, to: date)!
            let str = dateFormatter.string(from: newdate)
            days.append(str)
        }
//        print(days)
        let value = days.last
        txtFieldDateFilter.text = "\(value ?? "") To \(Date.getCurrentDate())"
        start_Date_Value = "\(value ?? "")"
        end_Date_Value = "\(Date.getCurrentDate())"
    }
    
    func getLast30Dates() {
        let cal = Calendar.current
        let date = cal.startOfDay(for: Date())
        var days = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        for i in 1 ... 29 {
            let newdate = cal.date(byAdding: .day, value: -i, to: date)!
            let str = dateFormatter.string(from: newdate)
            days.append(str)
        }
//        print(days)
        let value = days.last
        txtFieldDateFilter.text = "\(value ?? "") To \(Date.getCurrentDate())"
        start_Date_Value = "\(value ?? "")"
        end_Date_Value = "\(Date.getCurrentDate())"
    }
    
    @objc
    func startDoneAction() {
        if let datePickerView = txtFieldStartMonth.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: datePickerView.date)
            txtFieldStartMonth.text = dateString
            start_Date_Value = dateString
            
//            print(datePickerView.date)
//            print(dateString)
            txtFieldStartMonth.resignFirstResponder()
        }
    }

    @objc
    func startCancelAction() {
        txtFieldStartMonth.resignFirstResponder()
    }

    @objc
    func endDoneAction() {
        if let datePickerView = txtFieldEndMonth.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: datePickerView.date)
            txtFieldEndMonth.text = dateString
            end_Date_Value = dateString
//            print(datePickerView.date)
//            print(dateString)

            txtFieldEndMonth.resignFirstResponder()
        }
    }

    @objc
    func endCancelAction() {
        txtFieldEndMonth.resignFirstResponder()
    }

}

extension ReportViewAndUploadVC: UIDocumentMenuDelegate, UIDocumentPickerDelegate {
    public func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.last else {
            return
        }
        let fullname: String = myURL.lastPathComponent
        let filePath = myURL // URL of the PDF
        let urlString = myURL.absoluteString
//        print(urlString)
        self.lblUploadedFilePath.text = urlString
        k_files_Type = urlString
//        print("fullname", fullname)
//        print("URL PATH--------->", urlString)
//        print("import result : \(myURL)")
    }

    public func documentMenu(_: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }

    func documentPickerWasCancelled(_: UIDocumentPickerViewController) {
//        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}

extension ReportViewAndUploadVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = "Max 150 Characters"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension ReportViewAndUploadVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        guard let inputType = currentPickerType else { return 0 }
        if inputType == .searchFilterPicker {
            return search_Filter_vehicle_Log_Array.count
        }
        else if inputType == .select_Staff_Type_Picker {
            return select_Staff_Type_Array.count
        }
        else if inputType == .select_Staff_Name_Picker {
            return staff_Array.count
//            if self.select_Staff_Type_value.contains("Owner") {
//               return staff_Array.count
//           } else if self.select_Staff_Type_value.contains("Select Name") {
//               return staff_Array.count
//           } else if self.select_Staff_Type_value.contains("-- Admin Deleted List --")  {
//               return admin_Deleted_Array.count
//           } else {
//               return employee_Deleted_Array.count
//           }
       }
        else {
            return 0
        }
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        guard let inputType = currentPickerType else { return "" }
        if inputType == .searchFilterPicker {
            let element = search_Filter_vehicle_Log_Array[row]
            return element
        }  else if inputType == .select_Staff_Type_Picker {
            let element = select_Staff_Type_Array[row]
            return element
        } else if inputType == .select_Staff_Name_Picker {
            return staff_Array[row].department.isEmpty ? "\(staff_Array[row].name ?? "")" : "\(staff_Array[row].name ?? "") (\(staff_Array[row].department ?? ""))"
           /* if self.select_Staff_Type_value.contains("Owner") {
                if staff_Array[row].staff_type == "2" {
                    let element = staff_Array[row].name
                    
                } else if staff_Array[row].staff_type == "3" {
                    let element = "\(staff_Array[row].name ?? "") (Admin)"
                    return element
                } else if staff_Array[row].staff_type == "4" {
                    let element = "\(staff_Array[row].name ?? "") (BACKEND)"
                    return element
                } else {
                    return ""
                }
              
            } else if self.select_Staff_Type_value.contains("Select Name") {
               
                if staff_Array[row].staff_type == "2" {
                    let element = staff_Array[row].name
                    return element
                } else if staff_Array[row].staff_type == "3" {
                    let element = "\(staff_Array[row].name ?? "") (Admin)"
                    return element
                } else if staff_Array[row].staff_type == "4" {
                    let element = "\(staff_Array[row].name ?? "") (BACKEND)"
                    return element
                } else {
                    return ""
                }
            } else if self.select_Staff_Type_value.contains("-- Admin Deleted List --")  {
                if admin_Deleted_Array[row].department == "Admin" {
                    let element = "\(admin_Deleted_Array[row].name ?? "") (Admin)"
                    return element
                } else if admin_Deleted_Array[row].department == "BACKEND" {
                    let element = "\(admin_Deleted_Array[row].name ?? "") (BACKEND)"
                    return element
                } else {
                    return ""
                }
               
            } else {
//                let element = employee_Deleted_Array[row].name
//                return element
                if employee_Deleted_Array[row].department == "Admin" {
                    let element = "\(employee_Deleted_Array[row].name ?? "") (Admin)"
                    return element
                } else if employee_Deleted_Array[row].department == "BACKEND" {
                    let element = "\(employee_Deleted_Array[row].name ?? "") (BACKEND)"
                    return element
                } else {
                    return ""
                }
            }*/
        }
        else {
            return ""
        }
    }
}

// MARK: - UITable View Data Source and Delegates Methods******************************

extension ReportViewAndUploadVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewReport_Array.count > 0 ? viewReport_Array.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewReport_Array.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewReportTableCell", for: indexPath) as! ViewReportTableCell
            let obj = viewReport_Array[indexPath.row]
            cell.selectionStyle = .none
            count = indexPath.row + 1
            cell.lblSrNo.text = "\(count)"
            cell.lblName.text = ""
            if indexPath.row % 2 == 0 {
                cell.viewSrNo.backgroundColor = UIColor.white
                cell.viewName.backgroundColor = UIColor.white
                cell.viewRemark.backgroundColor = UIColor.white
                cell.viewDateAndTime.backgroundColor = UIColor.white

            } else {
                cell.viewSrNo.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewName.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewRemark.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewDateAndTime.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
            }
            
            if obj.name.contains(",") {
                cell.btnName.isHidden = false
                cell.btnName.setTitle("View Names", for: .normal)
                cell.btnName.titleLabel?.numberOfLines = 0
                cell.btnName.titleLabel?.lineBreakMode = .byWordWrapping
                cell.btnName.contentHorizontalAlignment = .center
                cell.btnName.setTitleColor(AppColor.Color_TopHeader, for: .normal)
                cell.btnName.tag = indexPath.row
                cell.btnName.addTarget(self, action: #selector(btnNameAction(sender:)), for: .touchUpInside)
            } else {
                cell.btnName.isHidden = true
                cell.lblName.text = obj.name ?? ""
            }
            
            cell.btnViewRemark.tag = indexPath.row
            cell.btnViewRemark.addTarget(self, action: #selector(btnRemarkAction(sender:)), for: .touchUpInside)
            
            cell.lblDateAndTime.text = obj.createdDate ?? ""
            cell.btnImageDownload.layer.cornerRadius = 8
            cell.btnImageDownload.setTitle(obj.fileType.uppercased(), for: .normal)
            
            cell.btnImageDownload.tag = indexPath.row
            cell.btnImageDownload.addTarget(self, action: #selector(btnImageDownloadAction(sender:)), for: .touchUpInside)
            
            return cell
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataCell", for: indexPath) as? UITableViewCell {
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay _: UITableViewCell, forRowAt _: IndexPath) {
        
        DispatchQueue.main.async {
            self.heightTBLViewReportConstrinat.constant = self.TBLVIewRport.contentSize.height
        }
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return viewReport_Array.count > 0 ? UITableView.automaticDimension : 21.0
    }
    

    @objc func btnRemarkAction(sender: UIButton) {
        DispatchQueue.main.async {
            let obj = self.viewReport_Array[sender.tag]
            self.AlertControllersPresent(messages: obj.remark ?? "")
        }
    }
    
    @objc func btnNameAction(sender: UIButton) {
        DispatchQueue.main.async {
            let obj = self.viewReport_Array[sender.tag]
            self.AlertControllersPresent(messages: obj.name ?? "")
        }
    }
    
    @objc func btnImageDownloadAction(sender: UIButton) {
        DispatchQueue.main.async {
            let obj = self.viewReport_Array[sender.tag]
            if obj.fileType.lowercased() == "jpg" || obj.fileType.lowercased() == "png" {
                let photos = PHPhotoLibrary.authorizationStatus()
                if photos == .denied {
                    self.view.makeToast("please allow all photos to download image", duration: 2.0, position: .center)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                        self.savePhotoToAlbum(obj.file ?? "") { error in
                        }
                        self.gotoAppPrivacySettings()
                    }
                } else {
                    ProgressHUD.animationType = .circleStrokeSpin
                    ProgressHUD.colorBackground = .white
                    ProgressHUD.colorAnimation = AppColor.Color_SkyBlueTitle
                    ProgressHUD.show("Downloading...")
                    self.savePhotoToAlbum(obj.file ?? "") { error in
        
                    }
                }
            } else {
                self.savePdf(obj.file ?? "")
            }
        }
    }
    
    func savePdf(_ fileUrl: String) {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorBackground = .white
        ProgressHUD.colorAnimation = AppColor.Color_SkyBlueTitle
        ProgressHUD.show("Downloading...")
        if let url = URL(string: fileUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let pdfData = data {
                    DispatchQueue.main.async {
                        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                        let pdfNameFromUrl = url.lastPathComponent
                        let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                
                        do {
                            try pdfData.write(to: actualPath, options: .atomic)
                            self.view.makeToast("File successfully saved!", duration: 1.0, position: .center)
                            ProgressHUD.dismiss()
                            print("pdf successfully saved!")
                        } catch {
                            ProgressHUD.dismiss()
                            print("Pdf could not be saved")
                        }
                    }
                } else {
                    ProgressHUD.dismiss()
                }
            }.resume()
        } else {
            ProgressHUD.dismiss()
        }
    }
    
    func savePhotoToAlbum(_ vidUrlString: String, _: ((Error?) -> Void)?) {
        requestAuthorization {
            DispatchQueue.global(qos: .background).async {
                if let url = URL(string: vidUrlString),
                   let urlData = NSData(contentsOf: url)
                {
                    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                    let filePath = "\(documentsPath)/\(url.lastPathComponent)"
                    DispatchQueue.main.async {
                        urlData.write(toFile: filePath, atomically: true)
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: URL(fileURLWithPath: filePath))
                        }) { completed, error in
                            if completed {
                                // self.downloadAPI()
                                DispatchQueue.main.async { // Correct
                                    ProgressHUD.dismiss()
                                    self.dismiss(animated: true) {
                                        let ac = UIAlertController(title: "Saved!", message: "Your Image has been saved to your Gallery.", preferredStyle: .alert)
                                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                                        self.present(ac, animated: true)
//                                        print("Image is saved!")
                                    }
                                }

                            } else {
                                DispatchQueue.main.async { // Wrong
                                    ProgressHUD.dismiss()
                                    self.dismiss(animated: true) {
                                        let ac = UIAlertController(title: "Image not Saved", message: error?.localizedDescription, preferredStyle: .alert)
                                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                                        self.present(ac, animated: true)
                                        print("Image not saved!")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func gotoAppPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url) else {
                assertionFailure("Not able to open App privacy settings")
                return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func AlertControllersPresent(messages:String) {
        let alertcontroller = UIAlertController(title: nil, message: messages, preferredStyle: .alert)
        let yes = UIAlertAction(title: "OK", style: .default) { _ in
            
        }
        alertcontroller.addAction(yes)
        present(alertcontroller, animated: true)
    }
    
    //MARK:- Download JPG/PNG Image Functionality---------------------->
    func requestAuthorization(completion: @escaping () -> Void) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { _ in
                DispatchQueue.main.async {
                    completion()
                }
            }
        } else if PHPhotoLibrary.authorizationStatus() == .authorized {
            completion()
        }
    }
}

