//
//  LiveStrengthVC.swift
//  EmployeeApp
//
//  Created by Jailove on 21/07/22.
//

import UIKit

class LiveStrengthVC: UIViewController {

    @IBOutlet weak var lblTItle: UILabel!
    @IBOutlet weak var TBLAtGateList: UITableView!
    @IBOutlet weak var viewSelectStaff: UIView!
    @IBOutlet weak var txtFieldSelectStaff: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var TBLAtSiteList: UITableView!
    @IBOutlet weak var TBLINHouseList: UITableView!
    @IBOutlet weak var TBLLiveVehiclesList: UITableView!
    @IBOutlet weak var TBLLiveVisitorsList: UITableView!

    @IBOutlet weak var heightAtGateConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightAtSiteConstriant: NSLayoutConstraint!
    @IBOutlet weak var heightINHouseConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightLiveVehiclesConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightLiveVisitorsConstraint: NSLayoutConstraint!

    var at_Gate_Array = [AtGateModel]()
    var at_Site_Array = [AtSiteModel]()
    var In_House_Array = [InHouseModel]()
    var live_Vehicles_Array = [LiveVehiclesModel]()
    var live_Visitors_Array = [LiveVisitorsModel]()

    var select_Staff_Array = [String]()
    var select_Staff_Value = ""
    var staff_ID = "0"
    var site_name = ""
    var site_ID = ""
    var count = Int()
    
    enum PickerType: String {
        case searchPicker
    }
    var currentPickerType: PickerType?
    @IBOutlet weak var lblNoDataFoundAtGate: UILabel!
    @IBOutlet weak var lblNoDataFoundAtSite: UILabel!
    @IBOutlet weak var lblNoDataFoundInHouse: UILabel!
    @IBOutlet weak var lblNoDataFoundLiveVehicles: UILabel!
    @IBOutlet weak var lblNoDataFoundLiveVisitors: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTItle.text = site_name
        select_Staff_Array = ["Employee", "Facility Service", "Admin"]
        
