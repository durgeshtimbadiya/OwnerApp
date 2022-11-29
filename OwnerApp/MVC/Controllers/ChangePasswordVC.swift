//
//  ChangePasswordVC.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 20/11/21.

import CoreLocation
import UIKit

class ChangePasswordVC: UIViewController, UITextFieldDelegate {
    @IBOutlet var viewCorner: UIView!
    @IBOutlet var txtFieldNewPassword: UITextField!
    @IBOutlet var txtFieldConfirmPassword: UITextField!
    @IBOutlet var btnSubmit: UIButton!

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

    @IBAction func btnBackAction(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // delegate method
        textField.resignFirstResponder()
        return true
    }

    // MARK: -  Change Password Api Functionality-------------------------------

    func ChangePasswordApiFunc(UserID: String, Password: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["user_id": UserID, "password": Password] as [String: Any]

            Webservice.Authentication.PasswordUpdateApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {
                            self.view.makeToast("Password Updated Successfully", duration: 1.0, position: .center)
                            self.perform(#selector(self.RedirectToLogin), with: nil, afterDelay: 1.1)
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

    @objc func RedirectToLogin() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSubmitAction(_: Any) {
        if txtFieldNewPassword.text == "" {
            view.makeToast("please enter password", duration: 0.8, position: .center)
            return
        } else if txtFieldConfirmPassword.text == "" {
            view.makeToast("please enter confirm password", duration: 0.8, position: .center)
            return
        } else if txtFieldNewPassword.text != txtFieldConfirmPassword.text {
            view.makeToast("password does not match", duration: 0.8, position: .center)
            return
        } else {
            if appDelegate.userLoginAccessDetails?.id != nil {
                ChangePasswordApiFunc(UserID: appDelegate.userLoginAccessDetails?.id ?? "", Password: txtFieldNewPassword.text ?? "")
            }
        }
    }
}
