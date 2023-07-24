
import CoreLocation
import UIKit
import SDWebImage

class MenuVC: UIViewController, PrLocation {
    @IBOutlet var viewNotification: UIView!
    @IBOutlet var lblNotificationCount: UILabel!
    @IBOutlet var imgBG: UIImageView!
    @IBOutlet var btnActivityLog: UIButton!

    @IBOutlet var viewVehicleApproval: UIView!
    @IBOutlet var viewVistiorApproval: UIView!
    @IBOutlet weak var viewReportMangement: UIView!
    @IBOutlet weak var viewGatemanagment: UIView!
    @IBOutlet weak var stackViews: UIStackView!
    @IBOutlet weak var viewVehicleApprovalLog: UIView!
    @IBOutlet weak var viewVisitorApprovalLog: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblReportCount: UILabel!
    @IBOutlet weak var lblNoApprovalGiven: UILabel!
    @IBOutlet weak var viewReportCount: UIView!

    var k_siteID = ""
    var company_Id = ""
    var employeeID = ""
    var site_name = ""
    var isVehicleOpen = ""
    var isVisitorOpen = ""
    var uploadReport = "0"
    
    @IBOutlet weak var heightVehicleApprovalLogConstraint: NSLayoutConstraint! // 109
    @IBOutlet weak var heightVisitorApprovalLogConstraint: NSLayoutConstraint! // 109
    @IBOutlet weak var heightGateManagmentConstraint: NSLayoutConstraint! // 109
    private var isVehicalLogHidden = false
    private var isVisitorLogHidden = false

    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "\(site_name)"
        self.lblReportCount.text = uploadReport
        LocationManagerSingleton.shared.StartStopUpdatingLocation(start: true)
        LocationManagerSingleton.shared.delegate = self
        viewNotification.layer.cornerRadius = viewNotification.layer.bounds.height / 2
//        btnActivityLog.dropShadowWithCornerRadius()
        
        viewReportCount.layer.cornerRadius = 15
        viewReportCount.layer.borderWidth = 2
        viewReportCount.layer.borderColor = AppColor.Color_TopHeader.cgColor
        
        USERDEFAULTS.set(false, forKey: "ReportViewed")
        
