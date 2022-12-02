//
//  VisitorVehicleStatusLogVC.swift
//  EmployeeApp
//
//  Created by Jailove on 14/07/22.
//


import UIKit

class VisitorVehicleStatusLogVC: UIViewController , UITextFieldDelegate {
    
    @IBOutlet var viewNoDataFound: UIView!
    @IBOutlet var viewSearch: UIView!
    @IBOutlet var txtFieldSearch: UITextField!
    @IBOutlet var viewSeachBar: UIView!
    @IBOutlet var tblStatusList: UITableView!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var viewFilterNoDataFound: UIView!
    @IBOutlet weak var viewDateFilter: UIView!
    @IBOutlet weak var tblFilterStatusList: UITableView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var viewFilterStartMonth: UIView!
    @IBOutlet weak var viewFilterEndMonth: UIView!
    
    @IBOutlet weak var txtFieldDateFilter: UITextField!
    @IBOutlet weak var txtFieldStartMonth: UITextField!
    @IBOutlet weak var txtFieldEndMonth: UITextField!
    @IBOutlet weak var stackViews: UIStackView!
    @IBOutlet weak var HeightStackViewConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewFilterSearch: UIView!
    @IBOutlet weak var viewFilterBtnSearch: UIView!
    @IBOutlet weak var txtFieldFilterSearch: UITextField!
    @IBOutlet weak var lblSiteName: UILabel!
    @IBOutlet weak var lblCounter: UILabel!
    
    var site_Name = ""
    var site_id = ""
    var refreshControl = UIRefreshControl()
    var all_Entry_Array = [VisitorApprovalModel]()
    var entry_Array = [VisitorApprovalModel]()
    
    var start_Date = ""
    var end_Date = ""
    var statuss = ""
    
    // Calender Click Reject Log Search Data Functionality//
    var Filter_all_Entry_Array = [VisitorApprovalModel]()
    var Filter_entry_Array = [VisitorApprovalModel]()
    
    var search_Filter_vehicle_Log_Array = [String]()
    var searchFilter_Value = ""
    
    enum PickerType: String {
        case searchFilterPicker
    }
    
    var start_Date_Value = ""
    var end_Date_Value = ""
    var isCustomDateActive: Bool = false
    
    var currentPickerType: PickerType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSiteName.text = site_Name
        search_Filter_vehicle_Log_Array = ["Today", "Yesterday", "Last 7 Days", "Last 30 Days", "This Month", "Last Month", "Custom Range"]
        
