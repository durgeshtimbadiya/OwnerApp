//
//  NotificationList.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 23/11/21.
//

import CoreLocation
import UIKit

class NotificationList: UIViewController, UITextFieldDelegate, PrLocation {
    @IBOutlet var TBLNotificationList: UITableView!
    @IBOutlet var searchFilterNotificationList: UITableView!
    // ********************************************//

    var notification_List_Array: NSMutableArray = []
    var notification_filter_List_Array: NSMutableArray = []
    // **********************************************//
    @IBOutlet var heightConstraintStartAndEndDate: NSLayoutConstraint!
    @IBOutlet weak var lblSiteName: UILabel!
    var start_Date_Value = ""
    var end_Date_Value = ""
    var isCustomDateActive: Bool = false
    var refreshControl = UIRefreshControl()

    @IBOutlet var viewNoDataFound: UIView!

    @IBOutlet var viewDate: UIView!
    @IBOutlet var txtFieldDateFilter: UITextField!
    @IBOutlet var viewStartDate: UIView!
    @IBOutlet var viewEndDate: UIView!

    @IBOutlet var txtFieldStartDate: UITextField!
    @IBOutlet var txFieldEndDate: UITextField!
    @IBOutlet var btnSearch: UIButton!

    @IBOutlet var vieSearchFilter: UIView!
    @IBOutlet var viewFilterNoDataFound: UIView!

    // Picker
    enum PickerType: String {
        case searchFilterPicker
    }

    var currentPickerType: PickerType?
    var search_Filter_attendance_Array = [String]()
    var searchFilter_Value = ""
    var site_name = ""
    var site_id = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        lblSiteName.text = "\(site_name):"
        search_Filter_attendance_Array = ["Today", "Yesterday", "Last 7 Days", "Last 30 Days", "This Month", "Last Month", "Custom Range"]

