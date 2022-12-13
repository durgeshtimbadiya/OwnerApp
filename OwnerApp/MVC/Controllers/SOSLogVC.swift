//
//  SOSLogVC.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 13/12/21.

import CoreLocation
import UIKit
import ProgressHUD

class SOSLogVC: UIViewController, PrLocation, UITextFieldDelegate {
    @IBOutlet var TBLSOSList: UITableView!
    @IBOutlet var viewNoDataFound: UIView!

    @IBOutlet var TBLFilterSOSList: UITableView!
    @IBOutlet var viewFilterNoDataFound: UIView!
    @IBOutlet weak var lblSiteName: UILabel!
    var site_Name = ""
    
    var sos_List_Array = [SOSListModel]()

    var sos_filter_List_Array = [SOSFilterModel]()

    var search_Filter_sos_Array = [String]()
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
    @IBOutlet var viewStartDate: UIView!
    @IBOutlet var viewEndDate: UIView!

    @IBOutlet var txtFieldStartDate: UITextField!
    @IBOutlet var txtFieldEndDate: UITextField!
    @IBOutlet var btnSearch: UIButton!
    @IBOutlet var heightConstraintStartAndEndDate: NSLayoutConstraint!

    var start_Date_Value = ""
    var end_Date_Value = ""
    var isCustomDateActive: Bool = false

    var refreshControl = UIRefreshControl()
    @IBOutlet weak var btnDownloadPDF: UIButton!
    var PDF_URL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSiteName.text = "\(site_Name):"
        LocationManagerSingleton.shared.StartStopUpdatingLocation(start: true)
        LocationManagerSingleton.shared.delegate = self

        search_Filter_sos_Array = ["Today", "Yesterday", "Last 7 Days", "Last 30 Days", "This Month", "Last Month", "Custom Range"]

