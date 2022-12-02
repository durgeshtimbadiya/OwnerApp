//
//  SiteListVC.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 20/11/21.

import Alamofire
import CoreLocation
import UIKit

class SiteListVC: UIViewController, PrLocation {
    var siteList_Array: NSMutableArray = []
    @IBOutlet var TBLSiteList: UITableView!
    @IBOutlet var viewNoDataFound: UIView!
    var refreshControl = UIRefreshControl()
    private var apiTimer = Timer()
    private var isSetSiteList = 0

    override func viewDidLoad() {
        super.viewDidLoad()
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
        TBLSiteList.addSubview(refreshControl)

        if appDelegate.userLoginAccessDetails?.id != nil {
            if apiTimer.isValid {
                apiTimer.invalidate()
            }
            apiTimer = Timer(timeInterval: 30, target: self, selector: #selector(self.updateAPIData), userInfo: nil, repeats: true)
            RunLoop.main.add(self.apiTimer, forMode: .default)
            apiTimer.fire()
//            GetSiteListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", mobile: appDelegate.userLoginAccessDetails?.mobile ?? "")

            if USERDEFAULTS.value(forKey: "device_Token") as? String != "" {
                NotificationUpdatefuncApi(deviceID: USERDEFAULTS.value(forKey: "device_Token") as? String ?? "", mobile: appDelegate.userLoginAccessDetails?.mobile ?? "", type: "2")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        apiTimer.invalidate()
    }

    @objc func refresh(_: AnyObject) {
        if appDelegate.userLoginAccessDetails?.id != nil {
            GetSiteListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", mobile: appDelegate.userLoginAccessDetails?.mobile ?? "")

            if USERDEFAULTS.value(forKey: "device_Token") as? String != "" {
                NotificationUpdatefuncApi(deviceID: USERDEFAULTS.value(forKey: "device_Token") as? String ?? "", mobile: appDelegate.userLoginAccessDetails?.mobile ?? "", type: "2")
            }
        }
    }
    
    @IBAction func btnReloadFuncAction(_ sender: Any) {
        if appDelegate.userLoginAccessDetails?.id != nil {
            GetSiteListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", mobile: appDelegate.userLoginAccessDetails?.mobile ?? "")

            if USERDEFAULTS.value(forKey: "device_Token") as? String != "" {
                NotificationUpdatefuncApi(deviceID: USERDEFAULTS.value(forKey: "device_Token") as? String ?? "", mobile: appDelegate.userLoginAccessDetails?.mobile ?? "", type: "2")
            }
        }
    }
    

    func GetLocation(currentLocation: CLLocationCoordinate2D) {
//        let lat = currentLocation.latitude
//        let long = currentLocation.longitude
    }

    @IBAction func btnLogOutAction(_: Any) {
        let alertcontroller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
       
        let myProfile = UIAlertAction(title: "My Profile", style: .default) { _ in
            DispatchQueue.main.async {
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC {
//                    self.navigationController?.pushViewController(vc, animated: true)
                    Functions.pushToViewController(self, toVC: vc)
                }
            }
        }
       
        let mute = UIAlertAction(title: "Mute Notification", style: .default) { _ in
            USERDEFAULTS.set(true, forKey: "IsUnMuteNotification")
            self.view.makeToast("Notification is mute", duration: 0.8, position: .center)
        }
        
        let Unmute = UIAlertAction(title: "Un-Mute Notification", style: .default) { _ in
            USERDEFAULTS.set(false, forKey: "IsUnMuteNotification")
            self.view.makeToast("Notification is Un-mute", duration: 0.8, position: .center)
        }
       
        let logOut = UIAlertAction(title: "Logout", style: .default) { _ in
            self.LogOutAlert()
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertcontroller.addAction(myProfile)
        alertcontroller.addAction(mute)
        alertcontroller.addAction(Unmute)
        alertcontroller.addAction(logOut)
        alertcontroller.addAction(cancel)
        present(alertcontroller, animated: true)
    }

    func LogOutAlert() {
        let alertcontroller = UIAlertController(title: "Confirmation", message: "Do you want to logout from this application", preferredStyle: .alert)
        let yes = UIAlertAction(title: "YES", style: .default) { _ in
            appDelegate.logoutApp(appDelegate.userLoginAccessDetails?.id ?? "")
//            appDelegate.unAuthenticateUser()
//            self.resetDefaults()
//            USERDEFAULTS.set("NO", forKey: "loggedin")
//            USERDEFAULTS.set("YES", forKey: "isfirsttime")
        }
        let cancel = UIAlertAction(title: "NO", style: .cancel, handler: nil)

        alertcontroller.addAction(yes)
        alertcontroller.addAction(cancel)
        present(alertcontroller, animated: true)
    }

    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }

    // MARK: -  Get Site List Api Functionality-------------------------------

    func GetSiteListApi(UserID: String, mobile: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": UserID, "mobile": mobile, "user_type": "2"] as [String: Any]

            Webservice.Authentication.SiteList(parameter: params) { [self] result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {
                            self.siteList_Array.removeAllObjects()
                            self.isSetSiteList = 0

                            if let dictionary = body["user_data"] as? [[String: Any]] {
                                self.TBLSiteList.isHidden = false
                                self.viewNoDataFound.isHidden = true

                                self.refreshControl.endRefreshing()
                                for Dict in dictionary {
                                    let obj = SiteListModel(fromDictionary: Dict as [String: AnyObject])
                                    self.siteList_Array.add(obj)
                                }

                                DispatchQueue.main.async {
                                    self.TBLSiteList.delegate = self
                                    self.TBLSiteList.dataSource = self
                                    self.TBLSiteList.reloadData()
                                }
                            }

                        } else {
                            self.TBLSiteList.isHidden = true
                            self.viewNoDataFound.isHidden = false
                        }
                    }
                case let .fail(errorMsg):
                    self.TBLSiteList.isHidden = true
                    self.viewNoDataFound.isHidden = false
                    self.isSetSiteList = self.isSetSiteList + 1
                    if self.siteList_Array.count > self.isSetSiteList {
                        appDelegate.userLoginAccessDetails?.id = (self.siteList_Array[self.isSetSiteList] as? SiteListModel)?.employeeId
                        self.updateAPIData()
                    } else {
                        self.isSetSiteList = 0
                        if self.siteList_Array.count > self.isSetSiteList {
                            appDelegate.userLoginAccessDetails?.id = (self.siteList_Array[self.isSetSiteList] as? SiteListModel)?.employeeId
                            self.updateAPIData()
                        }
                    }
                }
                
            }
        }
    }
    
