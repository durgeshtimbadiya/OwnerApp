//
//  VisitorApprovalLogVC.swift
//  EmployeeApp
//
//  Created by Jailove on 23/06/22.
//

import UIKit

class VisitorApprovalLogVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var viewNoDataFound: UIView!
    @IBOutlet var viewSearch: UIView!
    @IBOutlet var txtFieldSearch: UITextField!
    @IBOutlet var viewSeachBar: UIView!

    @IBOutlet var TBLApproveList: UITableView!

    var refreshControl = UIRefreshControl()
    var all_Entry_Array = [VisitorApprovalModel]()
    var entry_Array = [VisitorApprovalModel]()
    
    var start_Date = ""
    var end_Date = ""
    var statuss = ""
    var site_Name = ""
    var site_id = ""
    // Calender Click Approve Log Search Data Functionality//
    
    var Filter_all_Entry_Array = [VisitorApprovalModel]()
    var Filter_entry_Array = [VisitorApprovalModel]()
    
    
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var viewFilterNoDataFound: UIView!
    @IBOutlet weak var viewDateFilter: UIView!
    @IBOutlet weak var TBLFilterApproveList: UITableView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var viewFilterStartMonth: UIView!
    @IBOutlet weak var viewFilterEndMonth: UIView!
    
    
    @IBOutlet weak var txtFieldDateFilter: UITextField!
    @IBOutlet weak var txtFieldStartMonth: UITextField!
    @IBOutlet weak var txtFieldEndMonth: UITextField!
    @IBOutlet weak var stackViews: UIStackView!
    @IBOutlet weak var HeightStackViewConstraint: NSLayoutConstraint!
    
    var search_Filter_vehicle_Log_Array = [String]()
    var searchFilter_Value = ""

    enum PickerType: String {
        case searchFilterPicker
    }

    var start_Date_Value = ""
    var end_Date_Value = ""
    var isCustomDateActive: Bool = false

    var currentPickerType: PickerType?
    
    @IBOutlet weak var viewFilterSearch: UIView!
    @IBOutlet weak var viewFilterBtnSearch: UIView!
    @IBOutlet weak var txtFieldFilterSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = site_Name
        search_Filter_vehicle_Log_Array = ["Today", "Yesterday", "Last 7 Days", "Last 30 Days", "This Month", "Last Month", "Custom Range"]

        viewFilter.isHidden = true
        viewFilterStartMonth.isHidden = true
        viewFilterEndMonth.isHidden = true
        viewNoDataFound.isHidden = true
        TBLFilterApproveList.isHidden = true
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
        TBLApproveList.addSubview(refreshControl)

        if appDelegate.userLoginAccessDetails?.id != nil {
            GetApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "1", startDate: start_Date, endDate: end_Date, statusType: "0")
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
        GetApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "1", startDate: start_Date, endDate: end_Date, statusType: "0")
    }
}

// MARK: - Reload Button Action Functionality-------------------------------------
@IBAction func btnReloadAction(_ sender: Any) {
    viewFilter.isHidden = true
    if appDelegate.userLoginAccessDetails?.id != nil {
        if appDelegate.userLoginAccessDetails?.id != nil {
            GetApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "1", startDate: start_Date, endDate: end_Date, statusType: "0")
        }
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
    TBLFilterApproveList.isHidden = true
    viewDateFilter.layer.cornerRadius = 10
    viewDateFilter.layer.borderWidth = 1
    viewDateFilter.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
    btnSearch.dropShadowWithCornerRadius()
    start_Date_Value = "\(Date.getCurrentDate())"
    end_Date_Value = "\(Date.getCurrentDate())"
    txtFieldDateFilter.text = "\(Date.getCurrentDate())"
    
}

//MARK:- Date Filter Action-----------------------
@IBAction func btnDateFilterAction(_ sender: UIButton) {
    
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
                self.TBLFilterApproveList.isHidden = true
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
                self.TBLFilterApproveList.isHidden = true
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
                self.TBLFilterApproveList.isHidden = true
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
                self.TBLFilterApproveList.isHidden = true
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
                self.TBLFilterApproveList.isHidden = true
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
                self.TBLFilterApproveList.isHidden = true
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
                self.TBLFilterApproveList.isHidden = true
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
                FilterApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "1", startDate: start_Date_Value, endDate: end_Date_Value, statusType: "0")
            }
        } else {
            FilterApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "1", startDate: start_Date_Value, endDate: end_Date_Value, statusType: "0")
        }
    }
}