        viewSearchFilter.isHidden = true
        viewStartDate.isHidden = true
        viewEndDate.isHidden = true
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.heightConstraintStartAndEndDate.constant = 0
            self.view.layoutIfNeeded()
        }
        TBLFilterSOSList.isHidden = true

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
        TBLSOSList.addSubview(refreshControl)

        if appDelegate.userLoginAccessDetails?.id != nil {
            GetSOSListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_iD)
        }
    }

    @objc func refresh(_: AnyObject) {
        viewSearchFilter.isHidden = true
        if appDelegate.userLoginAccessDetails?.id != nil {
            GetSOSListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_iD)
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
            GetSOSListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_iD)
        }
    }

    @IBAction func btnCalenderAction(_: Any) {
        viewSearchFilter.isHidden = false
        viewFilterNoDataFound.isHidden = true
        viewDate.layer.cornerRadius = 10
        viewDate.layer.borderWidth = 1
        viewDate.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        btnSearch.dropShadowWithCornerRadius()
//        btnDownloadPDF.dropShadowWithCornerRadius()
    }

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

            if self.search_Filter_sos_Array.count > 0 {
                let element = self.search_Filter_sos_Array[row]
                self.searchFilter_Value = element
                if element == "Today" {
                    self.TBLFilterSOSList.isHidden = true
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
                    self.TBLFilterSOSList.isHidden = true
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
                    self.TBLFilterSOSList.isHidden = true
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
                    self.TBLFilterSOSList.isHidden = true
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
                    self.TBLFilterSOSList.isHidden = true
                    self.isCustomDateActive = false
                    let firstdate = "\(Date().startOfMonth())"
                    //  let lastdate = "\(Date().endOfMonth())"
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
                    self.TBLFilterSOSList.isHidden = true
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
                    self.TBLFilterSOSList.isHidden = true
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

        for i in 1 ... 29 {
            let newdate = cal.date(byAdding: .day, value: -i, to: date)!
            let str = dateFormatter.string(from: newdate)
            days.append(str)
        }
        let value = days.last
        txtFieldDateFilter.text = "\(value ?? "") To \(Date.getCurrentDate())"
//        txtFieldDateFilter.text = "\(value ?? "") To \(self.convertDateFormater("\(Date.yesterday)"))"
        start_Date_Value = "\(value ?? "")"
        end_Date_Value = "\(Date.getCurrentDate())"//"\(self.convertDateFormater("\(Date.yesterday)"))"
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
    
    //MARK:- Download PDF Action Functionality--------------------->
    @IBAction func btnPDFDownloadAction(_ sender: Any) {
        guard let fileUrl = URL(string: PDF_URL) else {
            return
        }
        let theFileName = fileUrl.lastPathComponent

        if theFileName != "" {
            let galleryPath = Functions.getDirectoryPath()
            let filePath = "\(galleryPath)/\(theFileName)"
//            print(filePath) // print save path
            ProgressHUD.animationType = .circleStrokeSpin
            ProgressHUD.colorBackground = .white
            ProgressHUD.colorAnimation = AppColor.Color_SkyBlueTitle
            ProgressHUD.show("Downloading...")
//            RappleActivityIndicatorView.startAnimatingWithLabel("Downloading...")

            Functions.createDirectoryForDocs()
            let fileManager = FileManager.default

            DispatchQueue.global(qos: .background).async {
                if let url = URL(string: self.PDF_URL),
                   let urlData = NSData(contentsOf: url)
                {
                    if !fileManager.fileExists(atPath: filePath) {
                        DispatchQueue.main.async {
                            urlData.write(toFile: filePath, atomically: true)
                            ProgressHUD.dismiss()
                            print("Save successful")
                            ProgressHUD.dismiss()
                            self.dismiss(animated: true, completion: nil)
                            self.alert(title: "", mesagess: "PDF Download Successfully!")
                        }
                    }
                }
            }
        } else {
            ProgressHUD.dismiss()
            alert(title: "", mesagess: "File not available!")
        }
    }
    
    func alert(title: String, mesagess: String) {
        let alertcontroller = UIAlertController(title: title, message: mesagess, preferredStyle: .actionSheet)
        let yes = UIAlertAction(title: "OK", style: .default) { _ in
        }
        alertcontroller.addAction(yes)
        present(alertcontroller, animated: true)
    }
    

    @IBAction func btnSearchAction(_: Any) {
        if appDelegate.userLoginAccessDetails?.id != nil {
            if isCustomDateActive == true {
                if txtFieldStartDate.text == "" {
                    view.makeToast("please select start date", duration: 1.0, position: .center)
                } else if txtFieldEndDate.text == "" {
                    view.makeToast("please select end date", duration: 1.0, position: .center)
                } else {
                    GetSOSListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_iD)

//                    GetFilterSOSListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", startDate: start_Date_Value, endDate: end_Date_Value, type: "2")
                }
            } else {
                GetSOSListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_iD)

//                GetFilterSOSListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", startDate: start_Date_Value, endDate: end_Date_Value, type: "2")
            }
        }
    }

    // MARK: -  Get SOS List Api Functionality-------------------------------

    func GetSOSListApi(user_id: String, site_id: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": user_id, "site_id": site_id, "start_date": start_Date_Value, "end_date": end_Date_Value] as [String: Any]

            Webservice.Authentication.SOSLogListApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    self.sos_List_Array.removeAll()
                    if let body = response.body as? [String: Any], body["message"] as? String ?? "" == "Success", let dictionary = body["user_data"] as? [[String: Any]] {
                        for Dict in dictionary {
                            let obj = SOSListModel(fromDictionary: Dict as [String: AnyObject])
                            if obj.createdDate == "" {
                                obj.createdDate = "\(obj.sortingDate ?? "") 00:00:00 AM"
                            }
                            self.sos_List_Array.append(obj)
                        }

                        self.sos_List_Array = self.sos_List_Array.sorted(by: {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss a"// yyyy-MM-dd"
                            if let date0 = dateFormatter.date(from: $0.createdDate), let date1 = dateFormatter.date(from: $1.createdDate) {
                                return date0.compare(date1) == .orderedDescending
                            }
                            return false
                        })
                       
                    }
                    DispatchQueue.main.async {
                        self.TBLSOSList.delegate = self
                        self.TBLSOSList.dataSource = self
                        self.TBLSOSList.reloadData()
                    }
                    self.refreshControl.endRefreshing()
                    self.TBLSOSList.isHidden = self.sos_List_Array.count <= 0
                    self.viewNoDataFound.isHidden = self.sos_List_Array.count > 0
                    self.viewFilterNoDataFound.isHidden = self.sos_List_Array.count > 0
                    if self.sos_List_Array.count > 0 {
                        self.viewSearchFilter.isHidden = true
                    }
                case let .fail(errorMsg):
                    self.TBLSOSList.isHidden = true
                    self.viewNoDataFound.isHidden = false
                    print(errorMsg)
                }
            }
        }
    }

    // MARK: -  Get Filter Selfie List Api Functionality-------------------------------

    func GetFilterSOSListApi(user_id: String, startDate: String, endDate: String, type: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": user_id,
                          "start_date": startDate, "end_date": endDate, "type": type] as [String: Any]

            Webservice.Authentication.SOSFilterApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    self.sos_filter_List_Array.removeAll()

                    if let body = response.body as? [String: Any], body["message"] as? String ?? "" == "Success", let dictionary = body["patrolling_data"] as? [[String: Any]] {
                        for Dict in dictionary {
                            let obj = SOSFilterModel(fromDictionary: Dict as [String: AnyObject])
                            if obj.createdDate == "" {
                                obj.createdDate = "\(obj.sortingDate ?? "") 00:00:00 AM"
                            }
                            self.sos_filter_List_Array.append(obj)
                        }
                        
                        if let pdfData = body["pdf"] as? String {
                            self.PDF_URL = pdfData
                        }
                        
                        self.sos_filter_List_Array = self.sos_filter_List_Array.sorted(by: {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss a"// yyyy-MM-dd"
                            if let date0 = dateFormatter.date(from: $0.createdDate), let date1 = dateFormatter.date(from: $1.createdDate) {
                                return date0.compare(date1) == .orderedDescending
                            }
                            return false
                        })
                        DispatchQueue.main.async {
                            self.TBLFilterSOSList.delegate = self
                            self.TBLFilterSOSList.dataSource = self
                            self.TBLFilterSOSList.reloadData()
                        }
                    }
                    self.refreshControl.endRefreshing()
                    self.TBLFilterSOSList.isHidden = self.sos_filter_List_Array.count <= 0
                    self.viewFilterNoDataFound.isHidden = self.sos_filter_List_Array.count > 0
                case let .fail(errorMsg):
                    self.TBLFilterSOSList.isHidden = true
                    self.viewFilterNoDataFound.isHidden = false
                    print(errorMsg)
                }
            }
        }
    }
}

