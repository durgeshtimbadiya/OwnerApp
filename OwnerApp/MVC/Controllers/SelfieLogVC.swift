//
//  SelfieLogVC.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 13/12/21.
//

import CoreLocation
import UIKit

class SelfieLogVC: UIViewController, PrLocation, UITextFieldDelegate {
    @IBOutlet var TBLSelfieList: UITableView!
    @IBOutlet var viewNoDataFound: UIView!

    @IBOutlet var TBLFilterSelfieList: UITableView!
    @IBOutlet var viewFilterNoDataFound: UIView!
    @IBOutlet weak var lblSiteName: UILabel!
    var site_Name = ""
    var selfie_List_Array = [SelfieListModel]()

    var selfie_filter_List_Array = [SelfieLogListModel]()

    var search_Filter_selfie_Array = [String]()
    var searchFilter_Value = ""

    var company_iD = ""
    var site_iD = ""
    var count = Int()

    // Picker
    enum PickerType: String {
        case searchFilterPicker
    }

    var currentPickerType: PickerType?
    // ____________________________________________//
    @IBOutlet var viewSearchFilter: UIView!
    @IBOutlet var viewDate: UIView!
    @IBOutlet var txtFieldDateFilter: UITextField!
    @IBOutlet var heightConstraintStartAndEndDate: NSLayoutConstraint!

    @IBOutlet var viewStartDate: UIView!
    @IBOutlet var viewEndDate: UIView!

    @IBOutlet var txtFieldStartDate: UITextField!
    @IBOutlet var txtFieldEndDate: UITextField!

    @IBOutlet var btnSearch: UIButton!

    var start_Date_Value = ""
    var end_Date_Value = ""
    var isCustomDateActive: Bool = false

    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        lblSiteName.text = "\(site_Name):"
        LocationManagerSingleton.shared.StartStopUpdatingLocation(start: true)
        LocationManagerSingleton.shared.delegate = self

        search_Filter_selfie_Array = ["Today", "Yesterday", "Last 7 Days", "Last 30 Days", "This Month", "Last Month", "Custom Range"]