// MARK: - Search Bar Button Action Functionality---------------------------------

@IBAction func btnSearchBarAction(_: Any) {
    
    if txtFieldSearch.text != "" {
       // searchApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", search: txtFieldSearch.text ?? "", startDate: start_Date_Value, endDate: end_Date_Value)
        
        searchApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", search: txtFieldSearch.text ?? "", startDate: start_Date_Value, endDate: end_Date_Value, searchType: "2", type: "")
    } else {
       
        if appDelegate.userLoginAccessDetails?.id != nil {
            GetApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "1", startDate: start_Date, endDate: end_Date, statusType: "0")
        }
    }
    
}
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty && range.location == 0 {
            if txtFieldSearch == textField {
                GetApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "1", startDate: start_Date, endDate: end_Date, statusType: "0")
            } else if txtFieldFilterSearch == textField {
                FilterApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "1", startDate: start_Date_Value, endDate: end_Date_Value, statusType: "0")
            }
        }
        return true
    }

    //MARK:- Filter Search Bar Action Functionality---------------------
    @IBAction func btnFilterSearchbarAction(_ sender: Any) {
        if txtFieldFilterSearch.text != "" {
            FilterSearchApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", search: txtFieldSearch.text ?? "", startDate: start_Date_Value, endDate: end_Date_Value, searchType: "2", type: "")
        } else {
            if appDelegate.userLoginAccessDetails?.id != nil {
                FilterApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "1", startDate: start_Date_Value, endDate: end_Date_Value, statusType: "0")
            }
        }
    }


// MARK: -  Approve Vehicle List Api Functionality-------------------------------

func GetApproveVehicleListApi(UserID: String,type: String, startDate: String, endDate: String, statusType: String) {
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
                           
                            self.refreshControl.endRefreshing()

                            for Dict in dictionary {
                                let obj = VisitorApprovalModel(fromDictionary: Dict as [String: AnyObject])
                                self.all_Entry_Array.append(obj)
                            }

                            if self.all_Entry_Array.count > 0 {
                                for i in 0 ... self.all_Entry_Array.count - 1 {
                                    if self.all_Entry_Array[i].entry == "0", self.all_Entry_Array[i].status == "0", self.all_Entry_Array[i].askApproval == "1" {
                                        let dic = self.all_Entry_Array[i]
                                        self.entry_Array.append(dic)
                                    } else if self.all_Entry_Array[i].entry == "0", self.all_Entry_Array[i].status == "1", self.all_Entry_Array[i].askApproval == "1" {
                                        let dic = self.all_Entry_Array[i]
                                        self.entry_Array.append(dic)
                                    }
                                }
                           }
                            DispatchQueue.main.async {
                                self.TBLApproveList.delegate = self
                                self.TBLApproveList.dataSource = self
                                self.TBLApproveList.reloadData()
                            }
                        }
                    }
                }
                self.TBLApproveList.isHidden = self.entry_Array.count <= 0
                self.viewNoDataFound.isHidden = self.entry_Array.count > 0
                self.viewSearch.isHidden = self.entry_Array.count <= 0
                self.viewNoDataFound.backgroundColor = UIColor.clear
                self.refreshControl.endRefreshing()
            case let .fail(errorMsg):
                self.TBLApproveList.isHidden = true
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
                                    if self.Filter_all_Entry_Array[i].entry == "0", self.Filter_all_Entry_Array[i].status == "0", self.Filter_all_Entry_Array[i].askApproval == "1" {
                                        let dic = self.Filter_all_Entry_Array[i]
                                        self.Filter_entry_Array.append(dic)
                                    } else if self.Filter_all_Entry_Array[i].entry == "0", self.Filter_all_Entry_Array[i].status == "1", self.Filter_all_Entry_Array[i].askApproval == "1" {
                                        let dic = self.Filter_all_Entry_Array[i]
                                        self.Filter_entry_Array.append(dic)
                                    }
                                }
                           }
                            DispatchQueue.main.async {
                                self.TBLFilterApproveList.delegate = self
                                self.TBLFilterApproveList.dataSource = self
                                self.TBLFilterApproveList.reloadData()
                            }
                        }
                    }
                }
                self.TBLFilterApproveList.isHidden = self.Filter_entry_Array.count <= 0
                self.viewFilterNoDataFound.isHidden = self.Filter_entry_Array.count > 0
                self.viewFilterNoDataFound.backgroundColor = UIColor.clear
                self.refreshControl.endRefreshing()
            case let .fail(errorMsg):
                self.TBLFilterApproveList.isHidden = true
                self.viewFilterNoDataFound.isHidden = false
                self.viewFilterNoDataFound.backgroundColor = .clear
                print(errorMsg)
            }
        }
    }
}
    