    @objc func updateAPIData() {
        GetSiteListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", mobile: appDelegate.userLoginAccessDetails?.mobile ?? "")
    }

    // MARK: -  Notification Update Api Functionality-------------------------------

    func NotificationUpdatefuncApi(deviceID: String, mobile: String, type: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["device_id": deviceID, "mobile": mobile, "type": type, "device_type": "1"] as [String: Any]
            Webservice.Authentication.NotificationUpdateApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {
                            print("Notification FCM Updated Succesfully*****************")
                        }
                    }
                case let .fail(errorMsg):
                    print(errorMsg)
                }
            }
        }
    }
}

// MARK: - UITable View Data Source and Delegates Methods******************************

extension SiteListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return siteList_Array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SiteListTableCell", for: indexPath) as! SiteListTableCell

        let obj = siteList_Array[indexPath.row] as! SiteListModel

        cell.selectionStyle = .none
        cell.imgView.layer.cornerRadius = 10
        cell.btnViewSite.layer.cornerRadius = 10
        cell.viewCorner.dropShadowWithCornerRadius()

        if obj.photo != "" {
            cell.imgView.sd_setImage(with: URL(string: obj.photo ?? ""), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached, completed: nil)
        }

        cell.imgView.contentMode = .scaleAspectFill
        cell.lblSiteName.text = obj.name ?? ""
        cell.lblLocation.text = obj.address ?? ""
        cell.viewBlockedStatus.isHidden = true//23,146,161
        cell.btnViewSite.backgroundColor = UIColor(displayP3Red: 23.0 / 255.0, green: 146.0 / 255.0, blue: 161.0 / 255.0, alpha: 1.0)
        cell.btnViewSite.isEnabled = true
        cell.btnViewSite.setTitle("View Site", for: .normal)
        if obj.siteBlocked == "1" || obj.ownerBlocked == "1" || obj.employeeBlocked == "1" || obj.userBlocked == "1" {
            cell.btnViewSite.isEnabled = false
            cell.btnViewSite.setTitle("Blocked", for: .normal)
            cell.btnViewSite.backgroundColor = .gray
//            cell.viewBlockedStatus.isHidden = false
//            cell.lblBlockedStatus.text = "Site Blocked"
        }/* else if obj.ownerBlocked == "1" {
//            cell.btnViewSite.isHidden = true
//            cell.viewBlockedStatus.isHidden = false
//            cell.lblBlockedStatus.text = "Owner Blocked"
            cell.btnViewSite.isEnabled = false
            cell.btnViewSite.setTitle("Blocked", for: .normal)
            cell.btnViewSite.backgroundColor = .gray
        } else if obj.employeeBlocked == "1" {
//            cell.btnViewSite.isHidden = true
//            cell.viewBlockedStatus.isHidden = false
//            cell.lblBlockedStatus.text = "Employee Blocked"
            cell.btnViewSite.isEnabled = false
            cell.btnViewSite.setTitle("Blocked", for: .normal)
            cell.btnViewSite.backgroundColor = .gray
        }*/ else {
            cell.btnViewSite.isHidden = false
            cell.viewBlockedStatus.isHidden = true
        }
        
        cell.viewCornerReport.layer.cornerRadius = cell.viewCornerReport.layer.bounds.height / 2
        if obj.uploadReport != nil {
            cell.lblReportCount.text = "\(obj.uploadReport ?? 0)"
        }
        
        if obj.vehicleApprovalCount != nil {
            cell.viewMainCornerVehicle.isHidden = false
            cell.viewCornerVehicle.layer.cornerRadius = cell.viewCornerVehicle.layer.bounds.height / 2
            let pending = obj.vehicleApprovalCount.pending
            let approval = obj.vehicleApprovalCount.approved
            let total: Int = pending! + approval!
            if total > 0 {
                cell.viewCornerVehicle.backgroundColor = UIColor.cyan
            } else {
                cell.viewCornerVehicle.backgroundColor = UIColor.white
            }
            cell.lblVehicleCount.text = "\(total)"
        } else {
            cell.viewMainCornerVehicle.isHidden = true
        }
        
        if obj.visitorApprovalCount != nil {
            cell.viewMainCornerVisitor.isHidden = false
            cell.viewConrnerVisitor.layer.cornerRadius = cell.viewConrnerVisitor.layer.bounds.height / 2
            let pending = obj.visitorApprovalCount.pending
            let approval = obj.visitorApprovalCount.approved
            let total: Int = pending! + approval!
            if total > 0 {
                cell.viewConrnerVisitor.backgroundColor = UIColor.cyan
            } else {
                cell.viewConrnerVisitor.backgroundColor = UIColor.white
            }
            cell.lblVisitorCount.text = "\(total)"
        } else {
            cell.viewMainCornerVisitor.isHidden = true
            
        }

        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(btnDeleteAction(sender:)), for: .touchUpInside)
        cell.btnViewSite.tag = indexPath.row
        cell.btnViewSite.addTarget(self, action: #selector(btnViewSiteAction(sender:)), for: .touchUpInside)
        
        //MARK:- Vehicle Button Action
        cell.btnVehicle.tag = indexPath.row
        cell.btnVehicle.isEnabled = !(obj.siteBlocked == "1" || obj.ownerBlocked == "1" || obj.employeeBlocked == "1" || obj.userBlocked == "1")
        cell.btnVehicle.addTarget(self, action: #selector(btnVehicleAction(sender:)), for: .touchUpInside)
       
        //MARK:- Visitor Button Action
        cell.btnVisitor.tag = indexPath.row
        cell.btnVisitor.isEnabled = !(obj.siteBlocked == "1" || obj.ownerBlocked == "1" || obj.employeeBlocked == "1" || obj.userBlocked == "1")
        cell.btnVisitor.addTarget(self, action: #selector(btnVisitorAction(sender:)), for: .touchUpInside)
        
        //MARK:- Report Button Action
        cell.btnReport.tag = indexPath.row
        cell.btnReport.isEnabled = !(obj.siteBlocked == "1" || obj.ownerBlocked == "1" || obj.employeeBlocked == "1" || obj.userBlocked == "1")
        cell.btnReport.addTarget(self, action: #selector(btnReportAction(sender:)), for: .touchUpInside)
        
        //MARK:- SOS Button Action
        cell.btnSOS.tag = indexPath.row
        cell.btnSOS.isEnabled = !(obj.siteBlocked == "1" || obj.ownerBlocked == "1" || obj.employeeBlocked == "1" || obj.userBlocked == "1")
        cell.btnSOS.addTarget(self, action: #selector(btnSOSAction(sender:)), for: .touchUpInside)
        
        //MARK:- SOS Button Action
        cell.btnLive.tag = indexPath.row
        cell.btnLive.isEnabled = !(obj.siteBlocked == "1" || obj.ownerBlocked == "1" || obj.employeeBlocked == "1" || obj.userBlocked == "1")
        cell.btnLive.addTarget(self, action: #selector(btnLiveAction(sender:)), for: .touchUpInside)

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    @objc func btnDeleteAction(sender: UIButton) {
        DispatchQueue.main.async {
            let obj = self.siteList_Array[sender.tag] as! SiteListModel

            if ProjectUtilities.checkInternateAvailable(viewController: self) {
                let params = ["site_id": obj.siteId ?? "",
                              "user_id": obj.id ?? ""] as [String: Any]

                Webservice.Authentication.SiteDeleteApi(parameter: params) { result in
                    switch result {
                    case let .success(response):
                        if let body = response.body as? [String: Any] {
                            if body["message"] as? String ?? "" == "Success" {
                                if appDelegate.userLoginAccessDetails?.id != nil {
                                    self.GetSiteListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", mobile: appDelegate.userLoginAccessDetails?.mobile ?? "")
                                }

                            } else {
                                App_AlertView.shared.SimpleMessage(Text: body["message"] as? String ?? "")
                            }
                        }
                    case let .fail(errorMsg):
                        App_AlertView.shared.SimpleMessage(Text: errorMsg)
                        print(errorMsg)
                    }
                }
            }
        }
    }

    @objc func btnViewSiteAction(sender: UIButton) {
        let obj = siteList_Array[sender.tag] as! SiteListModel
        appDelegate.userLoginAccessDetails?.id = obj.employeeId
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as? MenuVC {
            vc.k_siteID = obj.id
            vc.employeeID = obj.employeeId
            vc.site_name = obj.name
            vc.uploadReport = "\(obj.uploadReport ?? 0)"
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }
    
    //MARK:- Vehicle Button Action Functionality---------------------------------
    @objc func btnVehicleAction(sender: UIButton) {
        
        let obj = siteList_Array[sender.tag] as! SiteListModel
        appDelegate.userLoginAccessDetails?.id = obj.employeeId

        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VehicleLogVC") as? VehicleLogVC {
            vc.site_Name = obj.name ?? ""
            vc.site_id = obj.id
            var viewControllers = self.navigationController?.viewControllers
            if let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as? MenuVC {
                vc2.k_siteID = obj.id
                vc2.employeeID = obj.employeeId
                vc2.site_name = obj.name ?? ""
                vc2.uploadReport = "\(obj.uploadReport ?? 0)"
                viewControllers?.append(vc2)
            }
            self.navigationController?.viewControllers = viewControllers ?? [UIViewController]()
//            navigationController?.pushViewController(vc, animated: false)
            Functions.pushToViewController(self, toVC: vc)
        }
    }
    
    //MARK:- Visitor Button Action Functionality---------------------------------
    @objc func btnVisitorAction(sender: UIButton) {
        
        let obj = siteList_Array[sender.tag] as! SiteListModel
        appDelegate.userLoginAccessDetails?.id = obj.employeeId

        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorLogVC") as? VisitorLogVC {
            vc.site_Name = obj.name ?? ""
            vc.site_id = obj.id
            var viewControllers = self.navigationController?.viewControllers
            if let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as? MenuVC {
                vc2.k_siteID = obj.id
                vc2.employeeID = obj.employeeId
                vc2.site_name = obj.name ?? ""
                vc2.uploadReport = "\(obj.uploadReport ?? 0)"
                viewControllers?.append(vc2)
            }
            self.navigationController?.viewControllers = viewControllers ?? [UIViewController]()
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }
    
    
    //MARK:- Report Button Action Functionality---------------------------------
    @objc func btnReportAction(sender: UIButton) {
        let obj = siteList_Array[sender.tag] as! SiteListModel
        appDelegate.userLoginAccessDetails?.id = obj.employeeId

        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReportViewAndUploadVC") as? ReportViewAndUploadVC {
            vc.site_ID = obj.id
            var viewControllers = self.navigationController?.viewControllers
            if let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as? MenuVC {
                vc2.k_siteID = obj.id
                vc2.employeeID = obj.employeeId
                vc2.site_name = obj.name ?? ""
                vc2.uploadReport = "\(obj.uploadReport ?? 0)"
                viewControllers?.append(vc2)
            }
            self.navigationController?.viewControllers = viewControllers ?? [UIViewController]()
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }
    
    //MARK:- Report Button Action Functionality---------------------------------
    @objc func btnSOSAction(sender: UIButton) {
        let obj = siteList_Array[sender.tag] as! SiteListModel
        appDelegate.userLoginAccessDetails?.id = obj.employeeId
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SOSLogVC") as? SOSLogVC {
            vc.site_iD = obj.id
            vc.site_Name = obj.name
            var viewControllers = self.navigationController?.viewControllers
            if let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as? MenuVC {
                vc2.k_siteID = obj.id
                vc2.employeeID = obj.employeeId
                vc2.site_name = obj.name ?? ""
                vc2.uploadReport = "\(obj.uploadReport ?? 0)"
                viewControllers?.append(vc2)
            }
            self.navigationController?.viewControllers = viewControllers ?? [UIViewController]()
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }
    
    //MARK:- Report Button Action Functionality---------------------------------
    @objc func btnLiveAction(sender: UIButton) {
        
        let obj = siteList_Array[sender.tag] as! SiteListModel
        appDelegate.userLoginAccessDetails?.id = obj.employeeId
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LiveStrengthVC") as? LiveStrengthVC {
            vc.site_name = obj.name
            vc.site_ID = obj.id
            var viewControllers = self.navigationController?.viewControllers
            if let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as? MenuVC {
                vc2.k_siteID = obj.id
                vc2.employeeID = obj.employeeId
                vc2.site_name = obj.name ?? ""
                vc2.uploadReport = "\(obj.uploadReport ?? 0)"
                viewControllers?.append(vc2)
            }
            self.navigationController?.viewControllers = viewControllers ?? [UIViewController]()
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }
    
}
