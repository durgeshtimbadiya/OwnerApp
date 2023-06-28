//
//  SelfieVC.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 13/12/21.

import Alamofire
import CoreLocation
import UIKit
import GoogleMaps
import GooglePlaces
import ProgressHUD

class SelfieVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PrLocation {
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var btnPlus: UIButton!
    @IBOutlet var btnClickToUpload: UIButton!
    @IBOutlet var TBLSelfieList: UITableView!
    @IBOutlet weak var lblSiteName: UILabel!
    var site_Name = ""
    var selfie_List_Array: NSMutableArray = []

    var company_iD = ""
    var site_iD = ""
    var count = Int()

    let imagepicker = UIImagePickerController()
    var captureImage: UIImage?
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var lblLiveLocationAddres: UILabel!
    var apiTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSiteName.text = "\(site_Name):"
        LocationManagerSingleton.shared.StartStopUpdatingLocation(start: true)
        LocationManagerSingleton.shared.delegate = self

        btnProfile.layer.cornerRadius = btnProfile.layer.bounds.height / 2
        btnProfile.clipsToBounds = true
        btnClickToUpload.dropShadowWithCornerRadius()
        
//        DispatchQueue.main.async {
//            self.getAddressFromLatLon(pdblLatitude: appDelegate.Lat, pdblLongitude: appDelegate.Long)
//        }
        self.lblLiveLocationAddres.text = appDelegate.Location
        if USERDEFAULTS.integer(forKey: "WaitForNextSelfie") > 0 {
            if self.apiTimer.isValid {
                self.apiTimer.invalidate()
            }
            self.apiTimer = Timer(timeInterval: 1, target: self, selector: #selector(self.selfieTimer), userInfo: nil, repeats: true)
            RunLoop.main.add(self.apiTimer, forMode: .default)
            self.apiTimer.fire()
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
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
        LocationManagerSingleton.shared.StartStopUpdatingLocation(start: true)
        LocationManagerSingleton.shared.delegate = self

        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.tintColor = UIColor(hex: "1792A1")

        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        TBLSelfieList.addSubview(refreshControl)

        if appDelegate.userLoginAccessDetails?.id != nil {
            GetSelfieListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_iD)
        }
    }