        vieSearchFilter.isHidden = true
        TBLNotificationList.isHidden = true
        viewStartDate.isHidden = true
        viewEndDate.isHidden = true
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.heightConstraintStartAndEndDate.constant = 0
            self.view.layoutIfNeeded()
        }
        searchFilterNotificationList.isHidden = true

        txtFieldDateFilter.text = "\(Date.getCurrentDate())"
        start_Date_Value = "\(Date.getCurrentDate())"
        end_Date_Value = "\(Date.getCurrentDate())"
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
        TBLNotificationList.addSubview(refreshControl)

        if appDelegate.userLoginAccessDetails?.id != nil {
            GetNotificationListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", startDate: start_Date_Value, endDate: end_Date_Value)
        }
    }

    @objc func refresh(_: AnyObject) {
        vieSearchFilter.isHidden = true
        if appDelegate.userLoginAccessDetails?.id != nil {
            GetNotificationListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", startDate: start_Date_Value, endDate: end_Date_Value)
        }
    }

    func GetLocation(currentLocation: CLLocationCoordinate2D) {
        let lat = currentLocation.latitude
        let long = currentLocation.longitude
        print("\(lat)")
        print("\(long)")
    }

    @IBAction func btnBackAction(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: -  Notification  List Api Functionality-------------------------------

    func GetNotificationListApi(UserID: String, startDate: String, endDate: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": UserID,
                          "start_date": startDate,
                          "end_date": endDate,
                          "site_id": site_id] as [String: Any]

            Webservice.Authentication.NotificationListApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {
                            self.notification_List_Array.removeAllObjects()

                            if let dictionary = body["Logs"] as? [[String: Any]] {
                                self.TBLNotificationList.isHidden = false
                                self.viewNoDataFound.isHidden = true

                                self.refreshControl.endRefreshing()

                                for Dict in dictionary {
                                    let obj = NotificationModel(fromDictionary: Dict as [String: AnyObject])
                                    self.notification_List_Array.add(obj)
                                }

                                DispatchQueue.main.async {
                                    self.TBLNotificationList.delegate = self
                                    self.TBLNotificationList.dataSource = self
                                    self.TBLNotificationList.reloadData()
                                }
                            }

                        } else {
                            self.TBLNotificationList.isHidden = true
                            self.viewNoDataFound.isHidden = false
                        }
                    }
                case let .fail(errorMsg):
                    self.TBLNotificationList.isHidden = true
                    self.viewNoDataFound.isHidden = false
                    print(errorMsg)
                }
            }
        }
    }

    // MARK: -  Notification Filter List Api Functionality-------------------------------

    func GetNotificationFilterListApi(UserID: String, startDate: String, endDate: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": UserID,
                          "start_date": startDate,
                          "end_date": endDate,
                          "site_id": site_id] as [String: Any]

            Webservice.Authentication.NotificationListApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {
                            self.notification_filter_List_Array.removeAllObjects()

                            if let dictionary = body["Logs"] as? [[String: Any]] {
                                self.searchFilterNotificationList.isHidden = false
                                self.viewFilterNoDataFound.isHidden = true

                                self.refreshControl.endRefreshing()

                                for Dict in dictionary {
                                    let obj = NotificationModel(fromDictionary: Dict as [String: AnyObject])
                                    self.notification_filter_List_Array.add(obj)
                                }

                                DispatchQueue.main.async {
                                    self.searchFilterNotificationList.delegate = self
                                    self.searchFilterNotificationList.dataSource = self
                                    self.searchFilterNotificationList.reloadData()
                                }
                            }

                        } else {
                            self.searchFilterNotificationList.isHidden = true
                            self.viewFilterNoDataFound.isHidden = false
                        }
                    }
                case let .fail(errorMsg):
                    self.searchFilterNotificationList.isHidden = true
                    self.viewFilterNoDataFound.isHidden = false
                    print(errorMsg)
                }
            }
        }
    }

    @IBAction func btnFilterAction(_: Any) {
        vieSearchFilter.isHidden = false
        viewFilterNoDataFound.isHidden = true
        viewDate.layer.cornerRadius = 10
        viewDate.layer.borderWidth = 1
        viewDate.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        btnSearch.dropShadowWithCornerRadius()
    }

    // Search Filter Notification Functionality----------------------------
    @IBAction func btnSearchFilterAction(_: Any) {
        if appDelegate.userLoginAccessDetails?.id != nil {
            if isCustomDateActive == true {
                if txtFieldStartDate.text == "" {
                    view.makeToast("please select start date", duration: 1.0, position: .center)
                } else if txFieldEndDate.text == "" {
                    view.makeToast("please select end date", duration: 1.0, position: .center)
                } else {
                    GetNotificationFilterListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", startDate: start_Date_Value, endDate: end_Date_Value)
                }
            } else {
                GetNotificationFilterListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", startDate: start_Date_Value, endDate: end_Date_Value)
            }
        }
    }

    // MARK: - btn Filter Date Action Functionality---------------------------

    @IBAction func btnFilterDateAction(_: Any) {
        currentPickerType = .searchFilterPicker
        showPicker(type: .searchFilterPicker)
    }

    func showPicker(type _: PickerType) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 280, height: 280)

        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 280, height: 280))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: nil, message: "Choose Date", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            let row = pickerView.selectedRow(inComponent: 0)

            if self.search_Filter_attendance_Array.count > 0 {
                let element = self.search_Filter_attendance_Array[row]
                self.searchFilter_Value = element
                if element == "Today" {
                    self.searchFilterNotificationList.isHidden = true
                    self.isCustomDateActive = false
                    self.txtFieldDateFilter.text = "\(Date.getCurrentDate())"
                    self.start_Date_Value = "\(Date.getCurrentDate())"
                    self.end_Date_Value = "\(Date.getCurrentDate())"
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartDate.isHidden = true
                        self.viewEndDate.isHidden = true
                        self.heightConstraintStartAndEndDate.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "Yesterday" {
                    self.searchFilterNotificationList.isHidden = true
                    self.isCustomDateActive = false
                    print("\(Date.yesterday)")
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartDate.isHidden = true
                        self.viewEndDate.isHidden = true
                        self.heightConstraintStartAndEndDate.constant = 0
                        self.view.layoutIfNeeded()
                    }
                    self.txtFieldDateFilter.text = self.convertDateFormater("\(Date.yesterday)")
                    self.start_Date_Value = self.convertDateFormater("\(Date.yesterday)")
                    self.end_Date_Value = self.convertDateFormater("\(Date.yesterday)")

                } else if element == "Last 7 Days" {
                    self.searchFilterNotificationList.isHidden = true
                    self.isCustomDateActive = false
                    self.getLast7Dates()
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartDate.isHidden = true
                        self.viewEndDate.isHidden = true
                        self.heightConstraintStartAndEndDate.constant = 0
                        self.view.layoutIfNeeded()
                    }

                } else if element == "Last 30 Days" {
                    self.searchFilterNotificationList.isHidden = true
                    self.isCustomDateActive = false
                    self.getLast30Dates()
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartDate.isHidden = true
                        self.viewEndDate.isHidden = true
                        self.heightConstraintStartAndEndDate.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "This Month" {
                    self.searchFilterNotificationList.isHidden = true
                    self.isCustomDateActive = false
                    let firstdate = "\(Date().startOfMonth())"
                    // let lastdate = "\(self.convertDateFormater("\(Date.yesterday)"))"
                    self.txtFieldDateFilter.text = "\(self.convertDateFormater(firstdate)) To \(self.convertDateFormater("\(Date.yesterday)"))"

                    self.start_Date_Value = "\(self.convertDateFormater(firstdate))"
                    self.end_Date_Value = "\(self.convertDateFormater("\(Date.yesterday)"))"

                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartDate.isHidden = true
                        self.viewEndDate.isHidden = true
                        self.heightConstraintStartAndEndDate.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "Last Month" {
                    self.searchFilterNotificationList.isHidden = true
                    self.isCustomDateActive = false
                    let first = "\(Date().getPreviousMonth().startOfMonth())"
                    let last = "\(Date().getPreviousMonth().endOfMonth())"

                    self.txtFieldDateFilter.text = "\(self.convertDateFormater(first)) To \(self.convertDateFormater(last))"

                    self.start_Date_Value = "\(self.convertDateFormater(first))"
                    self.end_Date_Value = "\(self.convertDateFormater(last))"

                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartDate.isHidden = true
                        self.viewEndDate.isHidden = true
                        self.heightConstraintStartAndEndDate.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "Custom Range" {
                    self.searchFilterNotificationList.isHidden = true
                    self.isCustomDateActive = true
                    self.txtFieldDateFilter.text = "Custom Range"
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.heightConstraintStartAndEndDate.constant = 115
                        self.view.layoutIfNeeded()
                    }
                    self.viewStartDate.isHidden = false
                    self.viewStartDate.layer.cornerRadius = 10
                    self.viewStartDate.layer.borderWidth = 1
                    self.viewStartDate.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
                    self.txtFieldStartDate.datePicker(target: self,
                                                      doneAction: #selector(self.startDoneAction),
                                                      cancelAction: #selector(self.startCancelAction),
                                                      datePickerMode: .date)

                    self.viewEndDate.isHidden = false
                    self.viewEndDate.layer.cornerRadius = 10
                    self.viewEndDate.layer.borderWidth = 1
                    self.viewEndDate.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor

                    self.txFieldEndDate.datePicker(target: self,
                                                   doneAction: #selector(self.endDoneAction),
                                                   cancelAction: #selector(self.endCancelAction),
                                                   datePickerMode: .date)

                } else {
                    self.isCustomDateActive = false
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.heightConstraintStartAndEndDate.constant = 0
                        self.view.layoutIfNeeded()
                    }
                }
                print("searchFilter_Value status-->", self.searchFilter_Value)
            } else { return }

        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))
        present(editRadiusAlert, animated: true)
    }

    func getLast7Dates() {
        let cal = Calendar.current
        let date = cal.startOfDay(for: Date())
        var days = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        for i in 1 ... 7 {
            let newdate = cal.date(byAdding: .day, value: -i, to: date)!
            let str = dateFormatter.string(from: newdate)
            days.append(str)
        }
        print(days)
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
        print(days)
        let value = days.last
        txtFieldDateFilter.text = "\(value ?? "") To \(Date.getCurrentDate())"
        start_Date_Value = "\(value ?? "")"
        end_Date_Value = "\(Date.getCurrentDate())"
    }

    @objc
    func startDoneAction() {
        if let datePickerView = txtFieldStartDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: datePickerView.date)
            txtFieldStartDate.text = dateString
            start_Date_Value = dateString

            print(datePickerView.date)
            print(dateString)

            txtFieldStartDate.resignFirstResponder()
        }
    }

    @objc
    func startCancelAction() {
        txtFieldStartDate.resignFirstResponder()
    }

    @objc
    func endDoneAction() {
        if let datePickerView = txFieldEndDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: datePickerView.date)
            txFieldEndDate.text = dateString
            end_Date_Value = dateString
            print(datePickerView.date)
            print(dateString)

            txFieldEndDate.resignFirstResponder()
        }
    }

    @objc
    func endCancelAction() {
        txFieldEndDate.resignFirstResponder()
    }

    func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date!)
    }
}