// MARK: -  Search Approve Vehicle List Api Functionality-------------------------------

    func searchApproveVehicleListApi(UserID: String,search: String, startDate: String, endDate: String, searchType:String, type:String) {
    if ProjectUtilities.checkInternateAvailable(viewController: self) {
        let params = ["user_id": UserID,
                      "search": search,
//                      "start_date": startDate,
//                      "end_date": endDate,
                      "search_type": searchType,
                      "type": type,
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
                                    if self.all_Entry_Array[i].status == "1" && self.all_Entry_Array[i].askApproval == "1" && self.all_Entry_Array[i].exitStatus == "0" && self.all_Entry_Array[i].exitAskApproval == "0" && self.all_Entry_Array[i].entry == "0" {
                                        let dic = self.all_Entry_Array[i]
                                        self.entry_Array.append(dic)
                                    } else if self.all_Entry_Array[i].status == "0" && self.all_Entry_Array[i].askApproval == "1" && self.all_Entry_Array[i].exitStatus == "0" && self.all_Entry_Array[i].exitAskApproval == "0" && self.all_Entry_Array[i].entry == "0" {
                                        let dic = self.all_Entry_Array[i]
                                        self.entry_Array.append(dic)
                                    }
                                }
                           }
                            DispatchQueue.main.async {
                                self.TBLApproveList.delegate = self
                                self.TBLApproveList.dataSource = self
                                self.TBLApproveList.reloadData()
                            }
                        }
                    }
                }
                self.TBLApproveList.isHidden = self.entry_Array.count <= 0
                self.viewNoDataFound.isHidden = self.entry_Array.count > 0
                self.viewNoDataFound.backgroundColor = UIColor.clear
                self.refreshControl.endRefreshing()
            case let .fail(errorMsg):
                self.TBLApproveList.isHidden = true
                self.viewNoDataFound.isHidden = false
                self.viewNoDataFound.backgroundColor = .clear
                print(errorMsg)
            }
        }
    }
}

// MARK: - Filter Search Approve Vehicle List Api Functionality-------------------------------

func FilterSearchApproveVehicleListApi(UserID: String,search: String, startDate: String, endDate: String, searchType:String, type:String) {
    if ProjectUtilities.checkInternateAvailable(viewController: self) {
        
        let params = ["user_id": UserID,
                      "search": search,
//                      "start_date": startDate,
//                      "end_date": endDate,
                      "search_type": searchType,
                      "type": type,
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
                                    if self.Filter_all_Entry_Array[i].status == "1" && self.Filter_all_Entry_Array[i].askApproval == "1"  && self.Filter_all_Entry_Array[i].exitAskApproval == "0" && self.Filter_all_Entry_Array[i].entry == "0" {
                                        let dic = self.Filter_all_Entry_Array[i]
                                        self.Filter_entry_Array.append(dic)
                                    } else if self.Filter_all_Entry_Array[i].status == "0" && self.Filter_all_Entry_Array[i].askApproval == "1"  && self.Filter_all_Entry_Array[i].exitAskApproval == "0" && self.Filter_all_Entry_Array[i].entry == "0" {
                                        let dic = self.Filter_all_Entry_Array[i]
                                        self.Filter_entry_Array.append(dic)
                                    }
                                }
                           }
                           
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.TBLFilterApproveList.delegate = self
                    self.TBLFilterApproveList.dataSource = self
                    self.TBLFilterApproveList.reloadData()
                }
                self.TBLFilterApproveList.isHidden = self.Filter_entry_Array.count <= 0
                self.viewFilterNoDataFound.isHidden = self.Filter_entry_Array.count > 0
                self.viewFilterNoDataFound.backgroundColor = UIColor.clear
                self.refreshControl.endRefreshing()
            case let .fail(errorMsg):
                self.TBLFilterApproveList.isHidden = true
                self.viewFilterNoDataFound.isHidden = false
                self.viewFilterNoDataFound.backgroundColor = .clear
                print(errorMsg)
            }
        }
    }
}


}

