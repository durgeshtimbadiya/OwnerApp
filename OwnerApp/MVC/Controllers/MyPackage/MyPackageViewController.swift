//
//  MyPackageViewController.swift
//  OwnerApp
//
//  Created by Durgesh on 17/07/23.
//

import UIKit

class MyPackageViewController: UIViewController {
    var site_ID = ""
    var siteName = ""
    var sitePackage = ""
    var siteUpPackage = ""

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paidButton: UIButton!

    private var myPackages = [MyPackageModel]()
    private var isGoldSelected = true
    private var isPayNow = false
    private var packageLabel = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        subTitleLabel.text = siteName
        self.paidButton.setTitle("Pay and Upgrade Package", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyPackages()
    }

    @IBAction func tapOnHomeButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapOnPayButton(_ sender: UIButton) {
        if !isPayNow {
            self.sitePackage = "111"
            self.paidButton.setTitle("Pay Now", for: .normal)
            isPayNow = true
            self.tableView.reloadData()
        } else {
            self.payNowAPI()
        }
    }
    
    private func getMyPackages() {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": appDelegate.userLoginAccessDetails?.id ?? "", "site_id": site_ID] as [String: Any]
            Webservice.Authentication.getMyPackages(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        var myPackageModel = MyPackageModel(body)
                        if let lastPackage = body["last_package"] as? [String: Any], (self.sitePackage == "0" || self.sitePackage == "111") {
                            self.view.makeToast(body["message"] as? String ?? "", duration: 1.0, position: .center)
                            myPackageModel.current_package = CurrentPackageModel(lastPackage)
                            myPackageModel.current_package.platinum_package = myPackageModel.platinum_package
                            myPackageModel.current_package.gold_package = myPackageModel.gold_package
                            self.packageLabel = body["message"] as? String ?? "" //1=platinum , 2=gold
                            self.myPackages.append(myPackageModel)
                            self.tableView.reloadData()
                        } else if body["code"] as? Int ?? 0 == 200 {
                            self.myPackages.removeAll()
                            self.myPackages.append(myPackageModel)
                            self.paidButton.isEnabled = true
                            self.paidButton.setTitle("Pay and Upgrade Package", for: .normal)
                            if myPackageModel.upcoming_package == 1 {
                                self.paidButton.setTitle("Already Paid for upcoming package", for: .normal)
                                self.paidButton.isEnabled = false
                                self.getUpcomingPackage()
                            }
                            self.isGoldSelected = myPackageModel.current_package.plan == "2"
                            self.tableView.reloadData()
                        } else {
                            App_AlertView.shared.SimpleMessage(Text: body["message"] as? String ?? "")
                        }
                    }
                case let .fail(errorMsg):
                    self.packageLabel = errorMsg
                    self.view.makeToast(errorMsg, duration: 1.0, position: .center)
                    if self.sitePackage == "0" || self.sitePackage == "111" {
                        let myPackageModel = MyPackageModel(["upcoming_package": self.packageLabel.uppercased().contains("GOLD PLAN EXPIRED") ? 1 : 2])
                        self.myPackages.append(myPackageModel)
                    }
                    self.tableView.reloadData()
                    print(errorMsg)
                }
            }
        }
    }
    
    private func getUpcomingPackage() {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": appDelegate.userLoginAccessDetails?.id ?? "", "site_id": site_ID] as [String: Any]
            Webservice.Authentication.getUpcomingPackage(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["code"] as? Int ?? 0 == 200, let message = body["message"] as? String, message.lowercased() == "success" {
                            let myPackageModel = MyPackageModel(body)
                            self.myPackages.append(myPackageModel)
                            self.tableView.reloadData()
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
    
    private func payNowAPI() {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": appDelegate.userLoginAccessDetails?.id ?? "", "site_id": site_ID, "plan_id": isGoldSelected ? 2 : 1] as [String: Any]
            Webservice.Authentication.payNowForPackage(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["code"] as? Int ?? 0 == 200, let message = body["message"] as? String, message.lowercased() == "success" {
                            let url = body["url"] as? String ?? ""
                            let order_id = body["order_id"] as? Int ?? -1
                            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PayWebViewViewController") as? PayWebViewViewController {
                                vc.webURL = URL(string: url)
                                vc.order_id = order_id
                                vc.isGoldSelected = self.isGoldSelected
                                vc.siteName = self.siteName
                                Functions.pushToViewController(self, toVC: vc)
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
    
    @objc func tapOnButton1(_ sender: UIButton) {
        isGoldSelected = true
        self.tableView.reloadData()
    }
    
    @objc func tapOnButton2(_ sender: UIButton) {
        isGoldSelected = false
        self.tableView.reloadData()
    }
}

extension MyPackageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sitePackage == "0" ? 1 : (isPayNow ? 3 : myPackages.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sitePackage == "0" {
            if let cell = tableView.dequeueReusableCell(withIdentifier: MyPackageTableViewCell.currPackageCell, for: indexPath) as? MyPackageTableViewCell {
                cell.packageNameLabel.text = self.packageLabel
                return cell
            }
            return UITableViewCell()
        }
        var cellId = MyPackageTableViewCell.identifier
        if isPayNow {
            if indexPath.row == 2 {
                cellId = MyPackageTableViewCell.radioCell
            } else {
                cellId = MyPackageTableViewCell.packageBuyCell
            }
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MyPackageTableViewCell {
            if isPayNow {
                if indexPath.row == 2 {
                    cell.button1.addTarget(self, action: #selector(tapOnButton1(_:)), for: .touchUpInside)
                    cell.button2.addTarget(self, action: #selector(tapOnButton2(_:)), for: .touchUpInside)
                    cell.radioImage1.isHighlighted = self.isGoldSelected
                    cell.radioImage2.isHighlighted = !self.isGoldSelected
                } else if myPackages.count > 0 {
                    cell.configureUpgrade(myPackages[0].current_package, row: indexPath.row)
                }
            } else {
                cell.configure(myPackages[indexPath.row].current_package, row: indexPath.row)
            }
            return cell
        }
        return UITableViewCell()
    }
}