extension NotificationList: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        guard let inputType = currentPickerType else { return 0 }
        if inputType == .searchFilterPicker {
            return search_Filter_attendance_Array.count
        } else {
            return 0
        }
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        guard let inputType = currentPickerType else { return "" }
        if inputType == .searchFilterPicker {
            let element = search_Filter_attendance_Array[row]
            return element
        } else {
            return ""
        }
    }
}

// MARK: - UITable View Data Source and Delegates Methods******************************

extension NotificationList: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
        if tableView == TBLNotificationList {
            return notification_List_Array.count
        } else {
            return notification_filter_List_Array.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == TBLNotificationList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableCell", for: indexPath) as! NotificationTableCell

            let obj = notification_List_Array[indexPath.row] as! NotificationModel
//            DispatchQueue.main.async {
//                self.view.layoutIfNeeded()
//                cell.viewCorner.round(corners: .allCorners, cornerRadius: 10)
//                cell.viewInnerStatus.round(corners: [.topLeft, .topRight], cornerRadius: 10)
//                self.view.layoutIfNeeded()
//            }
            
            cell.lblDateAndTime.text = obj.createdDate ?? ""
            cell.lblName.text = obj.notification ?? ""
            cell.imgStatusRIght.isHidden = false
           
            if obj.notificationType == "3" {
                cell.lblStatusName.text = "Login By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "userlogin")
            }
            else if obj.notificationType == "5" && obj.type == "0" {
                cell.lblStatusName.text = "Vehicle Entry By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "vehicleentry")
                if obj.addedBy.contains("Unique") {
                    cell.imgStatus.tintColor = UIColor.purple
                } else {
                    cell.imgStatus.tintColor = AppColor.Color_TopHeader
                }
            }
            else if obj.notificationType == "1" && obj.type == "0" {
                cell.lblStatusName.text = "Vehicle Added By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "addvehicle")
                cell.imgStatus.tintColor = UIColor.orange
            }
            else if obj.notificationType == "2" && obj.type == "0" {
                cell.lblStatusName.text = "Vehicle Entry By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "vehicleentry")
                if obj.addedBy.contains("Unique") {
                    cell.imgStatus.tintColor = UIColor.purple
                } else {
                    cell.imgStatus.tintColor = AppColor.Color_TopHeader
                }
            }
            
            else if obj.notificationType == "6" && obj.type == "0" {
                cell.lblStatusName.text = "Vehicle Entry By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "vehicleentry")
                if obj.addedBy.contains("Unique") {
                    cell.imgStatus.tintColor = UIColor.purple
                } else {
                    cell.imgStatus.tintColor = AppColor.Color_TopHeader
                }
            }
            else if obj.notificationType == "7" && obj.type == "0" {
                cell.lblStatusName.text = "Vehicle Exit By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "vehicleentry")
                cell.imgStatus.tintColor = AppColor.Color_TopHeader
            }
            else if obj.notificationType == "8" && obj.type == "0" {
                cell.lblStatusName.text = "Vehicle Rejected By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "vehiclereject")
                cell.imgStatus.tintColor = UIColor.red
            }
            
            if obj.notificationType == "9" {
               
                if obj.type == "1" {
                    cell.lblStatusName.text = "Medical Emergency"
                   cell.imgStatus.image = UIImage(named: "Medical")
                    cell.imgStatusRIght.isHidden = true
                } else if obj.type == "2" {
                    cell.lblStatusName.text = "Fire/Gas Leak Emergency"
                    cell.imgStatus.image = UIImage(named: "fire")
                    cell.imgStatusRIght.isHidden = true
                }
                else if obj.type == "3" {
                    cell.lblStatusName.text = "Lift Emergency"
                   cell.imgStatus.image = UIImage(named: "lift")
                    cell.imgStatusRIght.isHidden = true
                }
                else if obj.type == "4" {
                    cell.lblStatusName.text = "Theft/Others"
                 cell.imgStatus.image = UIImage(named: "theft")
                    cell.imgStatusRIght.isHidden = true
                }
            }
            
            if obj.notificationType == "10" {
             
                    cell.lblStatusName.text = "Approved:"
                    cell.imgStatus.image = UIImage(named: "ic_check")
                    cell.imgStatusRIght.isHidden = true
         
            }
            
            if obj.notificationType == "12" {
                    cell.lblStatusName.text = "Removed:"
                    cell.imgStatus.image = UIImage(named: "reject")
                    cell.imgStatusRIght.isHidden = true
             
            }
            
            if obj.notificationType == "13" {
             
                    cell.lblStatusName.text = "Blocked:"
                    cell.imgStatus.image = UIImage(named: "reject")
                    cell.imgStatusRIght.isHidden = true
              
            }
            
            if obj.notificationType == "14" {
              
                    cell.lblStatusName.text = "Unblocked:"
                    cell.imgStatus.image = UIImage(named: "ic_check")
                    cell.imgStatusRIght.isHidden = true
           
            }
            
            if obj.notificationType == "5" && obj.type == "1" {
                cell.lblStatusName.text = "Visitor Entry By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "ic_person")
                cell.imgStatus.tintColor = AppColor.Color_TopHeader
            }
            else if obj.notificationType == "1" && obj.type == "1" {
                cell.lblStatusName.text = "Visitor Added By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "add-friend")
                cell.imgStatus.tintColor = UIColor.orange
            }
            else if obj.notificationType == "2" && obj.type == "1" {
                cell.lblStatusName.text = "Visitor Entry By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "ic_person")
                cell.imgStatus.tintColor = AppColor.Color_TopHeader
            }
            else if obj.notificationType == "6" && obj.type == "1" {
                cell.lblStatusName.text = "Visitor Entry By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "ic_person")
                cell.imgStatus.tintColor = AppColor.Color_TopHeader
            }
            else if obj.notificationType == "7" && obj.type == "1" {
                cell.lblStatusName.text = "Visitor Exit By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "ic_person")
                cell.imgStatus.tintColor = AppColor.Color_TopHeader
            }
            else if obj.notificationType == "8" && obj.type == "1" {
                cell.lblStatusName.text = "Visitor Reject By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "person_reject_red")
                cell.imgStatus.tintColor = AppColor.Color_TopHeader
            }
           
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableCell", for: indexPath) as! NotificationTableCell

            let obj = notification_filter_List_Array[indexPath.row] as! NotificationModel
            
            cell.lblDateAndTime.text = obj.createdDate ?? ""
            cell.lblName.text = obj.notification ?? ""
            cell.imgStatusRIght.isHidden = false
           
            if obj.notificationType == "3" {
                cell.lblStatusName.text = "Login By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "userlogin")
            }
            else if obj.notificationType == "5" && obj.type == "0" {
                cell.lblStatusName.text = "Vehicle Entry By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "vehicleentry")
                if obj.addedBy.contains("Unique") {
                    cell.imgStatus.tintColor = UIColor.purple
                } else {
                    cell.imgStatus.tintColor = AppColor.Color_TopHeader
                }
            }
            else if obj.notificationType == "1" && obj.type == "0" {
                cell.lblStatusName.text = "Vehicle Added By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "addvehicle")
                cell.imgStatus.tintColor = UIColor.orange
            }
            else if obj.notificationType == "2" && obj.type == "0" {
                cell.lblStatusName.text = "Vehicle Entry By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "vehicleentry")
                if obj.addedBy.contains("Unique") {
                    cell.imgStatus.tintColor = UIColor.purple
                } else {
                    cell.imgStatus.tintColor = AppColor.Color_TopHeader
                }
            }
            
            else if obj.notificationType == "6" && obj.type == "0" {
                cell.lblStatusName.text = "Vehicle Entry By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "vehicleentry")
                if obj.addedBy.contains("Unique") {
                    cell.imgStatus.tintColor = UIColor.purple
                } else {
                    cell.imgStatus.tintColor = AppColor.Color_TopHeader
                }
            }
            else if obj.notificationType == "7" && obj.type == "0" {
                cell.lblStatusName.text = "Vehicle Exit By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "vehicleentry")
                cell.imgStatus.tintColor = AppColor.Color_TopHeader
            }
            else if obj.notificationType == "8" && obj.type == "0" {
                cell.lblStatusName.text = "Vehicle Rejected By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "vehiclereject")
                cell.imgStatus.tintColor = UIColor.red
            }
            
            if obj.notificationType == "9" {
                if obj.type == "1" {
                    cell.lblStatusName.text = "Medical Emergency"
                    cell.imgStatus.image = UIImage(named: "Medical")
                    cell.imgStatusRIght.isHidden = true
                } else if obj.type == "2" {
                    cell.lblStatusName.text = "Fire/Gas Leak Emergency"
                    cell.imgStatus.image = UIImage(named: "fire")
                    cell.imgStatusRIght.isHidden = true
                }
                else if obj.type == "3" {
                    cell.lblStatusName.text = "Lift Emergency"
                    cell.imgStatus.image = UIImage(named: "lift")
                    cell.imgStatusRIght.isHidden = true
                }
                else if obj.type == "4" {
                    cell.lblStatusName.text = "Theft/Others"
                    cell.imgStatus.image = UIImage(named: "theft")
                    cell.imgStatusRIght.isHidden = true
                }
            }
            
            if obj.notificationType == "10" {
                cell.lblStatusName.text = "Approved:"
                cell.imgStatus.image = UIImage(named: "ic_check")
                cell.imgStatusRIght.isHidden = true
            }
            
            if obj.notificationType == "12" {
                cell.lblStatusName.text = "Removed:"
                cell.imgStatus.image = UIImage(named: "reject")
                cell.imgStatusRIght.isHidden = true
            }
            
            if obj.notificationType == "13" {
                cell.lblStatusName.text = "Blocked:"
                cell.imgStatus.image = UIImage(named: "reject")
                cell.imgStatusRIght.isHidden = true
            }
            
            if obj.notificationType == "14" {
                cell.lblStatusName.text = "Unblocked:"
                cell.imgStatus.image = UIImage(named: "ic_check")
                cell.imgStatusRIght.isHidden = true
            }
            
            if obj.notificationType == "5" && obj.type == "1" {
                cell.lblStatusName.text = "Visitor Entry By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "ic_person")
                cell.imgStatus.tintColor = AppColor.Color_TopHeader
            }
            else if obj.notificationType == "1" && obj.type == "1" {
                cell.lblStatusName.text = "Visitor Added By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "add-friend")
                cell.imgStatus.tintColor = UIColor.orange
            }
            else if obj.notificationType == "2" && obj.type == "1" {
                cell.lblStatusName.text = "Visitor Entry By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "ic_person")
                cell.imgStatus.tintColor = AppColor.Color_TopHeader
            }
            else if obj.notificationType == "6" && obj.type == "1" {
                cell.lblStatusName.text = "Visitor Entry By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "ic_person")
                cell.imgStatus.tintColor = AppColor.Color_TopHeader
            }
            else if obj.notificationType == "7" && obj.type == "1" {
                cell.lblStatusName.text = "Visitor Exit By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "ic_person")
                cell.imgStatus.tintColor = AppColor.Color_TopHeader
            }
            else if obj.notificationType == "8" && obj.type == "1" {
                cell.lblStatusName.text = "Visitor Reject By \(obj.addedBy ?? "")"
                cell.imgStatus.image = UIImage(named: "person_reject_red")
                cell.imgStatus.tintColor = AppColor.Color_TopHeader
            }

            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var obj: NotificationModel?
        if tableView == TBLNotificationList {
            obj = notification_List_Array[indexPath.row] as? NotificationModel
        } else {
            obj = notification_filter_List_Array[indexPath.row] as? NotificationModel
        }
        if let createdDate = obj?.createdDate, createdDate.components(separatedBy: " ").count > 0 {
            let startEndDate = createdDate.components(separatedBy: " ")[0]
            switch obj!.notificationType {
            case "1":
                // Approval
                if obj!.type == "0", let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ApprovalVehicleLogVC") as? ApprovalVehicleLogVC {
                    // Vehicles
                    vc.start_Date = startEndDate
                    vc.end_Date = startEndDate
                    vc.statuss = "0"
                    vc.site_Name = site_name
                    vc.site_id = site_id
//                    navigationController?.pushViewController(vc, animated: true)
                    Functions.pushToViewController(self, toVC: vc)
                } else if obj!.type == "1", let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorApprovalLogVC") as? VisitorApprovalLogVC {
                    // Vistor
                    vc.start_Date = startEndDate
                    vc.end_Date = startEndDate
                    vc.statuss = "0"
                    vc.site_Name = site_name
                    vc.site_id = site_id
//                    navigationController?.pushViewController(vc, animated: true)
                    Functions.pushToViewController(self, toVC: vc)
                }
                return
            case "2", "5", "6":
                // Entered
                if obj!.type == "0", let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EntryVehicleListVC") as? EntryVehicleListVC {
                    // Vehicles
                    vc.start_Date = startEndDate
                    vc.end_Date = startEndDate
                    vc.statuss = "3"
                    vc.site_Name = site_name
                    vc.site_id = site_id
//                    navigationController?.pushViewController(vc, animated: true)
                    Functions.pushToViewController(self, toVC: vc)
                } else if obj!.type == "1", let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorEnteredLogVC") as? VisitorEnteredLogVC {
                    // Vistor
                    vc.start_Date = startEndDate
                    vc.end_Date = startEndDate
                    vc.statuss = "3"
                    vc.site_Name = site_name
                    vc.site_id = site_id