        viewSearchFilter.isHidden = true
        viewStartDate.isHidden = true
        viewEndDate.isHidden = true
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.heightConstraintStartAndEndDate.constant = 0
            self.view.layoutIfNeeded()
        }
        TBLFilterSelfieList.isHidden = true

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
        TBLSelfieList.addSubview(refreshControl)

        if appDelegate.userLoginAccessDetails?.id != nil {
            GetSelfieListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_iD)
        }
    }

    @objc func refresh(_: AnyObject) {
        viewSearchFilter.isHidden = true
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

    @IBAction func btnBackAction(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnReloadAction(_: Any) {
        viewSearchFilter.isHidden = true
        if appDelegate.userLoginAccessDetails?.id != nil {
            GetSelfieListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_iD)
        }
    }

    @IBAction func btnCalenderAction(_: Any) {
        viewSearchFilter.isHidden = false
        viewFilterNoDataFound.isHidden = true
        viewDate.layer.cornerRadius = 10
        viewDate.layer.borderWidth = 1
        viewDate.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        btnSearch.dropShadowWithCornerRadius()
    }

    @IBAction func btnFilterDateAction(_: Any) {
        currentPickerType = .searchFilterPicker
        showPicker(type: .searchFilterPicker)
    }

    // MARK: - Search button Action Functionality------------------------------

    @IBAction func btnSearchAction(_: Any) {
        if appDelegate.userLoginAccessDetails?.id != nil {
            if isCustomDateActive == true {
                if txtFieldStartDate.text == "" {
                    view.makeToast("please select start date", duration: 1.0, position: .center)
                } else if txtFieldEndDate.text == "" {
                    view.makeToast("please select end date", duration: 1.0, position: .center)
                } else {
                    GetFilterSelfieListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", type: "2", startDate: start_Date_Value, endDate: end_Date_Value)
                }
            } else {
                GetFilterSelfieListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", type: "2", startDate: start_Date_Value, endDate: end_Date_Value)
            }
        }
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

            if self.search_Filter_selfie_Array.count > 0 {
                let element = self.search_Filter_selfie_Array[row]
                self.searchFilter_Value = element
                if element == "Today" {
                    self.TBLFilterSelfieList.isHidden = true
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
                    self.TBLFilterSelfieList.isHidden = true
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
                    self.TBLFilterSelfieList.isHidden = true
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
                    self.TBLFilterSelfieList.isHidden = true
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
                    self.TBLFilterSelfieList.isHidden = true
                    self.isCustomDateActive = false
                    
                    let dates = Constant.getThisMonth()
                    self.txtFieldDateFilter.text = "\(dates.0) To \(dates.1)"

                    self.start_Date_Value = dates.0
                    self.end_Date_Value = dates.1

                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartDate.isHidden = true
                        self.viewEndDate.isHidden = true
                        self.heightConstraintStartAndEndDate.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "Last Month" {
                    self.TBLFilterSelfieList.isHidden = true
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
                    self.TBLFilterSelfieList.isHidden = true
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

                    self.txtFieldEndDate.datePicker(target: self,
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

        for i in 1 ... 6 {
            let newdate = cal.date(byAdding: .day, value: -i, to: date)!
            let str = dateFormatter.string(from: newdate)
            days.append(str)
        }
        let value = days.last
//        txtFieldDateFilter.text = "\(value ?? "") To \(Date.getCurrentDate())"
//        start_Date_Value = "\(value ?? "")"
//        end_Date_Value = "\(Date.getCurrentDate())"
        txtFieldDateFilter.text = "\(value ?? "") To \(self.convertDateFormater("\(Date.yesterday)"))"
        start_Date_Value = "\(value ?? "")"
        end_Date_Value = "\(self.convertDateFormater("\(Date.yesterday)"))"
    }

    func getLast30Dates() {
        let cal = Calendar.current
        let date = cal.startOfDay(for: Date())
        var days = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        for i in 1 ... 30 {
            let newdate = cal.date(byAdding: .day, value: -i, to: date)!
            let str = dateFormatter.string(from: newdate)
            days.append(str)
        }
        let value = days.last
//        txtFieldDateFilter.text = "\(value ?? "") To \(Date.getCurrentDate())"
//        start_Date_Value = "\(value ?? "")"
//        end_Date_Value = "\(Date.getCurrentDate())"
        txtFieldDateFilter.text = "\(value ?? "") To \(self.convertDateFormater("\(Date.yesterday)"))"
        start_Date_Value = "\(value ?? "")"
        end_Date_Value = "\(self.convertDateFormater("\(Date.yesterday)"))"
    }

    @objc
    func startDoneAction() {
        if let datePickerView = txtFieldStartDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: datePickerView.date)
            txtFieldStartDate.text = dateString
            start_Date_Value = dateString
            txtFieldStartDate.resignFirstResponder()
        }
    }

    @objc
    func startCancelAction() {
        txtFieldStartDate.resignFirstResponder()
    }

    @objc
    func endDoneAction() {
        if let datePickerView = txtFieldEndDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: datePickerView.date)
            txtFieldEndDate.text = dateString
            end_Date_Value = dateString
            print(datePickerView.date)
            print(dateString)
            txtFieldEndDate.resignFirstResponder()
        }
    }

    @objc
    func endCancelAction() {
        txtFieldEndDate.resignFirstResponder()
    }

    func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date!)
    }

    // MARK: -  Get Selfie List Api Functionality-------------------------------

    func GetSelfieListApi(user_id: String, site_id: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": user_id, "site_id": site_id] as [String: Any]

            Webservice.Authentication.SelfieListApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    self.selfie_List_Array.removeAll()

                    if let body = response.body as? [String: Any], body["message"] as? String ?? "" == "Success", let dictionary = body["labor_data"] as? [[String: Any]] {
                        var sort = 0
                        for Dict in dictionary {
                            let obj = SelfieListModel(fromDictionary: Dict as [String: AnyObject])
                            obj.sortingIndex = sort
                            if obj.createdDate == "" {
                                obj.createdDate = "\(obj.shorting_date ?? "") 00:00:00 AM"
                            }
                            self.selfie_List_Array.append(obj)
                            sort = sort + 1
                        }
//                                self.selfie_filter_List_Array = self.selfie_filter_List_Array.sorted(by: { $0.sortingIndex > $1.sortingIndex })
                        self.selfie_List_Array = self.selfie_List_Array.sorted(by: {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss a"// yyyy-MM-dd"
                            if let date0 = dateFormatter.date(from: $0.createdDate), let date1 = dateFormatter.date(from: $1.createdDate) {
                                return date0.compare(date1) == .orderedDescending
                            }
                            return false
                        })
                        DispatchQueue.main.async {
                            self.TBLSelfieList.delegate = self
                            self.TBLSelfieList.dataSource = self
                            self.TBLSelfieList.reloadData()
                        }
                 
                    }
                    self.TBLSelfieList.isHidden = self.selfie_List_Array.count <= 0
                    self.viewNoDataFound.isHidden = self.selfie_List_Array.count > 0
                    self.refreshControl.endRefreshing()

                case let .fail(errorMsg):
                    self.TBLSelfieList.isHidden = true
                    self.viewNoDataFound.isHidden = false
                    print(errorMsg)
                }
            }
        }
    }

    // MARK: -  Get Filter Selfie List Api Functionality-------------------------------

    func GetFilterSelfieListApi(user_id: String, type: String, startDate: String, endDate: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": user_id, "type": type,
                          "start_date": startDate, "end_date": endDate] as [String: Any]

            Webservice.Authentication.AttendanceFilterApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    self.selfie_filter_List_Array.removeAll()

                    if let body = response.body as? [String: Any], body["message"] as? String ?? "" == "Success", let dictionary = body["patrolling_data"] as? [[String: Any]] {
                        var sort = 0
                        for Dict in dictionary {
                            let obj = SelfieLogListModel(fromDictionary: Dict as [String: AnyObject])
                            obj.sortingIndex = sort
                            if obj.createdDate == "" {
                                obj.createdDate = "\(obj.shorting_date ?? "") 00:00:00 AM"
                            }
                            self.selfie_filter_List_Array.append(obj)
                            sort = sort + 1
                        }
//                                self.selfie_filter_List_Array = self.selfie_filter_List_Array.sorted(by: { $0.sortingIndex > $1.sortingIndex })
                        self.selfie_filter_List_Array = self.selfie_filter_List_Array.sorted(by: {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss a"// yyyy-MM-dd"
                            if let date0 = dateFormatter.date(from: $0.createdDate), let date1 = dateFormatter.date(from: $1.createdDate) {
                                return date0.compare(date1) == .orderedDescending
                            }
                            return false
                        })
                        DispatchQueue.main.async {
                            self.TBLFilterSelfieList.delegate = self
                            self.TBLFilterSelfieList.dataSource = self
                            self.TBLFilterSelfieList.reloadData()
                        }
                    }
                    self.TBLFilterSelfieList.isHidden = self.selfie_filter_List_Array.count <= 0
                    self.viewFilterNoDataFound.isHidden = self.selfie_filter_List_Array.count > 0
                    self.refreshControl.endRefreshing()

                case let .fail(errorMsg):
                    self.TBLFilterSelfieList.isHidden = true
                    self.viewFilterNoDataFound.isHidden = false
                    print(errorMsg)
                }
            }
        }
    }
}

