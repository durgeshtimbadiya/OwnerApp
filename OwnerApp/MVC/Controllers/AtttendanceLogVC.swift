
import CoreLocation
import UIKit
import ProgressHUD

class AtttendanceLogVC: UIViewController, PrLocation, UITextFieldDelegate {
    @IBOutlet var TBLAttendanceList: UITableView!
    @IBOutlet var searchFilterTBLAttendanceList: UITableView!
    @IBOutlet weak var lblSiteName: UILabel!
    var attendance_List_Array: NSMutableArray = []
    var attendance_filter_List_Array: NSMutableArray = []

    var search_Filter_attendance_Array = [String]()
    var searchFilter_Value = ""

    @IBOutlet var viewNoDataFound: UIView!
    @IBOutlet var viewFilterNoDataFound: UIView!

    var company_iD = ""
    var site_iD = ""
    var count = Int()
    var site_Name = ""
    // Picker
    enum PickerType: String {
        case searchFilterPicker
    }

    var currentPickerType: PickerType?
    @IBOutlet var vieSearchFilter: UIView!
    @IBOutlet var viewDate: UIView!
    @IBOutlet var txtFieldDateFilter: UITextField!

    @IBOutlet var btnSearch: UIButton!

    @IBOutlet var viewStartDate: UIView!
    @IBOutlet var viewEndDate: UIView!

    @IBOutlet var txtFieldStartDate: UITextField!
    @IBOutlet var txFieldEndDate: UITextField!

    @IBOutlet var heightConstraintStartAndEndDate: NSLayoutConstraint!
    var start_Date_Value = ""
    var end_Date_Value = ""
    var isCustomDateActive: Bool = false

    var refreshControl = UIRefreshControl()
    @IBOutlet weak var btnDownloadPDF: UIButton!
    var pdf_URL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSiteName.text = "\(site_Name):"
        search_Filter_attendance_Array = ["Today", "Yesterday", "Last 7 Days", "Last 30 Days", "This Month", "Last Month", "Custom Range"]