        viewSelectStaff.layer.cornerRadius = 10
        viewSelectStaff.layer.borderWidth = 1
        viewSelectStaff.layer.borderColor = UIColor(red: 23 / 255.0, green: 146 / 255.0, blue: 161 / 255.0, alpha: 1.0).cgColor
        btnSearch.layer.cornerRadius = 10
        staffNameFuncApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_ID, staff_id: staff_ID)
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
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnReloadAction(_ sender: Any) {
        staff_ID = "0"
        staffNameFuncApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_ID, staff_id: staff_ID)
        txtFieldSelectStaff.text = ""
    }
    
    @IBAction func btnSelectStaffAction(_ sender: Any) {
        currentPickerType = .searchPicker
        showPicker(type: .searchPicker)
        
    }
   
    @IBAction func btnSearchSelectSaffAction(_ sender: Any) {
        
        staffNameFuncApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: site_ID, staff_id: staff_ID)
    }
    
    func showPicker(type _: PickerType) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 280, height: 280)

        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 280, height: 280))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: nil, message: "Select Staff", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            let row = pickerView.selectedRow(inComponent: 0)

            if self.select_Staff_Array.count > 0 {
                let element = self.select_Staff_Array[row]
                self.select_Staff_Value = element
                if element == "Employee" {
                    self.staff_ID = "4"
                    self.txtFieldSelectStaff.text = "Employee"
                } else if element == "Facility Service" {
                    self.staff_ID = "7"
                    self.txtFieldSelectStaff.text = "Facility Service"
                } else if element == "Admin" {
                    self.staff_ID = "8"
                    self.txtFieldSelectStaff.text = "Admin"
                }
            } else { return }

        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))
        present(editRadiusAlert, animated: true)
    }
    
    @objc private func tapOnPunchInAtSite(_ sender: UIButton) {
        let obj = at_Site_Array[sender.tag]
        if let location = obj.locationPunchIn, !location.isEmpty {
            let alertController = UIAlertController(title: "Location:", message: location, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "MAPS", style: .default) { _ in
                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)), let url = URL(string: "comgooglemaps-x-callback://?q=\(location.replacingOccurrences(of: " ", with: "+"))") {
                        UIApplication.shared.open(url, options: [:])
                } else {
                    //Open in browser
                    if let urlDestination = URL(string: "http://maps.google.co.in/maps?q=(\(location.replacingOccurrences(of: " ", with: "+"))") {
                        UIApplication.shared.open(urlDestination)
                    }
                }
//                UIApplication.shared.openURL(URL(string: "http://maps.google.co.in/maps?q=(\(location)")!)
            })
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alertController.dismiss(animated: true)
            }))
            self.present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "Location:", message: "No location found!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alertController.dismiss(animated: true)
            }))
            self.present(alertController, animated: true)
        }
    }
    
    @objc private func tapOnPunchInAtGate(_ sender: UIButton) {
        let obj = at_Gate_Array[sender.tag]
        if let location = obj.locationPunchIn, !location.isEmpty {
            let alertController = UIAlertController(title: "Location:", message: location, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "MAPS", style: .default) { _ in
                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)), let url = URL(string: "comgooglemaps-x-callback://?q=\(location.replacingOccurrences(of: " ", with: "+"))") {
                        UIApplication.shared.open(url, options: [:])
                } else {
                    //Open in browser
                    if let urlDestination = URL(string: "http://maps.google.co.in/maps?q=(\(location.replacingOccurrences(of: " ", with: "+"))") {
                        UIApplication.shared.open(urlDestination)
                    }
                }
//                UIApplication.shared.openURL(URL(string: "http://maps.google.co.in/maps?q=(\(location)")!)
            })
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alertController.dismiss(animated: true)
            }))
            self.present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "Location:", message: "No location found!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alertController.dismiss(animated: true)
            }))
            self.present(alertController, animated: true)
        }
    }
    
    // MARK: - Staff Name List Api Functionality -------------------------------------------

    func staffNameFuncApi(user_id: String, site_id: String, staff_id: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": user_id, "site_id": site_id
                          , "staff_id": staff_id] as [String: Any]

            Webservice.Authentication.liveStrengthListApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {

                            self.at_Gate_Array.removeAll()
                            self.at_Site_Array.removeAll()
                            self.In_House_Array.removeAll()
                            self.live_Vehicles_Array.removeAll()
                            self.live_Visitors_Array.removeAll()

                            if let userDataObj = body["response"] as? NSDictionary {
                                
                                if let dictionary = userDataObj.value(forKey: "InGate") as? NSArray {
                                    for Dict in dictionary {
                                        let obj = AtGateModel(fromDictionary: Dict as! [String: AnyObject])
                                        self.at_Gate_Array.append(obj)
                                    }
                                    
                                    if self.at_Gate_Array.count > 0 {
                                        self.lblNoDataFoundAtGate.isHidden = true
                                        self.lblNoDataFoundAtGate.text = ""
                                    } else {
                                        self.lblNoDataFoundAtGate.isHidden = false
                                        self.lblNoDataFoundAtGate.text = "NO DATA FOUND"
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.view.layoutIfNeeded()
                                        self.TBLAtGateList.dataSource = self
                                        self.TBLAtGateList.delegate = self
                                        self.TBLAtGateList.reloadData()
                                        self.view.layoutIfNeeded()
                                        self.heightAtGateConstraint.constant = self.TBLAtGateList.contentSize.height
                                        self.view.layoutIfNeeded()
                                    }
                                }
                                
                                if let atSiteArray = userDataObj.value(forKey: "All") as? NSArray {
                                    
                                    for Dict in atSiteArray {
                                        let obj = AtSiteModel(fromDictionary: Dict as! [String: AnyObject])
                                        self.at_Site_Array.append(obj)
                                    }
                                    
                                    if self.at_Site_Array.count > 0 {
                                        self.lblNoDataFoundAtSite.isHidden = true
                                        self.lblNoDataFoundAtSite.text = ""
                                    } else {
                                        self.lblNoDataFoundAtSite.isHidden = false
                                        self.lblNoDataFoundAtSite.text = "NO DATA FOUND"
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.view.layoutIfNeeded()
                                        self.TBLAtSiteList.dataSource = self
                                        self.TBLAtSiteList.delegate = self
                                        self.TBLAtSiteList.reloadData()
                                        self.view.layoutIfNeeded()
                                        self.heightAtSiteConstriant.constant = self.TBLAtSiteList.contentSize.height
                                        self.view.layoutIfNeeded()
                                    }
                                }
                                
                                if let inHouseArray = userDataObj.value(forKey: "Inhouse") as? NSArray {
                                    
                                    for Dict in inHouseArray {
                                        let obj = InHouseModel(fromDictionary: Dict as! [String: AnyObject])
                                        self.In_House_Array.append(obj)
                                    }
                                    
                                    if self.In_House_Array.count > 0 {
                                        self.lblNoDataFoundInHouse.isHidden = true
                                        self.lblNoDataFoundInHouse.text = ""
                                    } else {
                                        self.lblNoDataFoundInHouse.isHidden = false
                                        self.lblNoDataFoundInHouse.text = "NO DATA FOUND"
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.view.layoutIfNeeded()
                                        self.TBLINHouseList.dataSource = self
                                        self.TBLINHouseList.delegate = self
                                        self.TBLINHouseList.reloadData()
                                        self.view.layoutIfNeeded()
                                        self.heightINHouseConstraint.constant = self.TBLINHouseList.contentSize.height
                                        self.view.layoutIfNeeded()
                                    }
                                }
                                if let vehiclesArray = userDataObj.value(forKey: "Vehicle") as? NSArray {
                                    
                                    for Dict in vehiclesArray {
                                        let obj = LiveVehiclesModel(fromDictionary: Dict as! [String: AnyObject])
                                        if obj.delete == "0" {
                                            self.live_Vehicles_Array.append(obj)
                                        }
                                    }
                                    
                                    if self.live_Vehicles_Array.count > 0 {
                                        self.lblNoDataFoundLiveVehicles.isHidden = true
                                        self.lblNoDataFoundLiveVehicles.text = ""
                                    } else {
                                        self.lblNoDataFoundLiveVehicles.isHidden = false
                                        self.lblNoDataFoundLiveVehicles.text = "NO DATA FOUND"
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.view.layoutIfNeeded()
                                        self.TBLLiveVehiclesList.dataSource = self
                                        self.TBLLiveVehiclesList.delegate = self
                                        self.TBLLiveVehiclesList.reloadData()
                                        self.view.layoutIfNeeded()
                                        self.heightLiveVehiclesConstraint.constant = self.TBLLiveVehiclesList.contentSize.height
                                        self.view.layoutIfNeeded()
                                    }
                                }
                                
                                if let visitorsArray = userDataObj.value(forKey: "Visitor") as? NSArray {
                                    
                                    for Dict in visitorsArray {
                                        let obj = LiveVisitorsModel(fromDictionary: Dict as! [String: AnyObject])
                                        if obj.delete == "0" {
                                            self.live_Visitors_Array.append(obj)
                                        }
                                    }
                                    
                                    if self.live_Visitors_Array.count > 0 {
                                        self.lblNoDataFoundLiveVisitors.isHidden = true
                                        self.lblNoDataFoundLiveVisitors.text = ""
                                    } else {
                                        self.lblNoDataFoundLiveVisitors.isHidden = false
                                        self.lblNoDataFoundLiveVisitors.text = "NO DATA FOUND"
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.view.layoutIfNeeded()
                                        self.TBLLiveVisitorsList.dataSource = self
                                        self.TBLLiveVisitorsList.delegate = self
                                        self.TBLLiveVisitorsList.reloadData()
                                        self.view.layoutIfNeeded()
                                        self.heightLiveVisitorsConstraint.constant = self.TBLLiveVisitorsList.contentSize.height
                                        self.view.layoutIfNeeded()
                                    }
                                }
                            }
                            
                        } else {
                            App_AlertView.shared.SimpleMessage(Text: body["message"] as? String ?? "")
                        }
                    }
                case let .fail(errorMsg):
                    self.view.makeToast(errorMsg, duration: 1.0, position: .center)
                }
            }
        }
    }
    
    @objc func tapOnRemoveVehicle(_ sender: UIButton) {
        let alert = UIAlertController(title: "Confirmation!", message: "Are you sure want to Delete this \(live_Vehicles_Array[sender.tag].id ?? "") Entry?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            if ProjectUtilities.checkInternateAvailable(viewController: self) {
                let params = ["user_id": appDelegate.userLoginAccessDetails?.id ?? "", "id": self.live_Vehicles_Array[sender.tag].id ?? ""] as [String: Any]

                Webservice.Authentication.deleteLiveVehicles(parameter: params) { result in
                    switch result {
                    case let .success(response):
                        if let body = response.body as? [String: Any] {
                            if body["message"] as? String ?? "" == "Success" {
                                self.view.makeToast("Entry Deleted!", duration: 1.0, position: .center)
                                self.staffNameFuncApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: self.site_ID, staff_id: self.staff_ID)
                            } else {
                                App_AlertView.shared.SimpleMessage(Text: body["message"] as? String ?? "")
                            }
                        }
                    case let .fail(errorMsg):
                        self.view.makeToast(errorMsg, duration: 1.0, position: .center)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .destructive))
        self.present(alert, animated: true)
    }
    
    @objc func tapOnRemoveVisitor(_ sender: UIButton) {
        let alert = UIAlertController(title: "Confirmation!", message: "Are you sure want to Delete this \(live_Visitors_Array[sender.tag].id ?? "") Entry?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            if ProjectUtilities.checkInternateAvailable(viewController: self) {
                let params = ["user_id": appDelegate.userLoginAccessDetails?.id ?? "", "id": self.live_Visitors_Array[sender.tag].id ?? ""] as [String: Any]

                Webservice.Authentication.deleteLiveVisitors(parameter: params) { result in
                    switch result {
                    case let .success(response):
                        if let body = response.body as? [String: Any] {
                            if body["message"] as? String ?? "" == "Success" {
                                self.view.makeToast("Entry Deleted!", duration: 1.0, position: .center)
                                self.staffNameFuncApi(user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: self.site_ID, staff_id: self.staff_ID)

                            } else {
                                App_AlertView.shared.SimpleMessage(Text: body["message"] as? String ?? "")
                            }
                        }
                    case let .fail(errorMsg):
                        self.view.makeToast(errorMsg, duration: 1.0, position: .center)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .destructive))
        self.present(alert, animated: true)
    }

}