//                    navigationController?.pushViewController(vc, animated: true)
                    Functions.pushToViewController(self, toVC: vc)
                }
                return
            case "7":
                // Status
                if obj!.type == "0", let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VehicleStatusVC") as? VehicleStatusVC {
                    // Vehicles
                    vc.start_Date = startEndDate
                    vc.end_Date = startEndDate
                    vc.statuss = ""
                    vc.site_Name = site_name
                    vc.site_id = site_id
//                    navigationController?.pushViewController(vc, animated: true)
                    Functions.pushToViewController(self, toVC: vc)
                } else if obj!.type == "1", let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorVehicleStatusLogVC") as? VisitorVehicleStatusLogVC {
                    // Vistor
                    vc.start_Date = startEndDate
                    vc.end_Date = startEndDate
                    vc.statuss = ""
                    vc.site_Name = site_name
                    vc.site_id = site_id
//                    navigationController?.pushViewController(vc, animated: true)
                    Functions.pushToViewController(self, toVC: vc)
                }
                return
            case "8":
                // Rejected
                if obj!.type == "0", let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RejectVehicleListVC") as? RejectVehicleListVC {
                    // Vehicles
                    vc.start_Date = startEndDate
                    vc.end_Date = startEndDate
                    vc.statuss = "2"
                    vc.site_Name = site_name
                    vc.site_id = site_id