        vieSearchFilter.isHidden = true
        viewStartDate.isHidden = true
        viewEndDate.isHidden = true
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.heightConstraintStartAndEndDate.constant = 0
            self.view.layoutIfNeeded()
        }

        searchFilterTBLAttendanceList.isHidden = true
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
        TBLAttendanceList.addSubview(refreshControl)

        if appDelegate.userLoginAccessDetails?.id != nil {
            GetAttendanceListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_iD)
        }
    }

    @objc func refresh(_: AnyObject) {
        vieSearchFilter.isHidden = true
        if appDelegate.userLoginAccessDetails?.id != nil {
            GetAttendanceListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_iD)
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
        vieSearchFilter.isHidden = true
        if appDelegate.userLoginAccessDetails?.id != nil {
            GetAttendanceListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_iD)
        }
    }

    @IBAction func btnCalenderClickAction(_: Any) {
        vieSearchFilter.isHidden = false
        viewFilterNoDataFound.isHidden = true
        viewDate.layer.cornerRadius = 10
        viewDate.layer.borderWidth = 1
        viewDate.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        btnSearch.dropShadowWithCornerRadius()
        btnDownloadPDF.dropShadowWithCornerRadius()
    }

    @IBAction func btnFilterDateAction(_: Any) {
        currentPickerType = .searchFilterPicker
        showPicker(type: .searchFilterPicker)
    }

    @IBAction func btnSearchAction(_: Any) {
        if appDelegate.userLoginAccessDetails?.id != nil {
            if isCustomDateActive == true {
                if txtFieldStartDate.text == "" {
                    view.makeToast("please select start date", duration: 1.0, position: .center)
                } else if txFieldEndDate.text == "" {
                    view.makeToast("please select end date", duration: 1.0, position: .center)
                } else {
                    GetFilterAttendanceListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", type: "1", startDate: start_Date_Value, endDate: end_Date_Value)
                }
            } else {
                GetFilterAttendanceListApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", type: "1", startDate: start_Date_Value, endDate: end_Date_Value)
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

            if self.search_Filter_attendance_Array.count > 0 {
                let element = self.search_Filter_attendance_Array[row]
                self.searchFilter_Value = element
                if element == "Today" {
                    self.searchFilterTBLAttendanceList.isHidden = true
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
                    self.searchFilterTBLAttendanceList.isHidden = true
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
                    self.searchFilterTBLAttendanceList.isHidden = true
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
                    self.searchFilterTBLAttendanceList.isHidden = true
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
                    self.searchFilterTBLAttendanceList.isHidden = true
                    self.isCustomDateActive = false
                    let firstdate = "\(Date().startOfMonth())"
                    let lastdate = "\(Date().endOfMonth())"
                    self.txtFieldDateFilter.text = "\(self.convertDateFormater(firstdate)) To \(self.convertDateFormater(lastdate))"

                    self.start_Date_Value = "\(self.convertDateFormater(firstdate))"
                    self.end_Date_Value = "\(self.convertDateFormater(lastdate))"

                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.viewStartDate.isHidden = true
                        self.viewEndDate.isHidden = true
                        self.heightConstraintStartAndEndDate.constant = 0
                        self.view.layoutIfNeeded()
                    }
                } else if element == "Last Month" {
                    self.searchFilterTBLAttendanceList.isHidden = true
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
                    self.searchFilterTBLAttendanceList.isHidden = true
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

    // MARK: -  Get Attendance List Api Functionality-------------------------------

    func GetAttendanceListApi(user_id: String, site_id: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": user_id, "site_id": site_id] as [String: Any]

            Webservice.Authentication.AttendanceListApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {
                            self.attendance_List_Array.removeAllObjects()

                            if let dictionary = body["site_data"] as? [[String: Any]] {
                                self.refreshControl.endRefreshing()

                                self.TBLAttendanceList.isHidden = false
                                self.viewNoDataFound.isHidden = true

                                for Dict in dictionary {
                                    let obj = AttendanceListModel(fromDictionary: Dict as [String: AnyObject])
                                    self.attendance_List_Array.add(obj)
                                }

                                DispatchQueue.main.async {
                                    self.TBLAttendanceList.delegate = self
                                    self.TBLAttendanceList.dataSource = self
                                    self.TBLAttendanceList.reloadData()
                                }
                            }

                        } else {
                            self.TBLAttendanceList.isHidden = true
                            self.viewNoDataFound.isHidden = false
                        }
                    }
                case let .fail(errorMsg):
                    self.TBLAttendanceList.isHidden = true
                    self.viewNoDataFound.isHidden = false
                    print(errorMsg)
                }
            }
        }
    }

    // MARK: -  Get Filter attendance List Api Functionality-------------------------------

    func GetFilterAttendanceListApi(user_id: String, type: String, startDate: String, endDate: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": user_id, "type": type,
                          "start_date": startDate, "end_date": endDate] as [String: Any]
            
            Webservice.Authentication.AttendanceFilterApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {
                            self.attendance_filter_List_Array.removeAllObjects()

                            if let dictionary = body["patrolling_data"] as? [[String: Any]] {
                                self.searchFilterTBLAttendanceList.isHidden = false
                                self.viewFilterNoDataFound.isHidden = true

                                for Dict in dictionary {
                                    let obj = AttendanceListModel(fromDictionary: Dict as [String: AnyObject])
                                    self.attendance_filter_List_Array.add(obj)
                                }
                                
                                if let pdfData = body["pdf"] as? String {
                                    self.pdf_URL = pdfData
                                }

                                DispatchQueue.main.async {
                                    self.searchFilterTBLAttendanceList.delegate = self
                                    self.searchFilterTBLAttendanceList.dataSource = self
                                    self.searchFilterTBLAttendanceList.reloadData()
                                }
                            }

                        } else {
                            self.searchFilterTBLAttendanceList.isHidden = true
                            self.viewFilterNoDataFound.isHidden = false
                        }
                    }
                case let .fail(errorMsg):
                    self.searchFilterTBLAttendanceList.isHidden = true
                    self.viewFilterNoDataFound.isHidden = false
                    print(errorMsg)
                }
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
   
    
    //MARK:- Download PDF Action Functionality--------------->
    @IBAction func btnDownloadPDFAction(_ sender: Any) {
        guard let fileUrl = URL(string: pdf_URL) else {
            return
        }
        let theFileName = fileUrl.lastPathComponent

        if theFileName != "" {
            let galleryPath = Functions.getDirectoryPath()
            let filePath = "\(galleryPath)/\(theFileName)"
            print(filePath) // print save path
            
            ProgressHUD.animationType = .circleStrokeSpin
            ProgressHUD.colorBackground = .white
            ProgressHUD.colorAnimation = AppColor.Color_SkyBlueTitle
            ProgressHUD.show("Downloading...")
            Functions.createDirectoryForDocs()
            let fileManager = FileManager.default

            DispatchQueue.global(qos: .background).async {
                if let url = URL(string: self.pdf_URL),
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
    
}

// MARK: - UITable View Data Source and Delegates Methods******************************

extension AtttendanceLogVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
        if tableView == TBLAttendanceList {
            return attendance_List_Array.count
        } else {
            return attendance_filter_List_Array.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == TBLAttendanceList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttendanceLogTableCell", for: indexPath) as! AttendanceLogTableCell

            let obj = attendance_List_Array.reverseObjectEnumerator().allObjects[indexPath.row] as! AttendanceListModel

            cell.selectionStyle = .none
            count = indexPath.row + 1
            cell.lblSrCount.text = "\(count)"
           
            cell.lblPunchINDataTime.text = "\(obj.punchInDate ?? "")\n \(obj.punchInTime ?? "")"
            cell.lblPunchINDataTime.textColor = UIColor.black
            cell.lblPunchOutStatus.text = "\(obj.punchOutDate ?? "")\n \(obj.punchOutTime ?? "")"
            cell.lblPunchOutStatus.textColor = UIColor.black
            cell.lblTotalHour.text = "\(obj.totalWorked ?? "")"
            cell.lblTotalHour.textColor = UIColor.black

            if indexPath.row % 2 == 0 {
                cell.viewSrNo.backgroundColor = UIColor.white
                cell.viewPunchIN.backgroundColor = UIColor.white
                cell.viewPunchOut.backgroundColor = UIColor.white
                cell.viewTotalHour.backgroundColor = UIColor.white
            } else {
                cell.viewSrNo.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewPunchIN.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewPunchOut.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewTotalHour.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
            }

            if obj.type == "" {
                cell.lblPunchINDataTime.text = "Not Punched In"
                cell.lblPunchINDataTime.textColor = .red
                cell.lblPunchOutStatus.text = "Not Punched Out"
                cell.lblPunchOutStatus.textColor = .red
                cell.lblTotalHour.text = "Nil"
                cell.lblTotalHour.textColor = .red
            } else if obj.type == "1" {
                cell.lblPunchOutStatus.text = "Pending"
                cell.lblPunchOutStatus.textColor = .red
            } else {
                cell.lblPunchINDataTime.textColor = .black
                cell.lblPunchOutStatus.textColor = .black
                cell.lblTotalHour.textColor = UIColor.black
                cell.lblPunchINDataTime.text = "\(obj.punchInDate ?? "")\n \(obj.punchInTime ?? "")"
                cell.lblPunchOutStatus.text = "\(obj.punchOutDate ?? "")\n \(obj.punchOutTime ?? "")"
                cell.lblTotalHour.text = "\(obj.totalWorked ?? "")"
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttendanceLogTableCell", for: indexPath) as! AttendanceLogTableCell

            let obj = attendance_filter_List_Array.reverseObjectEnumerator().allObjects[indexPath.row] as! AttendanceListModel

            cell.selectionStyle = .none
            count = indexPath.row + 1
            cell.lblSrCount.text = "\(count)"
            
            cell.lblPunchINDataTime.text = "\(obj.punchInDate ?? "")\n \(obj.punchInTime ?? "")"
            cell.lblPunchINDataTime.textColor = UIColor.black
            cell.lblPunchOutStatus.text = "\(obj.punchOutDate ?? "")\n \(obj.punchhOutTime ?? "")"
            cell.lblPunchOutStatus.textColor = UIColor.black
            cell.lblTotalHour.text = "\(obj.totalWorked ?? "")"
            cell.lblTotalHour.textColor = UIColor.black

            if indexPath.row % 2 == 0 {
                cell.viewSrNo.backgroundColor = UIColor.white
                cell.viewPunchIN.backgroundColor = UIColor.white
                cell.viewPunchOut.backgroundColor = UIColor.white
                cell.viewTotalHour.backgroundColor = UIColor.white
            } else {
                cell.viewSrNo.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewPunchIN.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewPunchOut.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewTotalHour.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
            }
            
            if obj.punchInTime == "" {
                cell.lblPunchINDataTime.text = "Pending"
                cell.lblPunchINDataTime.textColor = .red
            } else if obj.punchhOutTime == "" {
                cell.lblPunchOutStatus.text = "Pending"
                cell.lblPunchOutStatus.textColor = .red
            }

            if obj.type == "1" {
                cell.lblPunchOutStatus.text = "Pending"
                cell.lblPunchOutStatus.textColor = .red
            }
            
            if obj.type == "" {
                cell.lblPunchINDataTime.text = "Not Punched In"
                cell.lblPunchINDataTime.textColor = .red
                cell.lblPunchOutStatus.text = "Not Punched Out"
                cell.lblPunchOutStatus.textColor = .red
                cell.lblTotalHour.text = "Nil"
                cell.lblTotalHour.textColor = .red
            }
            

            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension AtttendanceLogVC: UIPickerViewDelegate, UIPickerViewDataSource {
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