extension LiveStrengthVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        guard let inputType = currentPickerType else { return 0 }
        if inputType == .searchPicker {
            return select_Staff_Array.count
        } else {
            return 0
        }
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        guard let inputType = currentPickerType else { return "" }
        if inputType == .searchPicker {
            let element = select_Staff_Array[row]
            return element
        } else {
            return ""
        }
    }
}


// MARK: - UITable View Data Source and Delegates Methods******************************

extension LiveStrengthVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
        
        if tableView == TBLAtGateList {
            return at_Gate_Array.count
        }
        if tableView == TBLAtSiteList {
            return at_Site_Array.count
        }
        if tableView == TBLINHouseList {
            return In_House_Array.count
        }
        if tableView == TBLLiveVehiclesList {
            return live_Vehicles_Array.count
        }
        if tableView == TBLLiveVisitorsList {
            return live_Visitors_Array.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == TBLAtGateList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AtGateAndAtSiteTableCell", for: indexPath) as! AtGateAndAtSiteTableCell
            let obj = at_Gate_Array[indexPath.row]
            cell.selectionStyle = .none
            count = indexPath.row + 1
            cell.lblSrNo.text = "\(count)"
            
            if indexPath.row % 2 == 0 {
                cell.viewSrNo.backgroundColor = UIColor.systemGray6
                cell.viewName.backgroundColor = UIColor.systemGray6
                cell.viewDesignation.backgroundColor = UIColor.systemGray6
                cell.viewContractorName.backgroundColor = UIColor.systemGray6
                cell.viewPunchedIn.backgroundColor = UIColor.systemGray6
    
            } else {
                cell.viewSrNo.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewName.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewDesignation.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewContractorName.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewPunchedIn.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
            }
    
            cell.lblName.text = obj.name ?? ""
            cell.lblDesignation.text = obj.designationName ?? ""
            cell.lblContractName.text = obj.facilityName ?? ""
            cell.lblPunchedIn.text = obj.punchedin ?? ""
            cell.punchedInBtn.tag = indexPath.row
            cell.punchedInBtn.addTarget(self, action: #selector(tapOnPunchInAtGate(_:)), for: .touchUpInside)
            
            return cell
        } else if tableView == TBLAtSiteList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AtGateAndAtSiteTableCell", for: indexPath) as! AtGateAndAtSiteTableCell
            let obj = at_Site_Array[indexPath.row]
            cell.selectionStyle = .none
            count = indexPath.row + 1
            cell.lblSrNo.text = "\(count)"
            
            if indexPath.row % 2 == 0 {
                cell.viewSrNo.backgroundColor = UIColor.systemGray6
                cell.viewName.backgroundColor = UIColor.systemGray6
                cell.viewDesignation.backgroundColor = UIColor.systemGray6
                cell.viewContractorName.backgroundColor = UIColor.systemGray6
                cell.viewPunchedIn.backgroundColor = UIColor.systemGray6
    
            } else {
                cell.viewSrNo.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewName.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewDesignation.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewContractorName.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewPunchedIn.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
            }
    
            if obj.name == obj.facilityName {
                cell.lblContractName.text = ""
            } else {
                cell.lblContractName.text = obj.facilityName ?? ""
            }
            
            cell.lblName.text = obj.name ?? ""
            cell.lblDesignation.text = obj.designationName ?? ""
            cell.lblPunchedIn.text = obj.punchedin ?? ""
            cell.punchedInBtn.tag = indexPath.row
            cell.punchedInBtn.addTarget(self, action: #selector(tapOnPunchInAtSite(_:)), for: .touchUpInside)
            return cell
        }
        else if tableView == TBLINHouseList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InHoueseTabelCell", for: indexPath) as! InHoueseTabelCell
            let obj = In_House_Array[indexPath.row]
            cell.selectionStyle = .none
            count = indexPath.row + 1
            cell.lblSrNo.text = "\(count)"
            cell.lblSrNo.textColor = UIColor.systemGreen
            
            if indexPath.row % 2 == 0 {
                cell.viewSrNo.backgroundColor = UIColor.systemGray6
                cell.viewUniqueID.backgroundColor = UIColor.systemGray6
                cell.viewName.backgroundColor = UIColor.systemGray6
                cell.viewVehicleNo.backgroundColor = UIColor.systemGray6
                cell.viewStatus.backgroundColor = UIColor.systemGray6
    
            } else {
                cell.viewSrNo.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewUniqueID.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewName.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewVehicleNo.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewStatus.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
            }
            
            cell.lblUniqueID.text = obj.id ?? ""
            cell.lblName.text = obj.staffName ?? ""
            cell.lblVehicleNo.text = obj.vehicleNo ?? ""
            cell.lblVehicleNo.textColor = UIColor.systemGreen
            cell.lblStatus.text = "Entered - \(obj.approvalDate ?? "")"
            cell.lblStatus.textColor = UIColor.systemGreen
            
            
            
            return cell
        } else if tableView == TBLLiveVehiclesList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InHoueseTabelCell", for: indexPath) as! InHoueseTabelCell
            let obj = live_Vehicles_Array[indexPath.row]
            cell.selectionStyle = .none
            count = indexPath.row + 1
            cell.lblSrNo.text = "\(count)"
            cell.lblSrNo.textColor = UIColor.systemGreen
            
            cell.viewStatus.backgroundColor = .white

            if indexPath.row % 2 == 0 {
                cell.viewSrNo.backgroundColor = UIColor.systemGray6
                cell.viewUniqueID.backgroundColor = UIColor.systemGray6
                cell.viewName.backgroundColor = UIColor.systemGray6
                cell.viewVehicleNo.backgroundColor = UIColor.systemGray6
    
            } else {
                cell.viewSrNo.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewUniqueID.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewName.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewVehicleNo.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
            }
            
            cell.lblUniqueID.text = obj.id ?? ""
            cell.lblName.text = obj.vehicle_number ?? ""
            cell.lblVehicleNo.text = "Entered"
            cell.lblVehicleNo.textColor = UIColor.systemGreen
            cell.lblStatus.text = obj.updated_date ?? ""
            
            cell.removeButton.tag = indexPath.row
            cell.removeButton.addTarget(self, action: #selector(tapOnRemoveVehicle(_:)), for: .touchUpInside)
            return cell
        } else if tableView == TBLLiveVisitorsList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InHoueseTabelCell", for: indexPath) as! InHoueseTabelCell
            let obj = live_Visitors_Array[indexPath.row]
            cell.selectionStyle = .none
            count = indexPath.row + 1
            cell.lblSrNo.text = "\(count)"
            cell.lblSrNo.textColor = UIColor.systemGreen
            
            cell.viewStatus.backgroundColor = .white

            if indexPath.row % 2 == 0 {
                cell.viewSrNo.backgroundColor = UIColor.systemGray6
                cell.viewUniqueID.backgroundColor = UIColor.systemGray6
                cell.viewName.backgroundColor = UIColor.systemGray6
                cell.viewVehicleNo.backgroundColor = UIColor.systemGray6
    
            } else {
                cell.viewSrNo.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewUniqueID.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewName.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
                cell.viewVehicleNo.backgroundColor = UIColor(red: 215 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
            }
            
            cell.lblUniqueID.text = obj.id ?? ""
            cell.lblName.text = obj.visitor_name ?? ""
            cell.lblVehicleNo.text = "Entered"
            cell.lblVehicleNo.textColor = UIColor.systemGreen
            cell.lblStatus.text = obj.updated_date ?? ""
            
            cell.removeButton.tag = indexPath.row
            cell.removeButton.addTarget(self, action: #selector(tapOnRemoveVisitor(_:)), for: .touchUpInside)
            return cell
        } else {
            return UITableViewCell()
        }
      
    }
    
    func tableView(_ tableView: UITableView, willDisplay _: UITableViewCell, forRowAt _: IndexPath) {
       
        if tableView == TBLAtGateList {
            DispatchQueue.main.async {
                self.heightAtGateConstraint.constant = self.TBLAtGateList.contentSize.height
            }
        } else if tableView == TBLAtSiteList {
            DispatchQueue.main.async {
                self.heightAtSiteConstriant.constant = self.TBLAtSiteList.contentSize.height
            }
        } else if tableView == TBLINHouseList {
            DispatchQueue.main.async {
                self.heightINHouseConstraint.constant = self.TBLINHouseList.contentSize.height
            }
        } else if tableView == TBLLiveVehiclesList {
            DispatchQueue.main.async {
                self.heightLiveVehiclesConstraint.constant = self.TBLLiveVehiclesList.contentSize.height
            }
        } else if tableView == TBLLiveVisitorsList {
            DispatchQueue.main.async {
                self.heightLiveVisitorsConstraint.constant = self.TBLLiveVisitorsList.contentSize.height
            }
        }
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
