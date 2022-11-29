//
//  LoginVC.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 20/11/21.

import UIKit
import AVFoundation

class LoginVC: UIViewController,UITextFieldDelegate {
    @IBOutlet var viewCorner: UIView!
    @IBOutlet var btnPasswordHideOrShow: UIButton!
    var passwordClick = true
    @IBOutlet var btnLogin: UIButton!

    @IBOutlet var txtFieldPhone: UITextField!
    @IBOutlet var txtFieldPassword: UITextField!
    var admin_ID = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        viewCorner.dropShadowWithCornerRadius()
        btnLogin.dropShadowWithCornerRadius()
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
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtFieldPhone {
            // get the current text, or use an empty string if that failed
            let currentText = textField.text ?? ""

            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }

            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // make sure the result is under 16 characters
            return updatedText.count <= 10
        } else {
            return true
        }
     
    }

    @IBAction func btnPasswordHideORShowAction(_: Any) {
        if passwordClick == true {
            txtFieldPassword.isSecureTextEntry = false
            btnPasswordHideOrShow.setImage(UIImage(named: "invisible"), for: .normal)
        } else {
            txtFieldPassword.isSecureTextEntry = true
            btnPasswordHideOrShow.setImage(UIImage(named: "eye"), for: .normal)
        }

        passwordClick = !passwordClick
    }

    @IBAction func btnLoginAction(_: Any) {
        if txtFieldPhone.text == "" {
            view.makeToast("please enter mobile number", duration: 0.8, position: .center)
            return
        } else if txtFieldPassword.text == "" {
            view.makeToast("please enter password", duration: 0.8, position: .center)
            return
        } else {
            loginApi(mobile: txtFieldPhone.text ?? "", password: txtFieldPassword.text ?? "", loginType: "3")
        }
    }

    // MARK: - Login Api Functionality -------------------------------------------

    func loginApi(mobile: String, password: String, loginType: String) { // Login Type 7 means Labor/Facility
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["mobile": mobile, "password": password, "loged_in": loginType] as [String: Any]

            Webservice.Authentication.LoginApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" != "No User Found" {

                            if let id = body["admin_id"] as? String {
                                self.admin_ID = id
                            }
                                        self.view.makeToast(body["message"] as? String ?? "", duration: 1.0, position: .center)
                                        self.perform(#selector(self.RedirectToSiteList), with: nil, afterDelay: 1.1)
                                //    }
                              //  }
                          //  }
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
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OTPScreenVC") as! OTPScreenVC
        vc.adminID = self.admin_ID
       // USERDEFAULTS.set("YES", forKey: "loggedin")
//        navigationController?.pushViewController(vc, animated: true)
        Functions.pushToViewController(self, toVC: vc)
    }
    
    
    @IBAction func btnForgotPasswordAction(_ sender: Any) {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgorAndChangePasswordVC") as? ForgorAndChangePasswordVC {
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }
    
}
