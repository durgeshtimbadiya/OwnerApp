//
//  UserProfileVC.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 23/11/21.

import Alamofire
import CoreLocation
import MobileCoreServices
import SDWebImage
import UIKit
import UniformTypeIdentifiers
import ProgressHUD

class UserProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, PrLocation {
    @IBOutlet var btnProfile: UIButton!

    // UIView
    @IBOutlet var viewName: UIView!
    @IBOutlet var viewPhone: UIView!
    @IBOutlet var viewEmail: UIView!
//    @IBOutlet var viewDOB: UIView!
//    @IBOutlet var viewBloodGroup: UIView!
//    @IBOutlet var viewAddress: UIView!
//    @IBOutlet var viewDepartment: UIView!
//    @IBOutlet var viewDesignation: UIView!
    @IBOutlet var viewCustomerId: UIView!
    @IBOutlet var viewCompanyNameView: UIView!
    @IBOutlet var viewBusinessType: UIView!

    // UITextField
    @IBOutlet var txtFieldName: UITextField!
    @IBOutlet var txtFieldCustomerId: UITextField!
    @IBOutlet var txtFieldBusinType: UITextField!
    @IBOutlet var txtFieldPhone: UITextField!
    @IBOutlet var txtFieldEmail: UITextField!
    @IBOutlet var txtFieldCompanyName: UITextField!
    @IBOutlet var panCardImageBtn: UIButton!
    
    @IBOutlet var lblCompanyName: UILabel!
    @IBOutlet var lblCustomerId: UILabel!
    @IBOutlet var lblBusinessType: UILabel!
    @IBOutlet var lblPanCard: UILabel!

//    @IBOutlet var txtFieldDOB: UITextField!
//    @IBOutlet var txtFIeldBloodGroup: UITextField!
//    @IBOutlet var txtFieldAddress: UITextField!
//    @IBOutlet var txtFieldDepartment: UITextField!
//    @IBOutlet var txtFieldDesignation: UITextField!

    // @IBOutlet weak var btnUploadDocment: UIButton!
    @IBOutlet var btnUpdateProflie: UIButton!

    let imagepicker = UIImagePickerController()
    var captureImage: UIImage?
    var profilePicBase64 = ""

    var selectAdhar: Bool = false

    // Picker
    enum PickerType: String {
        case designation
        case policeVerification
    }

    var currentPickerType: PickerType?

    var profileStatus = ""
    var profilePic_Removed = "0"
    var new_Department = "0"
    var new_Designation = "0"
    private var panCardImageURL = ""
    var companyID = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        CornnerRadiousfunc()
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

    func GetLocation(currentLocation: CLLocationCoordinate2D) {
        let lat = currentLocation.latitude
        let long = currentLocation.longitude
        print("\(lat)")
        print("\(long)")
    }

    func CornnerRadiousfunc() {
        LocationManagerSingleton.shared.StartStopUpdatingLocation(start: true)
        LocationManagerSingleton.shared.delegate = self
       
        txtFieldName.isUserInteractionEnabled = true
        txtFieldPhone.isUserInteractionEnabled = false
        txtFieldEmail.isUserInteractionEnabled = true
        txtFieldCustomerId.isUserInteractionEnabled = false
        txtFieldCompanyName.isUserInteractionEnabled = false
        txtFieldBusinType.isUserInteractionEnabled = false
        
     //   txtFIeldBloodGroup.isUserInteractionEnabled = false
     //   txtFieldAddress.isUserInteractionEnabled = false
//        txtFieldDepartment.isUserInteractionEnabled = false
//        txtFieldDesignation.isUserInteractionEnabled = false

        viewName.layer.cornerRadius = 10
        viewName.layer.borderWidth = 1
        viewName.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

        viewPhone.layer.cornerRadius = 10
        viewPhone.layer.borderWidth = 1
        viewPhone.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

        viewEmail.layer.cornerRadius = 10
        viewEmail.layer.borderWidth = 1
        viewEmail.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

//        viewDOB.layer.cornerRadius = 10
//        viewDOB.layer.borderWidth = 1
//        viewDOB.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
//
//        viewBloodGroup.layer.cornerRadius = 10
//        viewBloodGroup.layer.borderWidth = 1
//        viewBloodGroup.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
//
//        viewAddress.layer.cornerRadius = 10
//        viewAddress.layer.borderWidth = 1
//        viewAddress.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
//
//        viewDepartment.layer.cornerRadius = 10
//        viewDepartment.layer.borderWidth = 1
//        viewDepartment.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

//        viewDesignation.layer.cornerRadius = 10
//        viewDesignation.layer.borderWidth = 1
//        viewDesignation.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        viewCompanyNameView.layer.cornerRadius = 10
        viewCompanyNameView.layer.borderWidth = 1
        viewCompanyNameView.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        viewCustomerId.layer.cornerRadius = 10
        viewCustomerId.layer.borderWidth = 1
        viewCustomerId.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        
        viewBusinessType.layer.cornerRadius = 10
        viewBusinessType.layer.borderWidth = 1
        viewBusinessType.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

        btnUpdateProflie.dropShadowWithCornerRadius()
        btnProfile.layer.cornerRadius = btnProfile.layer.bounds.height / 2
        btnProfile.clipsToBounds = true
        //  policeVerification_Array = ["NO","YES"]

        if appDelegate.userLoginAccessDetails?.id != nil {
            ProfileDetailsfunc(userID: appDelegate.userLoginAccessDetails?.id ?? "")
        }
//        txtFieldDOB.datePicker(target: self,
//                               doneAction: #selector(doneAction),
//                               cancelAction: #selector(cancelAction),
//                               datePickerMode: .date)
    }