// MARK: - UITable View Data Source and Delegates Methods******************************

extension VisitorApprovalLogVC: UITableViewDelegate, UITableViewDataSource {
func numberOfSections(in _: UITableView) -> Int {
    return 1
}

func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
  
    if tableView == TBLApproveList {
        return entry_Array.count
    } else {
        return Filter_entry_Array.count
    }
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView == TBLApproveList {
        let obj = entry_Array[indexPath.row]
        if obj.entry == "0", obj.status == "0", obj.askApproval == "1" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovalVehicleTableCell", for: indexPath) as! ApprovalVehicleTableCell // Red in Color Because of Status
            cell.selectionStyle = .none
            cell.innerViewDetail.layer.cornerRadius = 8
            
            cell.lblUniqueID.text = obj.id ?? ""
            cell.lblUniqueID.textColor = UIColor.red
            
            cell.lblVehicleNo.text = obj.visitorName ?? ""
            cell.lblVehicleNo.textColor = UIColor.red
            
            cell.lblStatus.text = "Seeking Granted for Entry"
            cell.lblStatus.textColor = UIColor.red
            
            cell.lblAction.isHidden = true
            
            cell.btnApprove.isHidden = false
            cell.btnReject.isHidden = false
            
            cell.btnViewDetail.tag = indexPath.row
            cell.btnViewDetail.addTarget(self, action: #selector(btnViewDetailAction(sender:)), for: .touchUpInside)
            
            cell.btnApprove.tag = indexPath.row
            cell.btnApprove.addTarget(self, action: #selector(btnApproveDetailAction(sender:)), for: .touchUpInside)
            
            cell.btnReject.tag = indexPath.row
            cell.btnReject.addTarget(self, action: #selector(btnRejectDetailAction(sender:)), for: .touchUpInside)
            
            
            return cell
        }
        
        else if obj.entry == "0", obj.status == "1", obj.askApproval == "1" { // Greee in Color Because of Status
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovalVehicleTableCell", for: indexPath) as! ApprovalVehicleTableCell // Red in Color Because of Status
            
            cell.selectionStyle = .none
            cell.innerViewDetail.layer.cornerRadius = 8
            
            cell.lblUniqueID.text = obj.id ?? ""
            cell.lblUniqueID.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)
            
            cell.lblVehicleNo.text = obj.visitorName ?? ""
            cell.lblVehicleNo.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)
            
            cell.lblStatus.text = "Seeking Granted for Entry"
            cell.lblStatus.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)
            
            cell.lblAction.isHidden = false
            cell.lblAction.text = "Approved Entry"
            cell.lblAction.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)
            
            cell.btnApprove.isHidden = true
            cell.btnReject.isHidden = true
            
            cell.btnViewDetail.tag = indexPath.row
            cell.btnViewDetail.addTarget(self, action: #selector(btnViewDetailAction(sender:)), for: .touchUpInside)
            
            return cell
        }
        else if obj.entry == "1", obj.exitStatus == "0", obj.exitAskApproval == "0" { // (3 Condition) Greee in Color Because of Status
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovalVehicleTableCell", for: indexPath) as! ApprovalVehicleTableCell // Red in Color Because of Status

            cell.selectionStyle = .none
            cell.innerViewDetail.layer.cornerRadius = 8

            cell.lblUniqueID.text = obj.id ?? ""
            cell.lblUniqueID.textColor = UIColor.green

            cell.lblVehicleNo.text = obj.visitorName ?? ""
            cell.lblVehicleNo.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)