        self.lblNoApprovalGiven.isHidden = true
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.viewReportMangement.isHidden = true
//            self.btnActivityLog.isHidden = true
            self.viewVehicleApproval.isHidden = true
            self.viewVistiorApproval.isHidden = true
            self.viewGatemanagment.isHidden = true
            self.stackViews.isHidden = true
            self.heightGateManagmentConstraint.constant = 0
            self.heightVehicleApprovalLogConstraint.constant = 0
            self.heightVisitorApprovalLogConstraint.constant = 0
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
        reportMangementFuncApi(userID: appDelegate.userLoginAccessDetails?.id ?? "", siteID: k_siteID, userType: "2")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MenuFuncApi(userID: appDelegate.userLoginAccessDetails?.id ?? "", siteID: k_siteID)
    }
    
    @IBAction func tapOnReload(_ sender: UIButton) {
        reportMangementFuncApi(userID: appDelegate.userLoginAccessDetails?.id ?? "", siteID: k_siteID, userType: "2")
        MenuFuncApi(userID: appDelegate.userLoginAccessDetails?.id ?? "", siteID: k_siteID)
    }

    func GetLocation(currentLocation: CLLocationCoordinate2D) {
        let lat = currentLocation.latitude
        let long = currentLocation.longitude
        print("\(lat)")
        print("\(long)")
    }
    
    //MARK:- Report Managment Log ----------------------
    @IBAction func btnReportMangementAction(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReportViewAndUploadVC") as? ReportViewAndUploadVC {
            vc.site_ID = k_siteID
//            self.navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }
    
    
    // MARK: -  Menu Api Functionality-------------------------------

    func MenuFuncApi(userID: String, siteID: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": userID, "site_id": siteID] as [String: Any]

            Webservice.Authentication.MenuApis(parameter: params) { result in
                self.viewReportMangement.isHidden = false
//                self.btnActivityLog.isHidden = false
                self.viewVehicleApproval.isHidden = true
                self.viewVistiorApproval.isHidden = true
                DispatchQueue.main.async {
                    self.view.layoutIfNeeded()
                    self.viewGatemanagment.isHidden = false
                    self.stackViews.isHidden = true
                    self.heightGateManagmentConstraint.constant = 109
                    self.heightVehicleApprovalLogConstraint.constant = 0
                    self.heightVisitorApprovalLogConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }
                self.isVehicleOpen = "1"
                self.viewVehicleApprovalLog.isHidden = false
                self.isVehicalLogHidden = false
                
                self.isVisitorOpen = "1"
                self.viewVisitorApprovalLog.isHidden = false
                self.isVisitorLogHidden = false
                switch result {
                case let .success(response):

                    
//                    self.isVehicleOpen = "0"
//                    self.viewVehicleApprovalLog.isHidden = true
//                    self.isVehicalLogHidden = true
//
//                    self.viewVisitorApprovalLog.isHidden = true
//                    self.isVisitorOpen = "0"
//                    self.isVisitorLogHidden = true
                    
                    if let body = response.body as? [String: Any] {
                        self.imgBG.image = UIImage(named: "nopreview")
                        if let siteImage = body["site_photo"] as? String {
                            let image = "https://dev.sitepay.co.in/data/\(siteImage)"
                            self.imgBG.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached, completed: nil)
                            self.imgBG.round(corners: [.bottomLeft,.bottomRight], cornerRadius: 20)
                        }
                        if body["message"] as? String == "success" {

                            if let approvalDetails = body["approval_detail"] as? NSDictionary {
                                if let vehicleApproval = approvalDetails.value(forKey: "vehicle_approval") as? Int, vehicleApproval == 1 {
                                        self.viewVehicleApproval.isHidden = false
                                }
                                
                                if let visitor_approval = approvalDetails.value(forKey: "visitor_approval") as? Int, visitor_approval == 1 {
                                        self.viewVistiorApproval.isHidden = false
                                }
                                
                                self.lblNoApprovalGiven.isHidden = !(self.viewVehicleApproval.isHidden && self.viewVistiorApproval.isHidden)
                                
                                if let value1 = approvalDetails.value(forKey: "vehicle_assign") as? Int , let value2 = approvalDetails.value(forKey: "visitor_assign") as? Int {
                                    /*if value1 == 0 && value2 == 0 {
                                        DispatchQueue.main.async {
                                            self.view.layoutIfNeeded()
                                            self.viewGatemanagment.isHidden = true
                                            self.stackViews.isHidden = true
                                            self.heightGateManagmentConstraint.constant = 0
                                            self.heightVehicleApprovalLogConstraint.constant = 0
                                            self.heightVisitorApprovalLogConstraint.constant = 0
                                            self.view.layoutIfNeeded()
                                        }
                                    } else {*/
                                        if value1 == 1 {
                                            self.isVehicleOpen = "1"
                                            self.viewVehicleApprovalLog.isHidden = false
                                            self.isVehicalLogHidden = false
                                        }
                                        
                                        if value2 == 1 {
                                            self.isVisitorOpen = "1"
                                            self.viewVisitorApprovalLog.isHidden = false
                                            self.isVisitorLogHidden = false
                                        }
//                                    }
                                }
                                
                                if let notifyCount = body["notification_count"] as? Int {
                                    self.lblNotificationCount.text = "\(notifyCount)"
                                }
                            }
                        } else {
                                self.lblNoApprovalGiven.isHidden = false
//                                DispatchQueue.main.async {
//                                    self.view.layoutIfNeeded()
//                                    self.viewVehicleApproval.isHidden = true
//                                    self.viewVistiorApproval.isHidden = true
//                                    self.viewGatemanagment.isHidden = true
//                                    self.stackViews.isHidden = true
//                                    self.heightGateManagmentConstraint.constant = 0
//                                    self.heightVehicleApprovalLogConstraint.constant = 0
//                                    self.heightVisitorApprovalLogConstraint.constant = 0
//                                    self.view.layoutIfNeeded()
//                                }
                           
                           // App_AlertView.shared.SimpleMessage(Text: body["message"] as? String ?? "")
                        }
                    }
                case let .fail(errorMsg):
                    self.view.makeToast(errorMsg, duration: 1.0, position: .center)
                    print(errorMsg)
                }
            }
        }
    }
    
    
    // MARK: -  Notification Reset Api Functionality-------------------------------

    func notificationResetFuncApi(userID: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": userID, "site_id": k_siteID] as [String: Any]
            
            Webservice.Authentication.notificationResetApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String == "Success" {
                           
                            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationList") as? NotificationList {
                                vc.site_name = self.site_name
                                vc.site_id = self.k_siteID
//                                self.navigationController?.pushViewController(vc, animated: true)
                                Functions.pushToViewController(self, toVC: vc)
                            }
                        } else {
                            App_AlertView.shared.SimpleMessage(Text: body["message"] as? String ?? "")
                        }
                    }
                case let .fail(errorMsg):
                    self.view.makeToast(errorMsg, duration: 1.0, position: .center)
                    print(errorMsg)
                }
            }
        }
    }
    
    // MARK: -  Report Mangement Count  Api Functionality-------------------------------

    func reportMangementFuncApi(userID: String, siteID: String,userType: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": userID, "site_id": siteID, "user_type": userType] as [String: Any]

            Webservice.Authentication.reportManagmentApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["code"] as? Int ?? 0 == 200 {
                            if let reportCount = body["upload_report"] as? Int {
                                self.lblReportCount.text = "\(reportCount)"
                            }
                        } else {
                            App_AlertView.shared.SimpleMessage(Text: body["message"] as? String ?? "")
                        }
                    }
                case let .fail(errorMsg):
                    self.view.makeToast(errorMsg, duration: 1.0, position: .center)
                    print(errorMsg)
                }
            }
        }
    }


    @IBAction func btnBackAction(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnNotificationAction(_: Any) {
        notificationResetFuncApi(userID: appDelegate.userLoginAccessDetails?.id ?? "")
    }
    
    @IBAction func tapOnMyPackage(_ sender: UIButton) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPackageViewController") as? MyPackageViewController {
            vc.site_ID = k_siteID
            vc.siteName = site_name
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }

    @IBAction func btnActivityLogsAction(_: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllFacilityEmployeeVC") as? AllFacilityEmployeeVC {
            vc.site_ID = k_siteID
            vc.siteName = site_name
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }

    @IBAction func btnVehicleApprovalAction(_: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VehicleLogVC") as? VehicleLogVC {
            vc.site_Name = site_name
            vc.site_id = k_siteID
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }
    
    @IBAction func btnVisitorApprovedAction(_ sender: Any) {
        // Clicked Visitor Approved
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorLogVC") as? VisitorLogVC {
            vc.site_Name = site_name
            vc.site_id = k_siteID
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }
    
    //MARK:- Live Button Action Functionality---------------------
    @IBAction func btnLiveAction(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LiveStrengthVC") as? LiveStrengthVC {
            vc.site_name = site_name
            vc.site_ID = k_siteID
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
        
    }
    
    @IBAction func btnSOSAction(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SOSLogVC") as? SOSLogVC {
            vc.company_iD = company_Id
            vc.site_iD = k_siteID
            vc.site_Name = site_name
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }
    
    @IBAction func btnVehicleApprovalLogAction(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VehiclesLogVC") as? VehiclesLogVC {
            vc.site_Name = site_name
            vc.site_id = k_siteID
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
        
    }
    
    @IBAction func btnVisitorApprovalLogAction(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorsLogVC") as? VisitorsLogVC {
            vc.site_Name = site_name
            vc.site_id = k_siteID
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }
    
    @IBAction func btnGateManegmentAction(_ sender: Any) {
        self.stackViews.isHidden = false
        if !isVehicalLogHidden {
            if isVehicleOpen == "1" {
                isVehicleOpen = "0"
                DispatchQueue.main.async {
                    self.view.layoutIfNeeded()
                    self.viewVehicleApprovalLog.isHidden = false
                    self.heightVehicleApprovalLogConstraint.constant = 109
                    self.view.layoutIfNeeded()
                }
            } else {
                isVehicleOpen = "1"
                DispatchQueue.main.async {
                    self.view.layoutIfNeeded()
                    self.viewVehicleApprovalLog.isHidden = true
                    self.heightVehicleApprovalLogConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }
            }
        }
        
        if !isVisitorLogHidden {
            if isVisitorOpen == "1" {
                isVisitorOpen = "0"
                DispatchQueue.main.async {
                    self.view.layoutIfNeeded()
                    self.viewVisitorApprovalLog.isHidden = false
                    self.heightVisitorApprovalLogConstraint.constant = 109
                    self.view.layoutIfNeeded()
                }
            } else {
                isVisitorOpen = "1"
                DispatchQueue.main.async {
                    self.view.layoutIfNeeded()
                    self.viewVisitorApprovalLog.isHidden = true
                    self.heightVisitorApprovalLogConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    
}