    // MARK: - UIDate Picker Done and Cancel Button Action -------------------------------

//    @objc
//    func doneAction() {
//        if let datePickerView = txtFieldDOB.inputView as? UIDatePicker {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd-MM-yyyy"
//            let dateString = dateFormatter.string(from: datePickerView.date)
//            txtFieldDOB.text = dateString
//
//            print(datePickerView.date)
//            print(dateString)
//
//            txtFieldDOB.resignFirstResponder()
//        }
//    }
//
//    @objc
//    func cancelAction() {
//        txtFieldDOB.resignFirstResponder()
//    }

    // MARK: - Camera and Photo Library Image Selection ------------------------------------

    func cameraSwitch() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerController.SourceType.camera
        present(myPickerController, animated: true, completion: nil)
    }

    func photoLibrary() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        present(myPickerController, animated: true, completion: nil)
    }

    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if profileStatus == "0" {
            let camera = UIAlertAction(title: "Camera", style: .default, handler: {
                (_: UIAlertAction) in

                    self.cameraSwitch()
            })

            let photoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: {
                (_: UIAlertAction) in

                    self.photoLibrary()
            })

            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (_: UIAlertAction) in

            })
            actionSheet.addAction(camera)
            actionSheet.addAction(photoLibrary)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true, completion: nil)

        } else {
            let camera = UIAlertAction(title: "Camera", style: .default, handler: {
                (_: UIAlertAction) in
                    self.cameraSwitch()
            })

            let photoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: {
                (_: UIAlertAction) in

                    self.photoLibrary()
            })

            let removePhoto = UIAlertAction(title: "Remove Photo", style: .default, handler: {
                (_: UIAlertAction) in
                    // TODO: - Remove Profile Photo APi Call
                    if appDelegate.userLoginAccessDetails?.id != nil {
                        self.ProfileRemovefuncApi(userID: appDelegate.userLoginAccessDetails?.id ?? "", profileRemoved: "1")
                    }
            })

            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (_: UIAlertAction) in

            })
            actionSheet.addAction(camera)
            actionSheet.addAction(photoLibrary)
            actionSheet.addAction(removePhoto)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true, completion: nil)
        }
    }

    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true) {
            guard let selectedImage = info[.originalImage] as? UIImage else {
                print("Image not found!")
                return
            }

            if self.selectAdhar == true {}
            else {
                self.profileStatus = "1"
                self.captureImage = selectedImage
                
                self.btnProfile.setImage(self.captureImage, for: .normal)
                self.btnProfile.contentMode = .scaleAspectFill
                
                guard let resizedImage = selectedImage.resized(withPercentage: 0.2) else { return }
                guard let imageData = resizedImage.jpegData(compressionQuality: 0.75) else { return }
                self.profilePicBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            }
        }
    }

    @IBAction func btnBackAction(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Profile Image Action----------------
    @IBAction func btnProfileImageAction(_: Any) {
        selectAdhar = false
        showActionSheet()
    }

    @IBAction func btnUpdateProfileAction(_: Any) {
        if txtFieldEmail.text!.isEmpty || !self.isValidEmail(txtFieldEmail.text!) {
            self.view.makeToast(ValidationMessages.emailAddress, duration: 1.0, position: .center)
            return
        }
        if appDelegate.userLoginAccessDetails?.id != nil {
            UpdateProfileApi()
        }
    }
    
    func isValidEmail(_ strEmail: String) -> Bool {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" + "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: strEmail)
    }
    
    @IBAction func tapOnPanImage(_ sender: UIButton) {
        if !panCardImageURL.isEmpty, let vc = UIStoryboard(name: "Vehicle", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController {
            vc.imageURL = panCardImageURL
            Functions.pushToViewController(self, toVC: vc)
        } else {
            self.view.makeToast("No image found!", duration: 1.0, position: .center)
        }
    }

    // MARK: -  Profile Details Api Functionality-------------------------------

    func ProfileDetailsfunc(userID: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": userID] as [String: Any]

            Webservice.Authentication.GetProfileDataApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "success" {
                            if let user = body["data"] as? NSDictionary {
                                if let img = user.value(forKey: "profile_pic") as? String {
                                    print(img)
                                    self.btnProfile.sd_setImage(with: URL(string: img), for: .normal, placeholderImage: UIImage(named: "nopreview"), options: .refreshCached, context: nil)
                                    if !img.isEmpty {
                                        DispatchQueue.main.async {
                                            if let imageURL = URL(string: img) {
                                                do {
                                                    let imageData = try Data(contentsOf: imageURL)
                                                    self.profilePicBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                                                } catch  { }
                                            }
                                        }
                                    }
                                } else {
                                    self.btnProfile.setImage(UIImage(named: "nopreview"), for: .normal)
                                }

                                if let name = user.value(forKey: "name") as? String {
                                    self.txtFieldName.text = name
                                }
                                
                                if let type = user.value(forKey: "owner_unique_id") as? String {
                                    self.txtFieldCustomerId.text = type
                                }
                                
                                if let type = user.value(forKey: "type") as? String {
                                    switch type {
                                    case "1":
                                        self.txtFieldBusinType.text = "Sole Proprietorship"
                                        break
                                    case "2":
                                        self.txtFieldBusinType.text = "Partnership"
                                        break
                                    case "3":
                                        self.txtFieldBusinType.text = "LLP"
                                        break
                                    case "4":
                                        self.txtFieldBusinType.text = "Private Limited"
                                        break
                                    case "5":
                                        self.txtFieldBusinType.text = "Public Limited"
                                        break
                                    case "6":
                                        self.txtFieldBusinType.text = "Others"
                                        break
                                    default:
                                        break
                                    }
                                }
                                
                                /*
                                 {
                                     "added_date" = "2023-04-01 17:17:50";
                                     address = "Mumbai, maharshtra, india";
                                     company = "SHIVA PVT LTD";
                                     country = India;
                                     "crm_id" = 9;
                                     designation = Manager;
                                     "device_id" = "fHlzhjzM8USJmeOb3RS7P6:APA91bHtsD2OlSRLx81h004khKwMGbrjKC0gcCD1DsoGTmpWcVGwQAtnjIUF1KeWt72-5s50lC2s9W9nIinYhtwMgkcfWAxthgPVRB8b_Eoe3f7YNaKbaTGGkyWD8Ip2OcotAF_82E00";
                                     "device_type" = 1;
                                     district = 2;
                                     document = "pan/sample_doc5.jpg";
                                     email = "ankitam.androapps@gmail.com";
                                     "gst_no" = GST222222222222;
                                     id = 161;
                                     isBlocked = 0;
                                     isDeleted = 0;
                                     "is_demo" = 0;
                                     "loged_in" = 2;
                                     "login_status" = 1;
                                     mobile = 8104525751;
                                     "mute_notification" = 0;
                                     name = "Shiv Mohandas";
                                     "no_active_sites" = 7;
                                     "no_employees" = "101 to 250";
                                     otp = 1234;
                                     "owner_unique_id" = SHI161;
                                     pan = "pan/pan_sample8.jpg";
                                     "pan_no" = PAN1111111;
                                     password = 1234;
                                     "profile_pic" = "https://dev.sitepay.co.in/data/owner/1681298617.jpg";
                                     "profile_status" = 0;
                                     state = 2;
                                     "sw_password" = 81dc9bdb52d04dc20036dbd8313ed055;
                                     type = 4;
                                     "updated_date" = "2023-08-29 12:17:54";
                                     "website_url" = "https://dev.sitepay.co.in/User/User_registration";
                                 }*/
                                
                                if let company = user.value(forKey: "company") as? String {
                                    self.txtFieldCompanyName.text = company
                                }
                                
                                if let panC = user.value(forKey: "pan") as? String {
                                    self.panCardImageURL = "\(Webservice.baseUrl1)\(panC)"
                                    self.panCardImageBtn.sd_setImage(with: URL(string: self.panCardImageURL), for: .normal, placeholderImage: UIImage(named: "nopreview"), options: .refreshCached, context: nil)
                                }
                                //company, mute_notification, type, pan
                                //https://dev.sitepay.co.in/data/pan/The_Real_Squere_VC_Ulwe_LOGO11.jpg

                                if let phone = user.value(forKey: "mobile") as? String {
                                    self.txtFieldPhone.text = phone
                                }

                                if let email = user.value(forKey: "email") as? String {
                                    self.txtFieldEmail.text = email
                                }

//                                if let dob = user.value(forKey: "dob") as? String {
//                                    self.txtFieldDOB.text = dob
//                                }

//                                if let BloodGroup = user.value(forKey: "blood_group") as? String {
//                                    self.txtFIeldBloodGroup.text = BloodGroup
//                                }
//
//                                if let address = user.value(forKey: "address") as? String {
//                                    self.txtFieldAddress.text = address
//                                }
//
//                                if let department = user.value(forKey: "department") as? String {
//                                    self.txtFieldDepartment.text = department
//                                    self.new_Department = "1"
//                                } else {
//                                    self.new_Department = "0"
//                                }
//
//                                if let designation = user.value(forKey: "designation") as? String {
//                                    self.txtFieldDesignation.text = designation
//                                    self.new_Designation = "1"
//                                } else {
//                                    self.new_Designation = "0"
//                                }

                                if let profile = user.value(forKey: "profile_status") as? String {
                                    self.profileStatus = profile
                                }
                            }
                        } else {}
                    }
                case let .fail(errorMsg):
                    print(errorMsg)
                }
            }
        }
    }

    // MARK: -  Profile Remove Api Functionality-------------------------------

    func ProfileRemovefuncApi(userID: String, profileRemoved: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": userID,
                          "profile_pic_remove": profileRemoved] as [String: Any]

            Webservice.Authentication.RemoveProfilePhotoApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["code"] as? Int ?? 0 == 200 {
                            self.profilePic_Removed = "1"
                            self.view.makeToast("Profile Photo removed Successfully", duration: 0.6, position: .center)
                            self.perform(#selector(self.RedirectToSelfPage), with: nil, afterDelay: 0.6)

                        } else {}
                    }
                case let .fail(errorMsg):

                    print(errorMsg)
                }
            }
        }
    }

    @objc func RedirectToSelfPage() {
        if appDelegate.userLoginAccessDetails?.id != nil {
            ProfileDetailsfunc(userID: appDelegate.userLoginAccessDetails?.id ?? "")
        }
    }

    // MARK: - Update Profile Details*********************************************

    func UpdateProfileApi() {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            DispatchQueue.main.async {
                var panCardImageBase64 = ""
                if let imageURL = URL(string: self.panCardImageURL) {
                    do {
                        let imageData = try Data(contentsOf: imageURL)
                        panCardImageBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                    } catch  { }
                }
                
                let params = ["user_id": appDelegate.userLoginAccessDetails?.id ?? "",
                              "name": self.txtFieldName.text ?? "",
                              "mobile": self.txtFieldPhone.text ?? "",
                              "email": self.txtFieldEmail.text ?? "",
                              "company": self.txtFieldCompanyName.text ?? "",
                              "pan": panCardImageBase64,
                              "pan_status": panCardImageBase64.isEmpty ? "0" : "1",
                              //                          "dob": dobdate,
                              //                          "blood_group": bloodGroup,
                              //                          "address": address,
                              //                          "designation": designation,
                              //                          "new_designation": new_designation,
                              //                          "department": department,
                              //                          "new_department": new_department,
                              "profile_pic": self.profilePicBase64,
                              "profile_status": self.profileStatus,
                              //                          "vehicle": vehivleno,
                              "profile_pic_remove": "0"] as [String: Any]
                
                Webservice.Authentication.RemoveProfilePhotoApi(parameter: params) { result in
                    switch result {
                    case let .success(response):
                        if let body = response.body as? [String: Any] {
                            if body["message"] as? String ?? "" == "Success" {
                                self.view.makeToast("Profile Updated Successfully", duration: 1.0, position: .center)
                               // self.perform(#selector(self.RedirectToProfile), with: nil, afterDelay: 1.1)
                            } else {}
                        }
                    case let .fail(errorMsg):
                        print(errorMsg)
                    }
                }
            }
        }
    }

    @objc func RedirectToProfile() {
        navigationController?.popViewController(animated: true)
    }
}

