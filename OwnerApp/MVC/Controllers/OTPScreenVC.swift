//
//  OTPScreenVC.swift
//  EmployeeApp
//
//  Created by Jailove on 07/06/22.
//

import UIKit

class OTPScreenVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var txtFieldOTP: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    var adminID = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        viewCorner.dropShadowWithCornerRadius()
        btnSubmit.dropShadowWithCornerRadius()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // delegate method
        textField.resignFirstResponder()
        return true
    }

    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Login Api Functionality -------------------------------------------

    func loginOTPApi(otp: String, admin_id: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["otp": otp,
                          "admin_id": admin_id] as [String: Any]

            Webservice.Authentication.LoginViaOTP(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["code"] as? Int ?? 0 == 200 {
                            if (body["user_data"] as? [String: Any]) != nil {
                                if let iDictLoginAccessDetails = body["user_data"] as? [String: Any] {
                                    let iDictLoginDetails = LoginData(fromDictionary: iDictLoginAccessDetails)
                                    
                                    appDelegate.userLoginAccessDetails = iDictLoginDetails

                                    let iEncodedDataLoginAccessDetails: Data = NSKeyedArchiver.archivedData(withRootObject: appDelegate.userLoginAccessDetails as Any)

                                    USERDEFAULTS.set(iEncodedDataLoginAccessDetails, forKey: UserDefaults.Keys.UserLoginAccessDetails)

                                    if appDelegate.userLoginAccessDetails?.loginStatus == "0" {
                                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC
//                                        self.navigationController?.pushViewController(vc!, animated: true)
                                        Functions.pushToViewController(self, toVC: vc!)

                                    } else {
                                        USERDEFAULTS.set(true, forKey: "isLogin")
                                        self.view.makeToast("Log in Successfully", duration: 1.0, position: .center)
                                        self.perform(#selector(self.RedirectToSiteList), with: nil, afterDelay: 1.1)
                                    }
                                }
                            } else {
                                self.view.makeToast(body["message"] as? String ?? "", duration: 1.0, position: .center)
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

    @objc func RedirectToSiteList() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SiteListVC") as! SiteListVC
        USERDEFAULTS.set("YES", forKey: "loggedin")
//        navigationController?.pushViewController(vc, animated: true)
        Functions.pushToViewController(self, toVC: vc)
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        if txtFieldOTP.text == "" {
            view.makeToast("please enter otp", duration: 0.8, position: .center)
            return
        } else {
            loginOTPApi(otp: txtFieldOTP.text ?? "", admin_id: adminID)
        }
    }
    
}
