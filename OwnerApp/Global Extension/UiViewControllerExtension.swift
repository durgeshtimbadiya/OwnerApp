//
//  UiViewControllerExtension.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import Foundation

import UIKit

extension UIViewController {
    @IBAction func actionPopViewController(sender _: UIButton?) {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }

    @IBAction func actionDismissViewController(sender _: UIButton?) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func LiveTrendingAndFollowingActionDismissViewController(sender _: UIButton?) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func actionOnNotificationClick(sender _: UIButton?) {
        if USERDEFAULTS.value(forKey: "isLogin") as? Bool ?? false {
            //   UIStoryboard.SetNotificationView()
        } else {
//            let vc =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "P_LoginOptionVC") as! P_LoginOptionVC
//            vc.modalPresentationStyle = .overCurrentContext
//            self.present(vc, animated: true, completion: nil)
        }
    }

//    @IBAction func DashboardActionOnNotificationClick (sender :  UIButton?) {
//           if  USERDEFAULTS.value(forKey: "isLogin") as? Bool ?? false {
//               UIStoryboard.SetNotificationView()
//           }
//           else {
//               let vc =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "P_LoginOptionVC") as! P_LoginOptionVC
//               vc.modalPresentationStyle = .overCurrentContext
//               self.present(vc, animated: true, completion: nil)
//           }
//       }

    @IBAction func actionOnSearchClick(sender _: UIButton?) {
        if USERDEFAULTS.value(forKey: "isLogin") as? Bool ?? false {
            //  UIStoryboard.SetSearchView()
        } else {
//            let vc =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "P_LoginOptionVC") as! P_LoginOptionVC
//            vc.modalPresentationStyle = .overCurrentContext
//            self.present(vc, animated: true, completion: nil)
        }
    }

    @IBAction func DashBoardactionOnSearchClick(sender _: UIButton?) {
        if USERDEFAULTS.value(forKey: "isLogin") as? Bool ?? false {
            // UIStoryboard.SetSearchView()
        } else {
//               let vc =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "P_LoginOptionVC") as! P_LoginOptionVC
//               vc.modalPresentationStyle = .overCurrentContext
//               self.present(vc, animated: true, completion: nil)
        }
    }

    @IBAction func actionOnVideoClick(sender _: UIButton?) {
        if USERDEFAULTS.value(forKey: "isLogin") as? Bool ?? false {
//
//                    let vc = UIStoryboard.CreateUser.instantiateViewController(withIdentifier: "P_CreateVideoVC") as! P_CreateVideoVC
//                    self.navigationController?.pushViewController(vc, animated: true)
            //
            //         UIStoryboard.SetVideoView()
//            let vc = UIStoryboard.CreateUser.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
//            self.navigationController?.pushViewController(vc, animated: true)
            //
            //                        let vc = UIStoryboard.CreateUser.instantiateViewController(withIdentifier: "P_SoundsVC") as! P_SoundsVC
            //                        self.navigationController?.pushViewController(vc, animated: true)
        } else {
//            let vc =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "P_LoginOptionVC") as! P_LoginOptionVC
//            vc.modalPresentationStyle = .overCurrentContext
//            self.present(vc, animated: true, completion: nil)
        }
    }

//    @IBAction func DashboardActionOnVideoClick (sender :  UIButton?) {
//            if  USERDEFAULTS.value(forKey: "isLogin") as? Bool ?? false {
//
//                        let vc = UIStoryboard.CreateUser.instantiateViewController(withIdentifier: "P_CreateVideoVC") as! P_CreateVideoVC
//                        self.navigationController?.pushViewController(vc, animated: true)
//                //
//                //         UIStoryboard.SetVideoView()
//    //            let vc = UIStoryboard.CreateUser.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
//    //            self.navigationController?.pushViewController(vc, animated: true)
//                //
//                //                        let vc = UIStoryboard.CreateUser.instantiateViewController(withIdentifier: "P_SoundsVC") as! P_SoundsVC
//                //                        self.navigationController?.pushViewController(vc, animated: true)
//            }
//            else {
//                let vc =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "P_LoginOptionVC") as! P_LoginOptionVC
//                vc.modalPresentationStyle = .overCurrentContext
//                self.present(vc, animated: true, completion: nil)
//            }
//        }

    @IBAction func btnUSerCLick(sender _: UIButton) {
//        if  USERDEFAULTS.value(forKey: "isLogin") as? Bool ?? false {
//            isMyProfile = true
//            profileUserID = appDelegate.userLoginAccessDetails?.id ?? ""
//            UIStoryboard.SetUserView()
//        }
//        else {
//            let vc =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "P_LoginOptionVC") as! P_LoginOptionVC
//            vc.modalPresentationStyle = .overCurrentContext
//            self.present(vc, animated: true, completion: nil)
//        }
    }

//    @IBAction func DashBoardBtnUSerCLick(sender : UIButton) {
//
//           if  USERDEFAULTS.value(forKey: "isLogin") as? Bool ?? false {
//               isMyProfile = true
//               profileUserID = appDelegate.userLoginAccessDetails?.id ?? ""
//               UIStoryboard.SetUserView()
//           }
//           else {
//               let vc =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "P_LoginOptionVC") as! P_LoginOptionVC
//               vc.modalPresentationStyle = .overCurrentContext
//               self.present(vc, animated: true, completion: nil)
//           }
//       }

    func popupAlert(title: String?, message: String?, actionTitles: [String?], actions: [((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }

//    func addSideMenu() {
//            if (appDelegate.sideMenuVC != nil) {
//                if (!self.children.contains(appDelegate.sideMenuVC!)) {
//                    configureChildViewController(childController: appDelegate.sideMenuVC!, onView: self.view, isHideAfterAddedInSubview: true)
//                }
//            }
//    }

    func configureChildViewController(childController: UIViewController, onView: UIView?, isHideAfterAddedInSubview: Bool) {
        var holderView = view
        if let onView = onView {
            holderView = onView
        }
        addChild(childController)
        holderView?.addSubview(childController.view)
        constrainViewEqual(holderView: holderView!, view: childController.view)
        childController.didMove(toParent: self)
        childController.willMove(toParent: self)
        childController.view.isHidden = isHideAfterAddedInSubview
    }

    func constrainViewEqual(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        // pin 100 points from the top of the super
        let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                        toItem: holderView, attribute: .top, multiplier: 1.0, constant: 0)
        let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                           toItem: holderView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
                                         toItem: holderView, attribute: .left, multiplier: 1.0, constant: 0)
        let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
                                          toItem: holderView, attribute: .right, multiplier: 1.0, constant: 0)
        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
}
