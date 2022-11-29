//
//  AllFacilityEmployeeVC.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 25/11/21.
//

import AVFoundation
import CoreLocation
import UIKit

class AllFacilityEmployeeVC: UIViewController, QRCodeReaderViewControllerDelegate, PrLocation {
    lazy var reader: QRCodeReader = .init()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton = true
            $0.preferredStatusBarStyle = .lightContent
            $0.showOverlayView = true
            $0.rectOfInterest = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)

            $0.reader.stopScanningWhenCodeIsFound = false
        }

        return QRCodeReaderViewController(builder: builder)
    }()

    @IBOutlet var lblTitle: UILabel!
    var k_Title = ""
    var company_ID = ""
    var site_ID = ""
    var qr_value = ""
    var Punch_Type = ""
    var entry_Type = ""
    var message_String = ""
    var siteName = ""

    @IBOutlet var viewScanner: UIView!
    @IBOutlet var viewSlfie: UIView!
    @IBOutlet var viewActivity: UIView!
    @IBOutlet var viewSOS: UIView!
    @IBOutlet weak var lblSiteName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSiteName.text = "\(siteName):"
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.viewScanner.dropShadowWithCornerRadius()
            self.viewSlfie.dropShadowWithCornerRadius()
            self.viewActivity.dropShadowWithCornerRadius()
            self.viewSOS.dropShadowWithCornerRadius()
            self.view.layoutIfNeeded()
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
    }

    func GetLocation(currentLocation: CLLocationCoordinate2D) {
        let lat = currentLocation.latitude
        let long = currentLocation.longitude
        print(lat)
        print(long)
    }

    // MARK: - Actions

    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController

            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { _ in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))

                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }

            present(alert, animated: true, completion: nil)

            return false
        }
    }

    @IBAction func btnBackAction(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - All Facility Button Action--------------------

    @IBAction func btnScannerAction(_: Any) {
        guard checkScanPermissions() else { return }

        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate = self

        readerVC.completionBlock = { (result: QRCodeReaderResult?) in

            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")

                let JSON = result.value.convertToDictionary()
                if let dic = JSON as NSDictionary? {
                    print("Type ---->", dic.value(forKey: "type"))
                } else {
                    self.view.makeToast("Wrong QR Code Scan! Please Try Again", duration: 0.8, position: .center)
                }
            }
        }

//        navigationController?.pushViewController(readerVC, animated: true)
        Functions.pushToViewController(self, toVC: readerVC)
    }

    // MARK: - QRCodeReader Delegate Methods

    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()

        qr_value = result.value

        let JSON = result.value.convertToDictionary()
        if let dic = JSON as NSDictionary? {
            Punch_Type = dic.value(forKey: "type") as? String ?? ""
            entry_Type = dic.value(forKey: "entry_type") as? String ?? ""
            dismiss(animated: true) { [weak self] in
                self?.AttendanceApi(qr_data: self?.qr_value ?? "", user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: self?.site_ID ?? "", latitude: appDelegate.Lat, longitude: appDelegate.Long, location: appDelegate.Location, facility_id: self?.company_ID ?? "", type: self?.Punch_Type ?? "", entry_type: self?.entry_Type ?? "")
                
            }
        } else {
            view.makeToast("Wrong QR Code Scan! Please Try Again", duration: 0.8, position: .center)
        }
    }

    func reader(_: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capture to: \(newCaptureDevice.device.localizedName)")
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSelfieAction(_: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelfieVC") as? SelfieVC {
            vc.company_iD = company_ID
            vc.site_iD = site_ID
            vc.site_Name = siteName
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }

    @IBAction func btnActivityLogAction(_: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelfActivityLogVC") as? SelfActivityLogVC {
            vc.company_iDs = company_ID
            vc.site_iDs = site_ID
            vc.site_Name = siteName
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }

    @IBAction func btnSOSAction(_: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SOSVC") as? SOSVC {
            vc.company_iD = company_ID
            vc.site_iD = site_ID
            vc.site_Name = siteName
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }

    // MARK: - Attendance Api Functionality-------------------------------

    func AttendanceApi(qr_data: String, user_id: String, site_id: String, latitude: String, longitude: String, location: String, facility_id: String, type: String, entry_type: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["qr_data": qr_data,
                          "user_id": user_id,
                          "site_id": site_id,
                          "latitude": latitude,
                          "longitude": longitude,
                          "facility_id": facility_id,
                          "location": location] as [String: Any]

            Webservice.Authentication.AttendanceApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {
                            if let punch_in_id = body["punch_in_id"] as? String {
                                print("Punch In ID----->", punch_in_id)
                            }
                            print("Successfully Called Api")
                            if self.Punch_Type == "1" {
                                if self.entry_Type == "1" {
                                    self.message_String = "Punch in Successfully"
                                } else if self.entry_Type == "2" {
                                    self.message_String = "Punch out Successfully"
                                } else {
                                    self.message_String = "Pending"
                                }
                            } else if self.Punch_Type == "0" {
                                self.message_String = "Petrolling Submitted Successfully"
                            }
                            let alert = UIAlertController(
                                title: nil,
                                message: self.message_String,
                                preferredStyle: .alert
                            )
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                                self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alertController = UIAlertController(title: nil, message: body["message"] as? String ?? "", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default) {
                                _ in
                                self.navigationController?.popViewController(animated: true)
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
//                            appDelegate.ShowAlertController(message: body["message"] as? String ?? "", viewController: self)
                        }
                    }
                case let .fail(errorMsg):
                    appDelegate.ShowAlertController(message: errorMsg, viewController: self)
                    print(errorMsg)
                }
            }
        }
    }
}