extension UITextField {
    func datePicker<T>(target: T,
                       doneAction: Selector,
                       cancelAction: Selector,
                       datePickerMode: UIDatePicker.Mode = .date)
    {
        let screenWidth = UIScreen.main.bounds.width

        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()

            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)

            return barButtonItem
        }

        let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: screenWidth,
                                                    height: 216))
        datePicker.datePickerMode = datePickerMode
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        inputView = datePicker

        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: screenWidth,
                                              height: 44))
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
        inputAccessoryView = toolBar
    }
}

// extension UserProfileVC: UIDocumentMenuDelegate,UIDocumentPickerDelegate {
//
//    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        guard let myURL = urls.last else {
//            return
//        }
//        let fullname: String = myURL.lastPathComponent
//        let filePath = myURL  //URL of the PDF
//        let urlString = myURL.absoluteString
//        print(urlString)
//        print("fullname",fullname)
//
//        Doc_Array.append(DocModel(fromDictionary: ["fileName":urlString,"name":fullname]))
//        print(Doc_Array)
//
//        DispatchQueue.main.async {
//            self.view.layoutIfNeeded()
//            self.TBlDocList.isHidden = false
//            self.view.layoutIfNeeded()
//            self.TBlDocList.delegate = self
//            self.TBlDocList.dataSource = self
//            self.TBlDocList.reloadData()
//            self.view.layoutIfNeeded()
//            self.heightTBLConstraint.constant = self.TBlDocList.contentSize.height
//            self.view.layoutIfNeeded()
//        }
//        print("import result : \(myURL)")
//
//    }
//
//
//    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
//        documentPicker.delegate = self
//        present(documentPicker, animated: true, completion: nil)
//    }
//
//
//    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
//        print("view was cancelled")
//        dismiss(animated: true, completion: nil)
//    }
//
// }

