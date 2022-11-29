//
//  ForgotAndChangePasswordVC.swift
//  EmployeeApp
//
//  Created by Jailove on 08/06/22.


import UIKit

class ForgorAndChangePasswordVC: UIViewController, UITextFieldDelegate {
    @IBOutlet var viewPhoneNumberSend: UIView!
    @IBOutlet var txtFieldPhoneNumber: UITextField!
    @IBOutlet var txtFieldOTP: UITextField!
    @IBOutlet var viewOTPLinear: UIView!

    @IBOutlet var btnSubmit: UIButton!
    // ************************************************//
    @IBOutlet var viewPasswordAndConfirm: UIView!
    @IBOutlet var txtfieldPassword: UITextField!

    @IBOutlet var txtfieldConfirmPasswrd: UITextField!
    @IBOutlet var btnSubmitPasswordAndConfirm: UIButton!
    var isOTPSend: Bool = false
    var OTP = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        viewPhoneNumberSend.isHidden = false
        viewPhoneNumberSend.dropShadowWithCornerRadius()
        viewPasswordAndConfirm.dropShadowWithCornerRadius()
        btnSubmit.dropShadowWithCornerRadius()
        btnSubmitPasswordAndConfirm.dropShadowWithCornerRadius()
        viewPasswordAndConfirm.isHidden = true
        txtFieldOTP.isHidden = true
        viewOTPLinear.isHidden = true
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

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtFieldPhoneNumber {
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

    // MARK: - OTP send Functionality------------------------

    @IBAction func btnOTPSendAction(_: Any) {
        if isOTPSend == false {
            if txtFieldPhoneNumber.text == "" {
                view.makeToast("please enter mobile number", duration: 0.8, position: .center)
                return
            }  else {
                ForgotpasswordFuncApi(type: "3", mobile: txtFieldPhoneNumber.text ?? "")
            }
        } else {
            if txtFieldOTP.text == "" {
                view.makeToast("please enter otp", duration: 0.8, position: .center)
                return
            } else {
                ForgotOTPMatchApi(type: "3", mobile: txtFieldPhoneNumber.text ?? "", otp: txtFieldOTP.text ?? "")
            }
        }
    }

    // MARK: -  OTP send Api Functionality-------------------------------

    func ForgotpasswordFuncApi(type: String, mobile: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["type": type, "mobile": mobile] as [String: Any]

            Webservice.Authentication.ForgotPasswordApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {
                            self.view.makeToast("Please check your SMS for otp!", duration: 1.0, position: .center)
                            self.isOTPSend = true
                            print(response)
                            self.txtFieldOTP.isHidden = false
                            self.viewOTPLinear.isHidden = false
                            self.btnSubmit.setTitle("Verify OTP", for: .normal)

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

    // MARK: -  Forgot OTP match Api Functionality-------------------------------

    func ForgotOTPMatchApi(type: String, mobile: String, otp: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["type": type, "mobile": mobile, "otp": otp] as [String: Any]

            Webservice.Authentication.ForgotMatchPasswordApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" != "OTP Not Matched" {
                            self.view.makeToast("OTP Matched", duration: 1.0, position: .center)
                            self.isOTPSend = true
                            self.viewPhoneNumberSend.isHidden = true
                            self.viewPasswordAndConfirm.isHidden = false

                        } else {
                            self.view.makeToast(body["message"] as? String ?? "", duration: 1.0, position: .center)
                        }
                    }
                case let .fail(errorMsg):
                    self.view.makeToast(errorMsg, duration: 1.0, position: .center)
                    print(errorMsg)
                }
            }
        }
    }

    // MARK: -  New Password Api Functionality-------------------------------

    func newPasswordFuncApi(type: String, mobile: String, password: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["type": type, "mobile": mobile, "password": password] as [String: Any]

            Webservice.Authentication.newPasswordApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["code"] as? Int ?? 0 == 200 {
                            self.view.makeToast("Password Changed Successfully", duration: 1.0, position: .center)
                            self.perform(#selector(self.RedirectToSiteList), with: nil, afterDelay: 1.3)

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

    @objc func RedirectToSiteList() {
        for controller in navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginVC.self) {
                navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }

    // MARK: - Submit Password Action Functionality-----------------------

    @IBAction func btnSubmitPasswordAction(_: Any) {
        if txtfieldPassword.text == "" {
            view.makeToast("please enter password", duration: 0.8, position: .center)
            return
        } else if txtfieldConfirmPasswrd.text == "" {
            view.makeToast("please enter confirm password", duration: 0.8, position: .center)
            return
        } else if txtfieldPassword.text != txtfieldConfirmPasswrd.text {
            view.makeToast("password does not matched", duration: 0.8, position: .center)
            return
        } else {
            newPasswordFuncApi(type: "3", mobile: txtFieldPhoneNumber.text ?? "", password: txtfieldPassword.text ?? "")
        }
    }
}