        viewFilter.isHidden = true
        viewFilterStartMonth.isHidden = true
        viewFilterEndMonth.isHidden = true
        viewNoDataFound.isHidden = true
        tblFilterStatusList.isHidden = true
        viewFilterNoDataFound.isHidden = true
        
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.HeightStackViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        
        start_Date_Value = "\(Date.getCurrentDate())"
        end_Date_Value = "\(Date.getCurrentDate())"
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.viewSearch.round(corners: .allCorners, cornerRadius: 20)
            self.view.layoutIfNeeded()
            self.viewSearch.layer.borderColor = UIColor.black.cgColor
            self.viewSeachBar.round(corners: [.topRight, .bottomRight], cornerRadius: 20)
            self.view.layoutIfNeeded()
        }
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.tintColor = UIColor(hex: "1792A1")
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tblStatusList.addSubview(refreshControl)
        
        if appDelegate.userLoginAccessDetails?.id != nil {
            GetVisitorVehicleStatusListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "0", startDate: start_Date, endDate: end_Date, statusType: statuss)
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
    
    @IBAction func btnbackAction(_: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func refresh(_: AnyObject) {
        
        if appDelegate.userLoginAccessDetails?.id != nil {
            GetVisitorVehicleStatusListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "0", startDate: start_Date, endDate: end_Date, statusType: statuss)
        }
    }
    
    // MARK: - Calender Button Action Functionality-------------------------------------
    @IBAction func btnCalenderAction(_: Any) {
        
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.viewFilterSearch.round(corners: .allCorners, cornerRadius: 20)
            self.view.layoutIfNeeded()
            self.viewFilterSearch.layer.borderColor = UIColor.black.cgColor
            self.viewFilterBtnSearch.round(corners: [.topRight, .bottomRight], cornerRadius: 20)
            self.view.layoutIfNeeded()
        }
        viewFilter.isHidden = false
        viewFilterNoDataFound.isHidden = true
        tblFilterStatusList.isHidden = true
        viewDateFilter.layer.cornerRadius = 10
        viewDateFilter.layer.borderWidth = 1
        viewDateFilter.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        btnSearch.dropShadowWithCornerRadius()
        start_Date_Value = "\(Date.getCurrentDate())"
        end_Date_Value = "\(Date.getCurrentDate())"
        txtFieldDateFilter.text = "\(Date.getCurrentDate())"
        
    }
    
    // MARK: - Reload Button Action Functionality-------------------------------------
    @IBAction func btnReloadAction(_ sender: Any) {
        viewFilter.isHidden = true
        if appDelegate.userLoginAccessDetails?.id != nil {
            if appDelegate.userLoginAccessDetails?.id != nil {
                GetVisitorVehicleStatusListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "0", startDate: start_Date, endDate: end_Date, statusType: statuss)
            }
        }
    }
    
    //MARK:- Date Filter Action-----------------------
    @IBAction func btnDateFilterAction(_ sender: Any) {
        
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
            
            if self.search_Filter_vehicle_Log_Array.count > 0 {
                let element = self.search_Filter_vehicle_Log_Array[row]
                self.searchFilter_Value = element
                if element == "Today" {
                    self.tblFilterStatusList.isHidden = true
                    self.isCustomDateActive = false
                    self.txtFieldDateFilter.text = "\(Date.getCurrentDate())"
                    self.start_Date_Value = "\(Date.getCurrentDate())"
                    self.end_Date_Value = "\(Date.getCurrentDate())"
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewFilterStartMonth.isHidden = true
                        self.viewFilterEndMonth.isHidden = true
                        self.HeightStackViewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "Yesterday" {
                    self.tblFilterStatusList.isHidden = true
                    self.isCustomDateActive = false
                    print("\(Date.yesterday)")
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewFilterStartMonth.isHidden = true
                        self.viewFilterEndMonth.isHidden = true
                        self.HeightStackViewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                    self.txtFieldDateFilter.text = self.convertDateFormater("\(Date.yesterday)")
                    self.start_Date_Value = self.convertDateFormater("\(Date.yesterday)")
                    self.end_Date_Value = self.convertDateFormater("\(Date.yesterday)")
                    
                } else if element == "Last 7 Days" {
                    self.tblFilterStatusList.isHidden = true
                    self.isCustomDateActive = false
                    self.getLast7Dates()
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewFilterStartMonth.isHidden = true
                        self.viewFilterEndMonth.isHidden = true
                        self.HeightStackViewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                    
                } else if element == "Last 30 Days" {
                    self.tblFilterStatusList.isHidden = true
                    self.isCustomDateActive = false
                    self.getLast30Dates()
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewFilterStartMonth.isHidden = true
                        self.viewFilterEndMonth.isHidden = true
                        self.HeightStackViewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "This Month" {
                    self.tblFilterStatusList.isHidden = true
                    self.isCustomDateActive = false
                    let firstdate = "\(Date().startOfMonth())"
                    //  let lastdate = "\(Date().endOfMonth())"
                    self.txtFieldDateFilter.text = "\(self.convertDateFormater(firstdate)) To \(self.convertDateFormater("\(Date.yesterday)"))"
                    
                    self.start_Date_Value = "\(self.convertDateFormater(firstdate))"
                    self.end_Date_Value = "\(self.convertDateFormater("\(Date.yesterday)"))"
                    
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewFilterStartMonth.isHidden = true
                        self.viewFilterEndMonth.isHidden = true
                        self.HeightStackViewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "Last Month" {
                    self.tblFilterStatusList.isHidden = true
                    self.isCustomDateActive = false
                    let first = "\(Date().getPreviousMonth().startOfMonth())"
                    let last = "\(Date().getPreviousMonth().endOfMonth())"
                    
                    self.txtFieldDateFilter.text = "\(self.convertDateFormater(first)) To \(self.convertDateFormater(last))"
                    
                    self.start_Date_Value = "\(self.convertDateFormater(first))"
                    self.end_Date_Value = "\(self.convertDateFormater(last))"
                    
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewFilterStartMonth.isHidden = true
                        self.viewFilterEndMonth.isHidden = true
                        self.HeightStackViewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "Custom Range" {
                    self.tblFilterStatusList.isHidden = true
                    self.isCustomDateActive = true
                    self.txtFieldDateFilter.text = "Custom Range"
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.HeightStackViewConstraint.constant = 115
                        self.view.layoutIfNeeded()
                    }
                    self.viewFilterStartMonth.isHidden = false
                    self.viewFilterStartMonth.layer.cornerRadius = 10
                    self.viewFilterStartMonth.layer.borderWidth = 1
                    self.viewFilterStartMonth.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
                    self.txtFieldStartMonth.datePicker(target: self,
                                                       doneAction: #selector(self.startDoneAction),
                                                       cancelAction: #selector(self.startCancelAction),
                                                       datePickerMode: .date)
                    
                    self.viewFilterEndMonth.isHidden = false
                    self.viewFilterEndMonth.layer.cornerRadius = 10
                    self.viewFilterEndMonth.layer.borderWidth = 1
                    self.viewFilterEndMonth.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
                    
                    self.txtFieldEndMonth.datePicker(target: self,
                                                     doneAction: #selector(self.endDoneAction),
                                                     cancelAction: #selector(self.endCancelAction),
                                                     datePickerMode: .date)
                    
                } else {
                    self.isCustomDateActive = false
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.HeightStackViewConstraint.constant = 0
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
        if let datePickerView = txtFieldStartMonth.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: datePickerView.date)
            txtFieldStartMonth.text = dateString
            start_Date_Value = dateString
            
            print(datePickerView.date)
            print(dateString)
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
            print(datePickerView.date)
            print(dateString)
            
            txtFieldEndMonth.resignFirstResponder()
        }
    }
    
    @objc
    func endCancelAction() {
        txtFieldEndMonth.resignFirstResponder()
    }
    
    
    //MARK:- Filter Search Button Action Functionality----------------------------
    @IBAction func btnSearchFilterAction(_ sender: Any) {
        if appDelegate.userLoginAccessDetails?.id != nil {
            if isCustomDateActive == true {
                if txtFieldStartMonth.text == "" {
                    view.makeToast("please select start date", duration: 1.0, position: .center)
                } else if txtFieldEndMonth.text == "" {
                    view.makeToast("please select end date", duration: 1.0, position: .center)
                } else {
                    FilterApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "0", startDate: start_Date_Value, endDate: end_Date_Value, statusType: statuss)
                }
            } else {
                FilterApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "0", startDate: start_Date_Value, endDate: end_Date_Value, statusType: statuss)
            }
        }
    }
    
    // MARK: - Search Bar Button Action Functionality---------------------------------
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty && range.location == 0 {
            if txtFieldSearch == textField {
                GetVisitorVehicleStatusListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "0", startDate: start_Date, endDate: end_Date, statusType: statuss)
            } else if txtFieldFilterSearch == textField {
                FilterApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "0", startDate: start_Date_Value, endDate: end_Date_Value, statusType: statuss)
            }
        }
        return true
    }
    
    @IBAction func btnSearchBarAction(_: Any) {
        
        if txtFieldSearch.text != "" {
            searchApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", search: txtFieldSearch.text ?? "")
        } else {
            
            if appDelegate.userLoginAccessDetails?.id != nil {
                GetVisitorVehicleStatusListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "0", startDate: start_Date, endDate: end_Date, statusType: statuss)
            }
            //            self.view.makeToast("please enter search name", duration: 0.8, position: .center)
            //            return
        }
        
    }
    
    //MARK:- Filter Search Bar Action Functionality---------------------
    @IBAction func btnFilterSearchbarAction(_ sender: Any) {
        if txtFieldFilterSearch.text != "" {
            FilterSearchApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", search: txtFieldFilterSearch.text ?? "")
        } else {
            if appDelegate.userLoginAccessDetails?.id != nil {
                FilterApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "0", startDate: start_Date_Value, endDate: end_Date_Value, statusType: statuss)
            }
            //            self.view.makeToast("please enter search name", duration: 0.8, position: .center)
            //            return
        }
    }
    
    
    // MARK: -  Vehicle Status List Api Functionality-------------------------------
    
    func GetVisitorVehicleStatusListApi(UserID: String,type: String, startDate: String, endDate: String, statusType: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": UserID,
                          "type": type,
                          "start_date": startDate,
                          "end_date": endDate,
                          "status": statusType,
                          "site_id": site_id] as [String: Any]
            
            Webservice.Authentication.visitorAporovalLogApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    self.all_Entry_Array.removeAll()
                    self.entry_Array.removeAll()
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {
                            
                            if let dictionary = body["request_list"] as? [[String: Any]] {
                                
                                for Dict in dictionary {
                                    let obj = VisitorApprovalModel(fromDictionary: Dict as [String: AnyObject])
                                    self.all_Entry_Array.append(obj)
                                }
                                
                                if self.all_Entry_Array.count > 0 {
                                    for i in 0 ... self.all_Entry_Array.count - 1 {
                                        let dic = self.all_Entry_Array[i]
                                        if self.all_Entry_Array[i].exitStatus == "1"{
                                            self.entry_Array.append(dic)
                                        }
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.tblStatusList.delegate = self
                                    self.tblStatusList.dataSource = self
                                    self.tblStatusList.reloadData()
                                }
                            }
                        }
                    }
                    self.tblStatusList.isHidden = self.entry_Array.count <= 0
                    self.viewNoDataFound.isHidden = self.entry_Array.count > 0
                    self.viewSearch.isHidden = self.entry_Array.count <= 0
                    self.viewNoDataFound.backgroundColor = UIColor.clear
                    self.refreshControl.endRefreshing()
                    self.lblCounter.text = "\(self.entry_Array.count)"

                case let .fail(errorMsg):
                    self.tblStatusList.isHidden = true
                    self.viewNoDataFound.isHidden = false
                    self.viewNoDataFound.backgroundColor = UIColor.clear
                    self.viewSearch.isHidden = true
                    print(errorMsg)
                }
            }
        }
    }
    
    // MARK: - Filter Approve Vehicle List Api Functionality-------------------------------
    
    func FilterApproveVehicleListApi(UserID: String,type: String, startDate: String, endDate: String, statusType: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": UserID,
                          "type": type,
                          "start_date": startDate,
                          "end_date": endDate,
                          "status": statusType,
                          "site_id": site_id] as [String: Any]
            Webservice.Authentication.visitorAporovalLogApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    self.Filter_all_Entry_Array.removeAll()
                    self.Filter_entry_Array.removeAll()
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {
                            
                            if let dictionary = body["request_list"] as? [[String: Any]] {
                                
                                for Dict in dictionary {
                                    let obj = VisitorApprovalModel(fromDictionary: Dict as [String: AnyObject])
                                    self.Filter_all_Entry_Array.append(obj)
                                }
                                
                                if self.Filter_all_Entry_Array.count > 0 {
                                    for i in 0 ... self.Filter_all_Entry_Array.count - 1 {
                                        if self.Filter_all_Entry_Array[i].exitStatus == "1" {
                                            let dic = self.Filter_all_Entry_Array[i]
                                            self.Filter_entry_Array.append(dic)
                                        }
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.tblFilterStatusList.delegate = self
                                    self.tblFilterStatusList.dataSource = self
                                    self.tblFilterStatusList.reloadData()
                                }
                            }
                        }
                    }
                    self.tblFilterStatusList.isHidden = self.Filter_entry_Array.count <= 0
                    self.viewFilterNoDataFound.isHidden = self.Filter_entry_Array.count > 0
                    self.viewFilterNoDataFound.backgroundColor = UIColor.clear
                    self.refreshControl.endRefreshing()
                    self.lblCounter.text = "\(self.Filter_entry_Array.count)"

                case let .fail(errorMsg):
                    self.tblFilterStatusList.isHidden = true
                    self.viewFilterNoDataFound.isHidden = false
                    print(errorMsg)
                }
            }
        }
    }
    
    // MARK: -  Search Approve Vehicle List Api Functionality-------------------------------
    
    func searchApproveVehicleListApi(UserID: String,search: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
//            let params = ["user_id": UserID,
//                          "search": search] as [String: Any]
            let params = ["user_id": UserID,
                          "search": search,
//                          "start_date": start_Date_Value,
//                          "end_date": end_Date_Value,
                          "search_type": "2",
                          "type": "",
                          "site_id": site_id] as [String: Any]
            Webservice.Authentication.visitorSearchAprrovalApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    self.all_Entry_Array.removeAll()
                    self.entry_Array.removeAll()
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {
                            
                            if let dictionary = body["search_data"] as? [[String: Any]] {
                                
                                for Dict in dictionary {
                                    let obj = VisitorApprovalModel(fromDictionary: Dict as [String: AnyObject])
                                    self.all_Entry_Array.append(obj)
                                }
                                
                                if self.all_Entry_Array.count > 0 {
                                    for i in 0 ... self.all_Entry_Array.count - 1 {
                                        if self.all_Entry_Array[i].entry == "1" && self.all_Entry_Array[i].exitStatus == "1" {
                                            let dic = self.all_Entry_Array[i]
                                            self.entry_Array.append(dic)
                                        }
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.tblStatusList.delegate = self
                                    self.tblStatusList.dataSource = self
                                    self.tblStatusList.reloadData()
                                }
                            }
                        }
                    }
                    self.tblStatusList.isHidden = self.entry_Array.count <= 0
                    self.viewNoDataFound.isHidden = self.entry_Array.count > 0
                    self.viewNoDataFound.backgroundColor = UIColor.clear
                    self.refreshControl.endRefreshing()
                    self.lblCounter.text = "\(self.entry_Array.count)"

                case let .fail(errorMsg):
                    self.tblStatusList.isHidden = true
                    self.viewNoDataFound.isHidden = false
                    print(errorMsg)
                }
            }
        }
    }
    
    // MARK: - Filter Search Approve Vehicle List Api Functionality-------------------------------
    
    func FilterSearchApproveVehicleListApi(UserID: String,search: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
//            let params = ["user_id": UserID,
//                          "search": search] as [String: Any]
            let params = ["user_id": UserID,
                          "search": search,
//                          "start_date": start_Date_Value,
//                          "end_date": end_Date_Value,
                          "search_type": "2",
                          "type": "",
                          "site_id": site_id] as [String: Any]
            
            Webservice.Authentication.visitorSearchAprrovalApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    self.Filter_all_Entry_Array.removeAll()
                    self.Filter_entry_Array.removeAll()
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {
                            
                            if let dictionary = body["search_data"] as? [[String: Any]] {
                               
                                for Dict in dictionary {
                                    let obj = VisitorApprovalModel(fromDictionary: Dict as [String: AnyObject])
                                    self.Filter_all_Entry_Array.append(obj)
                                }
                                
                                if self.Filter_all_Entry_Array.count > 0 {
                                    for i in 0 ... self.Filter_all_Entry_Array.count - 1 {
                                        if self.Filter_all_Entry_Array[i].entry == "1" && self.Filter_all_Entry_Array[i].exitStatus == "1" {
                                            let dic = self.Filter_all_Entry_Array[i]
                                            self.Filter_entry_Array.append(dic)
                                        }
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.tblFilterStatusList.delegate = self
                                    self.tblFilterStatusList.dataSource = self
                                    self.tblFilterStatusList.reloadData()
                                }
                            }
                        }
                    }
                    self.tblFilterStatusList.isHidden = self.Filter_entry_Array.count <= 0
                    self.viewFilterNoDataFound.isHidden = self.Filter_entry_Array.count > 0
                    self.viewFilterNoDataFound.backgroundColor = UIColor.clear
                    self.refreshControl.endRefreshing()
                    self.lblCounter.text = "\(self.Filter_entry_Array.count)"
                case let .fail(errorMsg):
                    self.tblFilterStatusList.isHidden = true
                    self.viewFilterNoDataFound.isHidden = false
                    print(errorMsg)
                }
            }
        }
    }
    
    
}