            cell.lblStatus.text = "Visitor Entered"
            cell.lblStatus.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)

            cell.lblAction.isHidden = false
            cell.lblAction.text = "Approval For Exit"
            cell.lblAction.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)

            cell.btnApprove.isHidden = true
            cell.btnReject.isHidden = true

            cell.btnViewDetail.tag = indexPath.row
            cell.btnViewDetail.addTarget(self, action: #selector(btnViewDetailAction(sender:)), for: .touchUpInside)

            return cell
        }
        else if obj.entry == "1", obj.exitStatus == "0", obj.exitAskApproval == "1" { // (4 Condition) Greee in Color Because of Status
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovalVehicleTableCell", for: indexPath) as! ApprovalVehicleTableCell // Red in Color Because of Status

            cell.selectionStyle = .none
            cell.innerViewDetail.layer.cornerRadius = 8

            cell.lblUniqueID.text = obj.id ?? ""
            cell.lblUniqueID.textColor = UIColor.green

            cell.lblVehicleNo.text = obj.visitorName ?? ""
            cell.lblVehicleNo.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)

            cell.lblStatus.text = "Seeking For Granted Exit"
            cell.lblStatus.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)

            cell.lblAction.isHidden = false
            cell.lblAction.text = "Exit Approved"
            cell.lblAction.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)

            cell.btnApprove.isHidden = true
            cell.btnReject.isHidden = true

            cell.btnViewDetail.tag = indexPath.row
            cell.btnViewDetail.addTarget(self, action: #selector(btnViewDetailAction(sender:)), for: .touchUpInside)

            return cell
        }
        else {
            return UITableViewCell()
        }
    } else {
        let obj = Filter_entry_Array[indexPath.row]
        if obj.entry == "0", obj.status == "0", obj.askApproval == "1" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovalVehicleTableCell", for: indexPath) as! ApprovalVehicleTableCell // Red in Color Because of Status
            cell.selectionStyle = .none
            cell.innerViewDetail.layer.cornerRadius = 8
            
            cell.lblUniqueID.text = obj.id ?? ""
            cell.lblUniqueID.textColor = UIColor.red
            
            cell.lblVehicleNo.text = obj.visitorName ?? ""
            cell.lblVehicleNo.textColor = UIColor.red
            
            cell.lblStatus.text = "Seeking Approval for Entry"
            cell.lblStatus.textColor = UIColor.red
            
            cell.lblAction.isHidden = true
            
            cell.btnApprove.isHidden = false
            cell.btnReject.isHidden = false
            
            cell.btnViewDetail.tag = indexPath.row
            cell.btnViewDetail.addTarget(self, action: #selector(btnFilterViewDetailAction(sender:)), for: .touchUpInside)
            
            cell.btnApprove.tag = indexPath.row
            cell.btnApprove.addTarget(self, action: #selector(btnFilterApproveDetailAction(sender:)), for: .touchUpInside)
            
            cell.btnReject.tag = indexPath.row
            cell.btnReject.addTarget(self, action: #selector(btnFilterRejectDetailAction(sender:)), for: .touchUpInside)
            
            
            return cell
        }
        
        else if obj.entry == "0", obj.status == "1", obj.askApproval == "1" { // Greee in Color Because of Status
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovalVehicleTableCell", for: indexPath) as! ApprovalVehicleTableCell // Red in Color Because of Status
            
            cell.selectionStyle = .none
            cell.innerViewDetail.layer.cornerRadius = 8
            
            cell.lblUniqueID.text = obj.id ?? ""
            cell.lblUniqueID.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)
            
            cell.lblVehicleNo.text = obj.visitorName ?? ""
            cell.lblVehicleNo.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)
            
            cell.lblStatus.text = "Seeking Approval for Entry"
            cell.lblStatus.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)
            
            cell.lblAction.isHidden = false
            cell.lblAction.text = "Approved Entry"
            cell.lblAction.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)
            
            cell.btnApprove.isHidden = true
            cell.btnReject.isHidden = true
            
            cell.btnViewDetail.tag = indexPath.row
            cell.btnViewDetail.addTarget(self, action: #selector(btnFilterViewDetailAction(sender:)), for: .touchUpInside)
            
            return cell
        }
        else if obj.entry == "1", obj.exitStatus == "0", obj.exitAskApproval == "0" { // (3 Condition) Greee in Color Because of Status
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovalVehicleTableCell", for: indexPath) as! ApprovalVehicleTableCell // Red in Color Because of Status

            cell.selectionStyle = .none
            cell.innerViewDetail.layer.cornerRadius = 8

            cell.lblUniqueID.text = obj.id ?? ""
            cell.lblUniqueID.textColor = UIColor.green

            cell.lblVehicleNo.text = obj.visitorName ?? ""
            cell.lblVehicleNo.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)

            cell.lblStatus.text = "Visitor Entered"
            cell.lblStatus.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)

            cell.lblAction.isHidden = false
            cell.lblAction.text = "Approval For Exit"
            cell.lblAction.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)

            cell.btnApprove.isHidden = true
            cell.btnReject.isHidden = true

            cell.btnViewDetail.tag = indexPath.row
            cell.btnViewDetail.addTarget(self, action: #selector(btnFilterViewDetailAction(sender:)), for: .touchUpInside)

            return cell
        }
        else if obj.entry == "1", obj.exitStatus == "0", obj.exitAskApproval == "1" { // (4 Condition) Greee in Color Because of Status
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovalVehicleTableCell", for: indexPath) as! ApprovalVehicleTableCell // Red in Color Because of Status

            cell.selectionStyle = .none
            cell.innerViewDetail.layer.cornerRadius = 8

            cell.lblUniqueID.text = obj.id ?? ""
            cell.lblUniqueID.textColor = UIColor.green

            cell.lblVehicleNo.text = obj.visitorName ?? ""
            cell.lblVehicleNo.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)

            cell.lblStatus.text = "Seeking For Granted Exit"
            cell.lblStatus.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)

            cell.lblAction.isHidden = false
            cell.lblAction.text = "Exit Approved"
            cell.lblAction.textColor = UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 0 / 255.0, alpha: 1.0)

            cell.btnApprove.isHidden = true
            cell.btnReject.isHidden = true

            cell.btnViewDetail.tag = indexPath.row
            cell.btnViewDetail.addTarget(self, action: #selector(btnFilterViewDetailAction(sender:)), for: .touchUpInside)

            return cell
        }
        else {
            return UITableViewCell()
        }
    }
}