// extension UserProfileVC : UIPickerViewDelegate, UIPickerViewDataSource {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        guard let inputType = currentPickerType else { return 0 }
//        if inputType == .designation {
//            return designation_Array.count
//        } else if inputType == .policeVerification  {
//            return policeVerification_Array.count
//        }
//        else {
//            return 0
//        }
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        guard let inputType = currentPickerType else { return "" }
//        if inputType == .designation   {
//            let element = designation_Array[row].name
//            return element
//        } else if inputType == .policeVerification {
//            let element = policeVerification_Array[row]
//            return element
//        } else {
//
//            return ""
//        }
//    }
// }

////MARK:- UITable View Data Source and Delegates Methods******************************
// extension UserProfileVC : UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return Doc_Array.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    let cell = tableView.dequeueReusableCell(withIdentifier: "LocalDocsTableCell", for: indexPath) as! LocalDocsTableCell
//
//        let obj = self.Doc_Array[indexPath.row]
//        cell.selectionStyle = .none
//        cell.viewCorner.dropShadowWithCornerRadius()
//        cell.lblDocName.text = obj.name ?? ""
//        cell.btnDeleteDoc.tag = indexPath.row
//        cell.btnDeleteDoc.addTarget(self, action: #selector(btnDeleteDocAction(sender:)), for: .touchUpInside)
//
//        return cell
//
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        DispatchQueue.main.async {
//            self.heightTBLConstraint.constant = self.TBlDocList.contentSize.height
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//
//    }
//
//
//    @objc func btnDeleteDocAction(sender: UIButton) {
//
//        DispatchQueue.main.async {
//            self.Doc_Array.remove(at: sender.tag)
//            DispatchQueue.main.async {
//                self.view.layoutIfNeeded()
//                self.heightTBLConstraint.constant = self.TBlDocList.contentSize.height
//                self.TBlDocList.reloadData()
//                self.view.layoutIfNeeded()
//            }
//
//            print(self.Doc_Array.count)
//            print(self.Doc_Array)
//
//        }
//    }
//
// }

// extension String {
//
//    func fromBase64() -> String? {
//        guard let data = Data(base64Encoded: self) else {
//            return nil
//        }
//
//        return String(data: data, encoding: .utf8)
//    }
//
//    func toBase64() -> String {
//        return Data(self.utf8).base64EncodedString()
//    }
// }
