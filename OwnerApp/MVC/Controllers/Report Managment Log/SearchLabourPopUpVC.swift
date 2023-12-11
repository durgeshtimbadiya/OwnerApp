//
//  SearchLabourPopUpVC.swift
//  EmployeeApp
//
//  Created by Jailove on 20/07/22.
//


import UIKit

class SearchLabourPopUpVC: UIViewController {
    @IBOutlet var viewSelectLabour: UIView!
    @IBOutlet var TBLSelectLabourList: UITableView!

    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnSubmit: UIButton!
    var staff_List_Array = [StaffNameModel]()

    var labour_site_iD = ""
    var labour_k_facilityMaster = ""
    var labourID = ""

    let checkedImage = UIImage(named: "select_check.png")! as UIImage
    let uncheckedImage = UIImage(named: "unselect_check.png")! as UIImage

    override func viewDidLoad() {
        super.viewDidLoad()
//        globleStaffNameList = [StaffNameModel]()
        btnCancel.round(corners: .allCorners, cornerRadius: 10)
        btnSubmit.round(corners: .allCorners, cornerRadius: 10)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        showAnimate()
    }

    // MARK: - Show Animation

    func showAnimate() {
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }

    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: { (finished: Bool) in
            if finished {
                self.view.removeFromSuperview()
            }
        })
    }

    @IBAction func btnCancelAction(_: Any) {
        removeAnimate()
    }

    @IBAction func btnSubmitAction(_: Any) {
        if staff_List_Array.count > 0 {
            NotificationCenter.default.post(name: Notification.Name("NotificationSelectedLabour"), object: globleStaffNameList)
            // globleLaboutList = self.labout_List_Array
        }
        removeAnimate()
    }
}