// MARK: - UITable View Data Source and Delegates Methods******************************

extension SOSLogVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
        if tableView == TBLSOSList {
            return sos_List_Array.count
        } else {
            return sos_filter_List_Array.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == TBLSOSList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SOSLogTableCell", for: indexPath) as! SOSLogTableCell
            let obj = sos_List_Array[indexPath.row]

            cell.selectionStyle = .none
            cell.viewCorner.dropShadowWithCornerRadius()

            if obj.type == "1" {
                cell.lblSOSName.text = "Medical Emergency"
                cell.imgView.image = UIImage(named: "Medical")
                cell.lblSOSName.isHidden = false
                cell.lblDateandTIme.isHidden = false
                cell.imgView.isHidden = false
                cell.lblnoDataFound.isHidden = true
            } else if obj.type == "2" {
                cell.lblSOSName.text = "Fire/Gas Leak Emergency"
                cell.imgView.image = UIImage(named: "fire")
                cell.lblSOSName.isHidden = false
                cell.lblDateandTIme.isHidden = false
                cell.imgView.isHidden = false
                cell.lblnoDataFound.isHidden = true
            } else if obj.type == "3" {
                cell.lblSOSName.text = "Lift Emergency"
                cell.imgView.image = UIImage(named: "lift")
                cell.lblSOSName.isHidden = false
                cell.lblDateandTIme.isHidden = false
                cell.imgView.isHidden = false
                cell.lblnoDataFound.isHidden = true
            }
            else if obj.type == "4"  {
                cell.lblSOSName.text = "Theft/Others"
                cell.imgView.image = UIImage(named: "theft")
                cell.lblSOSName.isHidden = false
                cell.lblDateandTIme.isHidden = false
                cell.imgView.isHidden = false
                cell.lblnoDataFound.isHidden = true
            } else {
                cell.lblnoDataFound.isHidden = false
                cell.lblnoDataFound.text = "No data found for \(obj.sortingDate ?? "")"
                cell.lblSOSName.isHidden = true
                cell.lblDateandTIme.isHidden = true
                cell.imgView.isHidden = true
            }

            cell.lblDateandTIme.text = obj.createdDate ?? ""
            cell.lblName.text = "Name: \(obj.name ?? "")"
            cell.lblDepartment.text = "Dept.: \(obj.designation ?? "")"

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SOSLogTableCell", for: indexPath) as! SOSLogTableCell
            let obj = sos_filter_List_Array[indexPath.row]

            cell.selectionStyle = .none
            cell.viewCorner.dropShadowWithCornerRadius()

            if obj.type == "1" {
                cell.lblSOSName.text = "Medical Emergency"
                cell.imgView.image = UIImage(named: "Medical")
                cell.lblSOSName.isHidden = false
                cell.lblDateandTIme.isHidden = false
                cell.imgView.isHidden = false
                cell.lblnoDataFound.isHidden = true
            } else if obj.type == "2" {
                cell.lblSOSName.text = "Fire/Gas Leak Emergency"
                cell.imgView.image = UIImage(named: "fire")
                cell.lblSOSName.isHidden = false
                cell.lblDateandTIme.isHidden = false
                cell.imgView.isHidden = false
                cell.lblnoDataFound.isHidden = true
            } else if obj.type == "3" {
                cell.lblSOSName.text = "Lift Emergency"
                cell.imgView.image = UIImage(named: "lift")
                cell.lblSOSName.isHidden = false
                cell.lblDateandTIme.isHidden = false
                cell.imgView.isHidden = false
                cell.lblnoDataFound.isHidden = true
            }
            else if obj.type == "4"  {
                cell.lblSOSName.text = "Theft/Others"
                cell.imgView.image = UIImage(named: "theft")
                cell.lblSOSName.isHidden = false
                cell.lblDateandTIme.isHidden = false
                cell.imgView.isHidden = false
                cell.lblnoDataFound.isHidden = true
            } else {
                cell.lblnoDataFound.isHidden = false
                cell.lblnoDataFound.text = "No data found for \(obj.sortingDate ?? "")"
                cell.lblSOSName.isHidden = true
                cell.lblDateandTIme.isHidden = true
                cell.imgView.isHidden = true
            }
            cell.lblDateandTIme.text = obj.createdDate ?? ""
            cell.lblName.text = "Name: \(obj.name ?? "")"
            cell.lblDepartment.text = "Dept.: \(obj.designation ?? "")"
            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SOSLogVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        guard let inputType = currentPickerType else { return 0 }
        if inputType == .searchFilterPicker {
            return search_Filter_sos_Array.count
        } else {
            return 0
        }
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        guard let inputType = currentPickerType else { return "" }
        if inputType == .searchFilterPicker {
            let element = search_Filter_sos_Array[row]
            return element
        } else {
            return ""
        }
    }
}
