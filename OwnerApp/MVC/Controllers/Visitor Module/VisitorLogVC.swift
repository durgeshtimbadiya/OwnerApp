//
//  VisitorLogVC.swift
//  EmployeeApp
//
//  Created by Jailove on 23/06/22.
//

import UIKit

class VisitorLogVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    // UIView
    @IBOutlet var viewApproval: UIView!
    @IBOutlet var viewRejected: UIView!
    @IBOutlet var viewEntered: UIView!
    @IBOutlet var viewVehicleStatus: UIView!

    // UILabel
    @IBOutlet var lblApprovalCount: UILabel!
    @IBOutlet var lblRejected: UILabel!
    @IBOutlet var lblEntered: UILabel!
    @IBOutlet var lblVehicleStatus: UILabel!

    var vehicle_Log_List_Array: NSMutableArray = []
    var vehicle_Log_filter_List_Array: NSMutableArray = []

    // Calender Click Vehicle Log Search Data Functionality//
    @IBOutlet var viewFilter: UIView!
    @IBOutlet var viewFilterDate: UIView!
    @IBOutlet var txtFieldDate: UITextField!
    @IBOutlet var statckView: UIStackView!
    @IBOutlet var heightStackviewConstraint: NSLayoutConstraint! // 115
    @IBOutlet var viewStartDate: UIView!
    @IBOutlet var viewEndDate: UIView!
    @IBOutlet var txtFieldStartDate: UITextField!
    @IBOutlet var txtFieldEndDate: UITextField!
    @IBOutlet var btnSearch: UIButton!

    var search_Filter_vehicle_Log_Array = [String]()
    var searchFilter_Value = ""
    var site_Name = ""
    var site_id = ""
    var sitePackage = ""

    enum PickerType: String {
        case searchFilterPicker
    }

    var start_Date_Value = ""
    var end_Date_Value = ""
    var isCustomDateActive: Bool = false

    var currentPickerType: PickerType?

    // MARK: - Filter Vehicle Log-------------------------

    @IBOutlet var viewFilterApproval: UIView!
    @IBOutlet var viewFilterRejected: UIView!
    @IBOutlet var viewFilterEntered: UIView!
    @IBOutlet var viewFilterVehicleStatus: UIView!

    // MARK: - Filter Vehicle Log-------------------------

    @IBOutlet var lblFilterApproval: UILabel!
    @IBOutlet var lblFilterRejected: UILabel!
    @IBOutlet var lblFilterEntered: UILabel!
    @IBOutlet var lblFilterVehicleStatus: UILabel!
    private var apiTimer = Timer()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "VISITOR APPROVAL STATUS \n\(site_Name)"
        viewApproval.dropShadowWithCornerRadius()
        viewRejected.dropShadowWithCornerRadius()
        viewEntered.dropShadowWithCornerRadius()
        viewVehicleStatus.dropShadowWithCornerRadius()

        search_Filter_vehicle_Log_Array = ["Today", "Yesterday", "Last 7 Days", "Last 30 Days", "This Month", "Last Month", "Custom Range"]

        viewFilter.isHidden = true
        viewStartDate.isHidden = true
        viewEndDate.isHidden = true

        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.heightStackviewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }

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
        if appDelegate.userLoginAccessDetails?.id != nil {
            if apiTimer.isValid {
                apiTimer.invalidate()
                apiTimer.invalidate()
            }
            apiTimer = Timer(timeInterval: 10, target: self, selector: #selector(self.updateAPIData), userInfo: nil, repeats: true)
            RunLoop.main.add(self.apiTimer, forMode: .default)
            apiTimer.fire()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        apiTimer.invalidate()
    }
    
    @objc func updateAPIData() {
        GetVehicleLogApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", start_date: start_Date_Value, end_date: end_Date_Value)
    }

    @IBAction func btnBackAction(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: -  Vehicle Log Api Functionality-------------------------------

    func GetVehicleLogApi(user_id: String, start_date: String, end_date: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": user_id, "start_date": start_date, "end_date": end_date, "site_id": site_id] as [String: Any]

            Webservice.Authentication.visitorLogApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {
                            if let dictionary = body["Logs"] as? NSDictionary {
                                if let approval = dictionary.value(forKey: "pending") as? Int {
                                    self.lblApprovalCount.text = "\(approval)"
                                    self.lblFilterApproval.text = "\(approval)"
                                }

                                if let rejected = dictionary.value(forKey: "rejected") as? Int {
                                    self.lblRejected.text = "\(rejected)"
                                    self.lblFilterRejected.text = "\(rejected)"
                                }

                                if let approved = dictionary.value(forKey: "approved") as? Int {
                                    self.lblEntered.text = "\(approved)"
                                    self.lblFilterEntered.text = "\(approved)"
                                }

                                if let exit = dictionary.value(forKey: "exit") as? Int {
                                    self.lblVehicleStatus.text = "\(exit)"
                                    self.lblFilterVehicleStatus.text = "\(exit)"
                                }
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

    @IBAction func btnApprovalForEntryAction(_: Any) {
//        let alertController = UIAlertController(title: nil, message: "Coming Soon..", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default) {
//            _ in
//        }
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
//        return
        if sitePackage != "0", let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorApprovalLogVC") as? VisitorApprovalLogVC {
            vc.start_Date = start_Date_Value
            vc.end_Date = end_Date_Value
            vc.statuss = "0"
            vc.site_Name = site_Name
            vc.site_id = site_id
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }

    @IBAction func btnRejectedAction(_: Any) {
        if sitePackage != "0", let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorRejectedLogVC") as? VisitorRejectedLogVC {
            vc.start_Date = start_Date_Value
            vc.end_Date = end_Date_Value
            vc.statuss = "2"
            vc.site_Name = site_Name
            vc.site_id = site_id
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)

        }
    }

    @IBAction func btnEnteredAction(_: Any) {
        if sitePackage != "0", let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorEnteredLogVC") as? VisitorEnteredLogVC {
            vc.start_Date = start_Date_Value
            vc.end_Date = end_Date_Value
            vc.statuss = "3"
            vc.site_Name = site_Name
            vc.site_id = site_id
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)

        }
    }

    @IBAction func btnVehicleStatusAction(_: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorVehicleStatusLogVC") as? VisitorVehicleStatusLogVC {
            vc.start_Date = start_Date_Value
            vc.end_Date = end_Date_Value
            vc.statuss = ""
            vc.site_Name = site_Name
            vc.site_id = site_id
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }

    @IBAction func btnCalenderAction(_: Any) {
        viewFilter.isHidden = false
        viewFilterDate.layer.cornerRadius = 10
        viewFilterDate.layer.borderWidth = 1
        viewFilterDate.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        btnSearch.dropShadowWithCornerRadius()
        start_Date_Value = "\(Date.getCurrentDate())"
        end_Date_Value = "\(Date.getCurrentDate())"
        txtFieldDate.text = "\(Date.getCurrentDate())"

        if appDelegate.userLoginAccessDetails?.id != nil {
            GetVehicleLogApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", start_date: "\(Date.getCurrentDate())", end_date: "\(Date.getCurrentDate())")
        }

        viewFilterApproval.dropShadowWithCornerRadius()
        viewFilterRejected.dropShadowWithCornerRadius()
        viewFilterEntered.dropShadowWithCornerRadius()
        viewFilterVehicleStatus.dropShadowWithCornerRadius()
    }

    // MARK: - Date Filter Button Action Functionality---------------------------------------

    @IBAction func btnDateFilterAction(_: Any) {
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
                    self.isCustomDateActive = false
                    self.txtFieldDate.text = "\(Date.getCurrentDate())"
                    self.start_Date_Value = "\(Date.getCurrentDate())"
                    self.end_Date_Value = "\(Date.getCurrentDate())"
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartDate.isHidden = true
                        self.viewEndDate.isHidden = true
                        self.heightStackviewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "Yesterday" {
                    self.isCustomDateActive = false
                    print("\(Date.yesterday)")
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartDate.isHidden = true
                        self.viewEndDate.isHidden = true
                        self.heightStackviewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                    self.txtFieldDate.text = self.convertDateFormater("\(Date.yesterday)")
                    self.start_Date_Value = self.convertDateFormater("\(Date.yesterday)")
                    self.end_Date_Value = self.convertDateFormater("\(Date.yesterday)")

                } else if element == "Last 7 Days" {
                    self.isCustomDateActive = false
                    self.getLast7Dates()
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartDate.isHidden = true
                        self.viewEndDate.isHidden = true
                        self.heightStackviewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }

                } else if element == "Last 30 Days" {
                    self.isCustomDateActive = false
                    self.getLast30Dates()
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartDate.isHidden = true
                        self.viewEndDate.isHidden = true
                        self.heightStackviewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "This Month" {
                    self.isCustomDateActive = false
                    let firstdate = "\(Date().startOfMonth())"
                    //  let lastdate = "\(Date().endOfMonth())"
                    self.txtFieldDate.text = "\(self.convertDateFormater(firstdate)) To \(self.convertDateFormater("\(Date.yesterday)"))"

                    self.start_Date_Value = "\(self.convertDateFormater(firstdate))"
                    self.end_Date_Value = "\(self.convertDateFormater("\(Date.yesterday)"))"

                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartDate.isHidden = true
                        self.viewEndDate.isHidden = true
                        self.heightStackviewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "Last Month" {
                    self.isCustomDateActive = false
                    let first = "\(Date().getPreviousMonth().startOfMonth())"
                    let last = "\(Date().getPreviousMonth().endOfMonth())"

                    self.txtFieldDate.text = "\(self.convertDateFormater(first)) To \(self.convertDateFormater(last))"

                    self.start_Date_Value = "\(self.convertDateFormater(first))"
                    self.end_Date_Value = "\(self.convertDateFormater(last))"

                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartDate.isHidden = true
                        self.viewEndDate.isHidden = true
                        self.heightStackviewConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "Custom Range" {
                    self.isCustomDateActive = true
                    self.txtFieldDate.text = "Custom Range"
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.heightStackviewConstraint.constant = 115
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
                        self.heightStackviewConstraint.constant = 0
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
        print(days)
        let value = days.last
        txtFieldDate.text = "\(value ?? "") To \(Date.getCurrentDate())"
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
        txtFieldDate.text = "\(value ?? "") To \(Date.getCurrentDate())"
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

    // MARK: - Search Button Action Functionality--------------------------------------

    @IBAction func btnSearchAction(_: Any) {
        if appDelegate.userLoginAccessDetails?.id != nil {
            if isCustomDateActive == true {
                if txtFieldStartDate.text == "" {
                    view.makeToast("please select start date", duration: 1.0, position: .center)
                } else if txtFieldEndDate.text == "" {
                    view.makeToast("please select end date", duration: 1.0, position: .center)
                } else {
                    GetVehicleLogApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", start_date: start_Date_Value, end_date: end_Date_Value)
                }
            } else {
                GetVehicleLogApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", start_date: start_Date_Value, end_date: end_Date_Value)
            }
        }
    }

    func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date!)
    }

    // MARK: - Filter Vehicle Log button Action ----------------------------------

    @IBAction func btnFilterApprovalAction(_: Any) {
        if sitePackage != "0", let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorApprovalLogVC") as? VisitorApprovalLogVC {
            vc.start_Date = start_Date_Value
            vc.end_Date = end_Date_Value
            vc.statuss = ""
            vc.site_Name = site_Name
            vc.site_id = site_id
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)

        }
    }

    @IBAction func btnFilterRejectedAction(_: Any) {
        if sitePackage != "0", let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorRejectedLogVC") as? VisitorRejectedLogVC {
            vc.start_Date = start_Date_Value
            vc.end_Date = end_Date_Value
            vc.statuss = "2"
            vc.site_Name = site_Name
            vc.site_id = site_id
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)

        }
    }

    @IBAction func btnFilterEntered(_: Any) {
        if sitePackage != "0", let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorEnteredLogVC") as? VisitorEnteredLogVC {
            vc.start_Date = start_Date_Value
            vc.end_Date = end_Date_Value
            vc.statuss = "3"
            vc.site_Name = site_Name
            vc.site_id = site_id
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)

        }
    }

    @IBAction func btnFilterVehicleStatusAction(_: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorVehicleStatusLogVC") as? VisitorVehicleStatusLogVC {
            vc.start_Date = start_Date_Value
            vc.end_Date = end_Date_Value
            vc.statuss = ""
            vc.site_Name = site_Name
            vc.site_id = site_id
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)

        }
    }
}

extension VisitorLogVC: UIPickerViewDelegate, UIPickerViewDataSource {
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