extension SearchLabourPopUpVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return staff_List_Array.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLabourTableCell", for: indexPath) as! SelectLabourTableCell
            if staff_List_Array.count > 0 {
                if staff_List_Array.count == globleStaffNameList.count {
                    cell.btnCheck.setImage(checkedImage, for: .normal)
                } else {
                    cell.btnCheck.setImage(uncheckedImage, for: .normal)
                }
            }
            cell.lblTitle.text = "SelectAll"
            cell.lblTitle.textAlignment = .left
            cell.btnCheck.addTarget(self, action: #selector(btnSelectMember(_:)), for: .touchUpInside)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLabourTableCell", for: indexPath) as! SelectLabourTableCell

            let brandDetail = staff_List_Array[indexPath.row]
            let isCheck = brandDetail.isCheck
            if isCheck == false {
                cell.btnCheck.setImage(uncheckedImage, for: .normal)
            } else {
                cell.btnCheck.setImage(checkedImage, for: .normal)
            }
            
            if brandDetail.name.contains("Owner") {
                cell.lblTitle.text = "\(brandDetail.name ?? "")"
            } else {
                cell.lblTitle.text = brandDetail.department.isEmpty ? "\(brandDetail.name ?? "")" : "\(brandDetail.name ?? "") (\(brandDetail.department ?? ""))"
            }
           
            cell.lblTitle.textAlignment = .left
            cell.btnCheck.addTarget(self, action: #selector(btnSelectMember(_:)), for: .touchUpInside)
            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 55
    }

    // MARK: Select and remove members

//    @objc func btnSelectMember(_ sender: UIButton) {
//        let buttonPosition: CGPoint = sender.convert(.zero, to: TBLSelectLabourList)
//        if let indexPath = TBLSelectLabourList.indexPathForRow(at: buttonPosition) {
//            if indexPath.section == 0 {
//                let isAllChecked = staff_List_Array.count == globleStaffNameList.count
//                globleStaffNameList = [StaffNameModel]()
//                for i in 0 ..< staff_List_Array.count {
//                    let detail = staff_List_Array[i]
//                    detail.isCheck = !isAllChecked
//                    staff_List_Array[i] = detail
//                    if !isAllChecked {
//                        globleStaffNameList.append(detail)
//                    }
//                }
//                TBLSelectLabourList.reloadData()
//            } else {
//                let detail = staff_List_Array[indexPath.row]
//                let cell = TBLSelectLabourList.cellForRow(at: indexPath)
//                let btnCheck: UIButton = cell?.viewWithTag(103) as! UIButton
//
//                if staff_List_Array.count == globleStaffNameList.count {
//                    let sectionIndex = IndexPath(row: 0, section: 0)
//                    let cell = TBLSelectLabourList.cellForRow(at: sectionIndex)
//                    let btnSelectAll: UIButton = cell?.viewWithTag(103) as! UIButton
//                    btnSelectAll.setImage(uncheckedImage, for: .normal)
//                   
//                    globleStaffNameList.removeAll { labout in
//                        labout.staff_id == detail.staff_id
//                    }
//                }
//                let isCheck = detail.isCheck
//
//                if isCheck == false {
//                    btnCheck.setImage(checkedImage, for: .normal)
//                    let obj = detail
//                    obj.isCheck = true
//                    globleStaffNameList.append(obj)
//
//                } else {
//                    btnCheck.setImage(uncheckedImage, for: .normal)
//                    let obj = detail
//                    obj.isCheck = false
//                    let index = staff_List_Array.firstIndex(where: { $0.staff_id == obj.staff_id }) ?? 0
//                    print(index)
//                    globleStaffNameList.removeAll { labout in
//                        labout.staff_id == detail.staff_id
//                    }
//                }
//
//                if staff_List_Array.count == globleStaffNameList.count {
//                    let sectionIndex = IndexPath(row: 0, section: 0)
//                    let cell = TBLSelectLabourList.cellForRow(at: sectionIndex)
//                    let btnSelectAll: UIButton = cell?.viewWithTag(103) as! UIButton
//                    btnSelectAll.setImage(checkedImage, for: .normal)
//                }
//            }
//        }
        
    // MARK: Select and remove members
    
    @objc func btnSelectMember(_ sender: UIButton) {
        let buttonPosition: CGPoint = sender.convert(.zero, to: TBLSelectLabourList)
        if let indexPath = TBLSelectLabourList.indexPathForRow(at: buttonPosition)  {
            if indexPath.section == 0 {
                let isAllChecked = staff_List_Array.count == globleStaffNameList.count
                globleStaffNameList = [StaffNameModel]()
                for i in 0 ..< staff_List_Array.count {
                    let detail = staff_List_Array[i]
                    detail.isCheck = !isAllChecked
                    staff_List_Array[i] = detail
                    if !isAllChecked {
                        globleStaffNameList.append(detail)
                    }
                }
                TBLSelectLabourList.reloadData()
            } else {
                let detail = staff_List_Array[indexPath.row]
                if let cell = TBLSelectLabourList.cellForRow(at: indexPath) as? SelectLabourTableCell {
                    
                    if staff_List_Array.count == globleStaffNameList.count {
                        let sectionIndex = IndexPath(row: 0, section: 0)
                        let cell = TBLSelectLabourList.cellForRow(at: sectionIndex)
                        let btnSelectAll: UIButton = cell?.viewWithTag(103) as! UIButton
                        btnSelectAll.setImage(uncheckedImage, for: .normal)
                        
                        globleStaffNameList.removeAll { labout in
                            labout.staff_id == detail.staff_id
                        }
                    }
                    let isCheck = detail.isCheck
                    
                    if isCheck == false {
                        cell.btnCheck.setImage(checkedImage, for: .normal)
                        let obj = detail
                        obj.isCheck = true
                        globleStaffNameList.append(obj)
                        
                    } else {
                        cell.btnCheck.setImage(uncheckedImage, for: .normal)
                        let obj = detail
                        obj.isCheck = false
                        let index = staff_List_Array.firstIndex(where: { $0.staff_id == obj.staff_id }) ?? 0
                        print(index)
                        globleStaffNameList.removeAll { labout in
                            labout.staff_id == detail.staff_id
                        }
                    }
                    
                    if staff_List_Array.count == globleStaffNameList.count {
                        let sectionIndex = IndexPath(row: 0, section: 0)
                        if let cell1 = TBLSelectLabourList.cellForRow(at: sectionIndex) as? SelectLabourTableCell {
                            cell1.btnCheck.setImage(checkedImage, for: .normal)
                        }
                    }
                }
            }
        }
        
    }
}