//                    navigationController?.pushViewController(vc, animated: true)
                    Functions.pushToViewController(self, toVC: vc)
                } else if obj!.type == "1", let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorRejectedLogVC") as? VisitorRejectedLogVC {
                    // Vistor
                    vc.start_Date = startEndDate
                    vc.end_Date = startEndDate
                    vc.statuss = "2"
                    vc.site_Name = site_name
                    vc.site_id = site_id
//                    navigationController?.pushViewController(vc, animated: true)
                    Functions.pushToViewController(self, toVC: vc)
                }
                return
            case .none:
                break
            case .some(_):
                break
            }
        }
//        if obj!.notificationType == "9", let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SOSVC") as? SOSVC {
//            //SOS
//            vc.site_iD = site_id
//            vc.site_Name = site_name
////            navigationController?.pushViewController(vc, animated: true)
//            Functions.pushToViewController(self, toVC: vc)
//        }
    }
}

extension Date {
    func startOfMonth() -> Date {
        let interval = Calendar.current.dateInterval(of: .month, for: self)
        return (interval?.start.toLocalTime())! // Without toLocalTime it give last months last date
    }

    func endOfMonth() -> Date {
        let interval = Calendar.current.dateInterval(of: .month, for: self)
        return interval!.end - 1
    }

    func getPreviousMonth() -> Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "dd-MM-yyyy"

        return dateFormatter.string(from: Date())
    }

    static var yesterday: Date { return Date().dayBefore }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}
