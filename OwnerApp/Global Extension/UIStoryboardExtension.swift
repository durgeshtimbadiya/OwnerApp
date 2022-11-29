//
//  UIStoryboardExtension.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import UIKit

extension UIStoryboard {
    func instantiateViewControllerTo(identifier: String) -> UIViewController {
        if #available(iOS 13.0, *) {
            return self.instantiateViewController(identifier: identifier)
        } else {
            return instantiateViewController(withIdentifier: identifier)
        }
    }

    static let CreateUser: UIStoryboard = .init(name: StoryBoard.StoryBoardCreateVideo, bundle: nil)

    static let Login: UIStoryboard = .init(name: StoryBoard.StoryBoardLogin, bundle: nil)

    static let Home: UIStoryboard = .init(name: StoryBoard.StoryBoardHome, bundle: nil)

    static let QuickCOnsult: UIStoryboard = .init(name: StoryBoard.StoryBoardQuickConsultation, bundle: nil)

    static let PrescriptionRequest: UIStoryboard = .init(name: StoryBoard.StoryBoardPrescriptionRequest, bundle: nil)

    static let Ecommerce: UIStoryboard = .init(name: StoryBoard.StoryBoardEcommerce, bundle: nil)

    class func setLoginAsRootView() {
        let navViewController: NavigationController = App_StoryBoard.shared.StoryBoardLogin().instantiateViewController(withIdentifier: "NavigationController") as! NavigationController

        if USERDEFAULTS.value(forKey: "SelectedLanguage") == nil {
            navViewController
        }

        appDelegate.window?.rootViewController = navViewController
    }

//    class func setHomeAsRootView() {
//        appDelegate.selectedIndex = 0
//        let navViewController : NavigationController = App_StoryBoard.shared.StoryBoardMain().instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = navViewController
//    }

//    class func SetUserView() {
//        let navViewController : NavigationController = App_StoryBoard.shared.StoryBoardQuickConsultation().instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
//            appDelegate.window?.rootViewController = navViewController
//    }

//    class func SetOtherUserView() {
//        let navViewController : NavigationController = App_StoryBoard.shared.StoryBoardQuickConsultation().instantiateViewController(withIdentifier: "OtherNavigationController") as! NavigationController
//            appDelegate.window?.rootViewController = navViewController
//    }

//    class func SetNotificationView() {
//        let navViewController : NavigationController = App_StoryBoard.shared.StoryBoardQuickConsultation().instantiateViewController(withIdentifier: "NavigationControllerNotification") as! NavigationController
//            appDelegate.window?.rootViewController = navViewController
//    }

//    class func SetSearchView() {
//           let navViewController : NavigationController = App_StoryBoard.shared.StoryBoardQuickConsultation().instantiateViewController(withIdentifier: "NavigationControllerSearch") as! NavigationController
//               appDelegate.window?.rootViewController = navViewController
//       }
//
//    class func SetLiveStreamButtonView() {
//              let navViewController : NavigationController = App_StoryBoard.shared.StoryBoardMain().instantiateViewController(withIdentifier: "NavigationControllerDashBoard") as! NavigationController
//                  appDelegate.window?.rootViewController = navViewController
//       // NavigationControllerLiveAgoraLocationVC
//          }

//    class func SetVideoView() {
//        let navViewController : NavigationController = App_StoryBoard.shared.StoryBoardQuickConsultation().instantiateViewController(withIdentifier: "NavigationControllerPlayVideo") as! NavigationController
//            appDelegate.window?.rootViewController = navViewController
//    }
//
//    class func ClickonPrescription() {
//
//            let navViewController : NavigationController = App_StoryBoard.shared.StoryBoardPrescriptionRequest().instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
//            appDelegate.window?.rootViewController = navViewController
//
//       }

    class func ClickonEcommerce() {
        UIStoryboard.setTabBarController()
    }

    class func GenerateNavContoller(withIdentiFier identifier: String) -> NavigationController {
        let navViewController: NavigationController = App_StoryBoard.shared.StoryBoardEcommerce().instantiateViewController(withIdentifier: identifier) as! NavigationController
        return navViewController
    }

    class func setTabBarController() {
        let tabViewController: CustomTabBarController = App_StoryBoard.shared.StoryBoardEcommerce().instantiateViewController(withIdentifier: "CustomTabBarController") as! CustomTabBarController

        // View Controllers
        let pharmacyTabVc = UIStoryboard.GenerateNavContoller(withIdentiFier: "PharmacyNavigationController")
        let categoryTabVc = UIStoryboard.GenerateNavContoller(withIdentiFier: "CategoriesNavigationController")
        let cartTabVc = UIStoryboard.GenerateNavContoller(withIdentiFier: "CartNavigationController")
        let moreTabVc = UIStoryboard.GenerateNavContoller(withIdentiFier: "MoreNavigationController")

        // Tabbar Items
        let tabbarItemHome = UITabBarItem(title: Strings_ECTabBarItems.Home, image: UIImage(named: Assets.TabHomeNormal), tag: 0)
        tabbarItemHome.selectedImage = UIImage(named: Assets.TabHomeActive)
        let tabbarItemCategories = UITabBarItem(title: Strings_ECTabBarItems.Cateories, image: UIImage(named: Assets.TabCategoryNormal), tag: 1)
        tabbarItemCategories.selectedImage = UIImage(named: Assets.TabCategoryActive)
        let tabbarItemCart = UITabBarItem(title: Strings_ECTabBarItems.Cart, image: UIImage(named: Assets.TabCartNormal), tag: 2)
        tabbarItemCart.selectedImage = UIImage(named: Assets.TabCartActive)
        let tabbarItemMore = UITabBarItem(title: Strings_ECTabBarItems.More, image: UIImage(named: Assets.TabMoreNormal), tag: 3)
        tabbarItemMore.selectedImage = UIImage(named: Assets.TabMoreActive)

        pharmacyTabVc.tabBarItem = tabbarItemHome
        categoryTabVc.tabBarItem = tabbarItemCategories
        cartTabVc.tabBarItem = tabbarItemCart
        moreTabVc.tabBarItem = tabbarItemMore

        tabViewController.viewControllers = [pharmacyTabVc, categoryTabVc, cartTabVc, moreTabVc]

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppColor.Color_LightGrey, NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont()], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppColor.Color_TopHeader, NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 14) ?? UIFont()], for: .selected)

        //   appDelegate.window?.rootViewController = tabViewController
    }
}

import Foundation