// MARK: - UITable View Data Source and Delegates Methods******************************

extension SelfieLogVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
        if tableView == TBLSelfieList {
            return selfie_List_Array.count
        } else {
            return selfie_filter_List_Array.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == TBLSelfieList {
            let obj = selfie_List_Array[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: obj.address == "" ? "SelfieNoDataTableCell" : "SelfieTableCell", for: indexPath) as! SelfieTableCell

            cell.selectionStyle = .none
            cell.viewCount.layer.cornerRadius = 10
            cell.viewBig.layer.cornerRadius = 10
            count = indexPath.row + 1

            if cell.lblCount != nil {
                cell.lblCount.text = "\(count)"
            }

            if cell.imgVIew != nil {
                DispatchQueue.main.async {
                    self.view.layoutIfNeeded()
                    cell.imgVIew.round(corners: [.topLeft, .topRight], cornerRadius: 10)
                    self.view.layoutIfNeeded()
                }
                if obj.selfie != "" {
                    cell.imgVIew.sd_setImage(with: URL(string: obj.selfie ?? ""), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached,completed: nil)
                }
            }
            if cell.lblDate != nil {
                cell.lblDate.text = obj.createdDate ?? ""
            }
            if obj.address != "" {
                cell.lblLocation.text = obj.address ?? ""
            } else {
                cell.lblLocation.text = "No Data Found for: \(obj.shorting_date ?? "No date")"
            }
            return cell
        } else {
            
            let obj = selfie_filter_List_Array[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: obj.address == "" ? "SelfieNoDataTableCell" : "SelfieTableCell", for: indexPath) as! SelfieTableCell

            cell.selectionStyle = .none
            cell.viewCount.layer.cornerRadius = 10
            cell.viewBig.layer.cornerRadius = 10
            count = indexPath.row + 1

            if cell.lblCount != nil {
                cell.lblCount.text = "\(count)"
            }

            if cell.imgVIew != nil {
                DispatchQueue.main.async {
                    self.view.layoutIfNeeded()
                    cell.imgVIew.round(corners: [.topLeft, .topRight], cornerRadius: 10)
                    self.view.layoutIfNeeded()
                }
                if obj.selfie != "" {
                    cell.imgVIew.sd_setImage(with: URL(string: obj.selfie ?? ""), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached,completed: nil)
                }
            }
            if cell.lblDate != nil {
                cell.lblDate.text = obj.createdDate ?? ""
            }
            if obj.address != "" {
                cell.lblLocation.text = obj.address ?? ""
            } else {
                cell.lblLocation.text = "No Data Found for: \(obj.shorting_date ?? "No date")"
            }
            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SelfieLogVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        guard let inputType = currentPickerType else { return 0 }
        if inputType == .searchFilterPicker {
            return search_Filter_selfie_Array.count
        } else {
            return 0
        }
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        guard let inputType = currentPickerType else { return "" }
        if inputType == .searchFilterPicker {
            let element = search_Filter_selfie_Array[row]
            return element
        } else {
            return ""
        }
    }
}