    @objc func refresh(_: AnyObject) {
        DispatchQueue.main.async {
            self.getAddressFromLatLon(pdblLatitude: appDelegate.Lat, pdblLongitude: appDelegate.Long)
        }
        if appDelegate.userLoginAccessDetails?.id != nil {
            GetSelfieListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_iD)
        }
    }

    func GetLocation(currentLocation: CLLocationCoordinate2D) {
        let lat = currentLocation.latitude
        let long = currentLocation.longitude
        print("\(lat)")
        print("\(long)")
    }
    
    func getAddressFromLatLon(pdblLatitude: String, pdblLongitude: String) {
        let geocoder = GMSGeocoder()
        let lat: Double = Double("\(pdblLatitude)")!
                //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
                //72.833770
        let loc: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:lat, longitude:lon)
        
        geocoder.reverseGeocodeCoordinate(loc) { response, _ in
            guard
                let address = response?.firstResult(),
                let lines = address.lines
            else {
                return
            }

            self.lblLiveLocationAddres.text = lines.first ?? ""
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @IBAction func btnBackAction(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnReloadAction(_: Any) {
        if appDelegate.userLoginAccessDetails?.id != nil {
            GetSelfieListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_iD)
        }
    }

    // MARK: -  Get Selfie List Api Functionality-------------------------------

    func GetSelfieListApi(user_id: String, site_id: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": user_id, "site_id": site_id] as [String: Any]

            Webservice.Authentication.SelfieListApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {
                            self.selfie_List_Array.removeAllObjects()

                            if let dictionary = body["labor_data"] as? [[String: Any]] {
                                self.refreshControl.endRefreshing()

                                self.TBLSelfieList.isHidden = false

                                for Dict in dictionary {
                                    let obj = SelfieListModel(fromDictionary: Dict as [String: AnyObject])
                                    self.selfie_List_Array.add(obj)
                                }

                                DispatchQueue.main.async {
                                    self.TBLSelfieList.delegate = self
                                    self.TBLSelfieList.dataSource = self
                                    self.TBLSelfieList.reloadData()
                                }
                            }

                        } else {
                            self.TBLSelfieList.isHidden = true
                        }
                    }
                case let .fail(errorMsg):
                    self.TBLSelfieList.isHidden = true
                    print(errorMsg)
                }
            }
        }
    }

    // MARK: - Camera and Photo Library Image Selection ------------------------------------

    func cameraSwitch() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerController.SourceType.camera
        present(myPickerController, animated: true, completion: nil)
    }

    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true) {
            guard let selectedImage = info[.originalImage] as? UIImage else {
                print("Image not found!")
                return
            }
            self.captureImage = selectedImage
            self.btnProfile.setImage(self.captureImage, for: .normal)
            self.btnProfile.contentMode = .scaleAspectFill
        }
    }

    // MARK: - Selfie Upload Action-------------------

    @IBAction func btnSelfieUploadAction(_: Any) {
        if captureImage == nil {
            view.makeToast("Please choose image", duration: 0.8, position: .center)
            return
        } else {
            if appDelegate.userLoginAccessDetails?.id != nil {
                self.btnClickToUpload.isEnabled = false
                UploadSelfieApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_iD, longitude: appDelegate.Long, latitude: appDelegate.Lat, address: appDelegate.Location, facility_id: company_iD)
            }
        }
    }

    @IBAction func btnPlusAction(_: Any) {
        cameraSwitch()
    }

    // MARK: - Btn Profile Action -----------------

    @IBAction func btnProfileAction(_: Any) {
        cameraSwitch()
    }
    
    @objc func selfieTimer() {
        let secs = USERDEFAULTS.integer(forKey: "WaitForNextSelfie")
        if secs > 0 {
            self.btnClickToUpload.isEnabled = false
            self.btnClickToUpload.setTitle("WAIT FOR \(secs) SECONDS", for: .normal)
        } else {
            self.btnClickToUpload.isEnabled = true
            self.btnClickToUpload.setTitle("CLICK AND UPLOAD SELFIE", for: .normal)
            apiTimer.invalidate()
        }
    }

    // MARK: - Upload Selfie APi *********************************************

    func UploadSelfieApi(user_id: String, site_id: String, longitude: String, latitude: String, address: String, facility_id: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            ProgressHUD.animationType = .circleStrokeSpin
            ProgressHUD.colorBackground = .white
            ProgressHUD.colorAnimation = AppColor.Color_SkyBlueTitle
            ProgressHUD.show("Uploading...")

            let params = ["user_id": user_id,
                          "site_id": site_id,
                          "longitude": longitude,
                          "latitude": latitude,
                          "address": address,
                          "facility_id": facility_id] as [String: Any]
            print(params)

            let headers: HTTPHeaders = [
                "token": "c7d3965d49d4a59b0da80e90646aee77548458b3377ba3c0fb43d5ff91d54ea28833080e3de6ebd4fde36e2fb7175cddaf5d8d018ac1467c3d15db21c11b6909",
                "Content-Type": "application/json",
            ]

            let URL = try! URLRequest(url: "https://dev.sitepay.co.in/api/Employee/selfie", method: .post, headers: headers)

            Alamofire.upload(multipartFormData: { multipartFormdata in

                if let resizedImage = self.captureImage!.resized(withPercentage: 0.2) {
                    let imageDataa = resizedImage.jpegData(compressionQuality: 0.75)
                    let data = imageDataa!.base64EncodedData()
                    multipartFormdata.append(data, withName: "selfie")
                }

                for (key, value) in params {
                    multipartFormdata.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }

            }, with: URL) { result in

                switch result {
                case let .success(upload, _, _):

                    upload.uploadProgress(closure: { progress in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })

                    upload.responseJSON { response in
                        print(response)
                        if response.result.value != nil {
                            if let dict: NSDictionary = response.result.value as? NSDictionary {
                                print(dict)
                                if dict.value(forKey: "message") as? String == "Success" {
                                    print("Selfie Uploaded Successfully")
                                    self.view.makeToast("Selfie Uploaded Successfully", duration: 1.0, position: .center)
                                    USERDEFAULTS.set(60, forKey: "WaitForNextSelfie")
                                    appDelegate.startSelfiCountDown()

                                    if self.apiTimer.isValid {
                                        self.apiTimer.invalidate()
                                    }
                                    self.apiTimer = Timer(timeInterval: 1, target: self, selector: #selector(self.selfieTimer), userInfo: nil, repeats: true)
                                    RunLoop.main.add(self.apiTimer, forMode: .default)
                                    self.apiTimer.fire()
                                    self.captureImage = nil
                                    self.btnProfile.setImage(UIImage(named: "user"), for: .normal)

                                    if appDelegate.userLoginAccessDetails?.id != nil {
                                        self.GetSelfieListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: self.site_iD)
                                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelfieLogVC") as? SelfieLogVC {
                                            vc.company_iD = self.company_iD
                                            vc.site_iD = self.site_iD
                                            vc.site_Name = self.site_Name
//                                            self.navigationController?.pushViewController(vc, animated: true)
                                            Functions.pushToViewController(self, toVC: vc)
                                        }
                                    }
                                    self.btnClickToUpload.isEnabled = true
                                } else {
                                    self.view.makeToast(dict.value(forKey: "message") as? String, duration: 1.0, position: .center)
                                    print("Selfie Not Uploaded")
                                    self.btnClickToUpload.isEnabled = true
                                }
                            } else {
                                self.btnClickToUpload.isEnabled = true
                            }
                        } else {
                            print("Selfie Not Uploaded")
                            self.btnClickToUpload.isEnabled = true
                        }
                    }

                case let .failure(encodingError):
                    print(encodingError)
                }
                ProgressHUD.dismiss()
            }
        } else {
            self.btnClickToUpload.isEnabled = true
        }
    }
}

// MARK: - UITable View Data Source and Delegates Methods******************************

extension SelfieVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return selfie_List_Array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelfieTableCell", for: indexPath) as! SelfieTableCell

        let obj = selfie_List_Array[indexPath.row] as! SelfieListModel

        cell.selectionStyle = .none
        cell.viewCount.layer.cornerRadius = 10
        cell.viewBig.layer.cornerRadius = 10
        count = indexPath.row + 1

        cell.lblCount.text = "\(count)"

        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            cell.imgVIew.round(corners: [.topLeft, .topRight], cornerRadius: 10)
            self.view.layoutIfNeeded()
        }

        if obj.selfie != "" {
            cell.imgVIew.sd_setImage(with: URL(string: obj.selfie ?? ""), placeholderImage: UIImage(named: "nopreview"),
                                     options: .refreshCached,
                                     completed: nil)
        }

        cell.lblDate.text = obj.createdDate ?? ""
        cell.lblLocation.text = obj.address ?? ""

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