// MARK: - UITable View Data Source and Delegates Methods******************************

extension VisitorVehicleStatusLogVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
        
        if tableView == tblStatusList {
            return entry_Array.count
        } else {
            return Filter_entry_Array.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblStatusList {
            let obj = entry_Array[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleStatusTableViewCell", for: indexPath) as! VehicleStatusTableViewCell // Red in Color Because of Status
            cell.selectionStyle = .none
            cell.innerViewDetail.layer.cornerRadius = 8
            
            cell.lblUniqueID.text = obj.id ?? ""
            
            cell.lblVehicleNo.text = obj.visitorName ?? ""
            
            cell.lblStatus.text = "Exited \n\(obj.exitUpdatedDate ?? "")"
            
            cell.btnViewDetail.tag = indexPath.row
            cell.btnViewDetail.addTarget(self, action: #selector(btnViewDetailAction(sender:)), for: .touchUpInside)
            return cell
        } else {
            let obj = Filter_entry_Array[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleStatusTableViewCell", for: indexPath) as! VehicleStatusTableViewCell // Red in Color Because of Status
            cell.selectionStyle = .none
            cell.innerViewDetail.layer.cornerRadius = 8
            
            cell.lblUniqueID.text = obj.id ?? ""
            
            cell.lblVehicleNo.text = obj.visitorName ?? ""
            
            cell.lblStatus.text = "Exited \n\(obj.exitUpdatedDate ?? "")"
            
            
            cell.btnViewDetail.tag = indexPath.row
            cell.btnViewDetail.addTarget(self, action: #selector(btnFilterViewDetailAction(sender:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc func btnViewDetailAction(sender: UIButton) {
        DispatchQueue.main.async {
            let obj = self.entry_Array[sender.tag]
            if let vc = UIStoryboard(name: "Visitor", bundle: nil).instantiateViewController(withIdentifier: "VisitorVehicleStatusViewDetailVC") as? VisitorVehicleStatusViewDetailVC {
                vc.objApproval = obj
                vc.site_Name = self.site_Name
                vc.site_id = self.site_id
//                self.navigationController?.pushViewController(vc, animated: true)
                Functions.pushToViewController(self, toVC: vc)

            }
        }
    }
    
    
    @objc func btnFilterViewDetailAction(sender: UIButton) {
        DispatchQueue.main.async {
            let obj = self.Filter_entry_Array[sender.tag]
            if let vc = UIStoryboard(name: "Visitor", bundle: nil).instantiateViewController(withIdentifier: "VisitorVehicleStatusViewDetailVC") as? VisitorVehicleStatusViewDetailVC {
                vc.objApproval = obj
                vc.site_Name = self.site_Name
                vc.site_id = self.site_id
//                self.navigationController?.pushViewController(vc, animated: true)
                Functions.pushToViewController(self, toVC: vc)

            }
        }
    }
}

extension VisitorVehicleStatusLogVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        guard let inputType = currentPickerType else { return 0 }
        if inputType == .searchFilterPicker {
            return search_Filter_vehicle_Log_Array.count
        } else {
            return 0
        }
    }
    
    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        guard let inputType = currentPickerType else { return "" }
        if inputType == .searchFilterPicker {
            let element = search_Filter_vehicle_Log_Array[row]
            return element
        } else {
            return ""
        }
    }
}