func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}

@objc func btnViewDetailAction(sender: UIButton) {
    DispatchQueue.main.async {
        let obj = self.entry_Array[sender.tag]
        if let vc = UIStoryboard(name: "Visitor", bundle: nil).instantiateViewController(withIdentifier: "VisitorApprovalLogDetailVC") as? VisitorApprovalLogDetailVC {
            vc.objApproval = obj
            vc.site_Name = self.site_Name
            vc.site_id = self.site_id
//            self.navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)

        }
    }
}

@objc func btnApproveDetailAction(sender: UIButton) {
    
    let alertcontroller = UIAlertController(title: "Confirmation", message: "Are you sure want to Approve this Visitor?", preferredStyle: .alert)
    let yes = UIAlertAction(title: "YES", style: .default) { _ in
        DispatchQueue.main.async {
            let obj = self.entry_Array[sender.tag]

            if ProjectUtilities.checkInternateAvailable(viewController: self) {
                let params = ["user_id": appDelegate.userLoginAccessDetails?.id ?? "",
                              "entry_id": obj.id ?? "",
                              "entry_type": "1",
                              "type": "0",
                              "status": "1",
                              "site_id": self.site_id] as [String: Any]
                
                Webservice.Authentication.visitorAprroveAndRejectApi(parameter: params) { [self] result in
                    switch result {
                    case let .success(response):
                        if let body = response.body as? [String: Any] {
                           
                            if body["code"] as? Int ?? 0 == 200 {
                                
                                self.view.makeToast(body["message"] as? String ?? "", duration: 1.5, position: .center)
                                
                                if appDelegate.userLoginAccessDetails?.id != nil {
                                    self.GetApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "1", startDate: start_Date, endDate: end_Date, statusType: "0")
                                }

                            } else {
                                self.view.makeToast(body["message"] as? String ?? "", duration: 1.0, position: .center)
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
    let cancel = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)

    alertcontroller.addAction(yes)
    alertcontroller.addAction(cancel)
    present(alertcontroller, animated: true)
    

}

@objc func btnRejectDetailAction(sender: UIButton) {
   
    let alertcontroller = UIAlertController(title: "Confirmation", message: "Are you sure want to Reject this Visitor?", preferredStyle: .alert)
    let yes = UIAlertAction(title: "YES", style: .default) { _ in
        DispatchQueue.main.async {
            let obj = self.entry_Array[sender.tag]

            if ProjectUtilities.checkInternateAvailable(viewController: self) {
                let params = ["user_id": appDelegate.userLoginAccessDetails?.id ?? "",
                              "entry_id": obj.id ?? "",
                              "entry_type": "1",
                              "type": "0",
                              "status": "2",
                              "site_id": self.site_id] as [String: Any]
                
                Webservice.Authentication.visitorAprroveAndRejectApi(parameter: params) { [self] result in
                    switch result {
                    case let .success(response):
                        if let body = response.body as? [String: Any] {
                            if body["code"] as? Int ?? 0 == 200 {
                                
                                self.view.makeToast(body["message"] as? String ?? "", duration: 1.5, position: .center)
                               
                                if appDelegate.userLoginAccessDetails?.id != nil {
                                    self.GetApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "1", startDate: start_Date, endDate: end_Date, statusType: "0")
                                }

                            } else {
                                self.view.makeToast(body["message"] as? String ?? "", duration: 1.5, position: .center)
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
    let cancel = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)

    alertcontroller.addAction(yes)
    alertcontroller.addAction(cancel)
    present(alertcontroller, animated: true)
}

@objc func btnFilterViewDetailAction(sender: UIButton) {
    let obj = self.Filter_entry_Array[sender.tag]
    if let vc = UIStoryboard(name: "Visitor", bundle: nil).instantiateViewController(withIdentifier: "VisitorApprovalLogDetailVC") as? VisitorApprovalLogDetailVC {
        vc.objApproval = obj
        vc.site_Name = self.site_Name
        vc.site_id = self.site_id
//        self.navigationController?.pushViewController(vc, animated: true)
        Functions.pushToViewController(self, toVC: vc)

    }
}

@objc func btnFilterApproveDetailAction(sender: UIButton) {
    
    let alertcontroller = UIAlertController(title: "Confirmation", message: "Are you sure want to Approve this Visitor?", preferredStyle: .alert)
    let yes = UIAlertAction(title: "YES", style: .default) { _ in
        DispatchQueue.main.async {
            let obj = self.Filter_entry_Array[sender.tag]

            if ProjectUtilities.checkInternateAvailable(viewController: self) {
                let params = ["user_id": appDelegate.userLoginAccessDetails?.id ?? "",
                              "entry_id": obj.id ?? "",
                              "entry_type": "1",
                              "type": "0",
                              "status": "1",
                              "site_id": self.site_id] as [String: Any]

                Webservice.Authentication.AcceptORRejectApi(parameter: params) { [self] result in
                    switch result {
                    case let .success(response):
                        if let body = response.body as? [String: Any] {
                           
                            if body["code"] as? Int ?? 0 == 200 {
                                
                                self.view.makeToast(body["message"] as? String ?? "", duration: 1.5, position: .center)
                               
                                if appDelegate.userLoginAccessDetails?.id != nil {
                                    FilterApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "1", startDate: start_Date_Value, endDate: end_Date_Value, statusType: "0")
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
    let cancel = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)

    alertcontroller.addAction(yes)
    alertcontroller.addAction(cancel)
    present(alertcontroller, animated: true)
    

}

@objc func btnFilterRejectDetailAction(sender: UIButton) {
   
    let alertcontroller = UIAlertController(title: "Confirmation", message: "Are you sure want to Reject this Vehicle?", preferredStyle: .alert)
    let yes = UIAlertAction(title: "YES", style: .default) { _ in
        DispatchQueue.main.async {
            let obj = self.Filter_entry_Array[sender.tag]

            if ProjectUtilities.checkInternateAvailable(viewController: self) {
                let params = ["user_id": appDelegate.userLoginAccessDetails?.id ?? "",
                              "entry_id": obj.id ?? "",
                              "entry_type": "1",
                              "type": "0",
                              "status": "2",
                              "site_id": self.site_id] as [String: Any]

                Webservice.Authentication.AcceptORRejectApi(parameter: params) { [self] result in
                    switch result {
                    case let .success(response):
                        if let body = response.body as? [String: Any] {
                            if body["code"] as? Int ?? 0 == 200 {
                                
                                self.view.makeToast(body["message"] as? String ?? "", duration: 1.5, position: .center)
                               
                                if appDelegate.userLoginAccessDetails?.id != nil {
                                    FilterApproveVehicleListApi(UserID: appDelegate.userLoginAccessDetails?.id ?? "", type: "1", startDate: start_Date_Value, endDate: end_Date_Value, statusType: "0")
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
    let cancel = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)

    alertcontroller.addAction(yes)
    alertcontroller.addAction(cancel)
    present(alertcontroller, animated: true)
        }

}

extension VisitorApprovalLogVC: UIPickerViewDelegate, UIPickerViewDataSource {
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


