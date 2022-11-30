//
//  AppDelegate.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.
//

import CoreLocation
import IQKeyboardManagerSwift
import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate, PrLocation {
    var vwLoader: UIView?
    var window: UIWindow?
    var navCon: UINavigationController!
    static let shared = UIApplication.shared.delegate as! AppDelegate
    var userLoginAccessDetails: LoginData?
    var isLogin = false
    var Lat = ""
    var Long = ""
    var Location = ""
    var fcm_Token: String?
    let gcmMessageIDKey = "gcm.message_id"
    private var selfieTimer = Timer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        setRootViewController()

        // Location Start and Update ***********************************
        LocationManagerSingleton.shared.delegate = self
        LocationManagerSingleton.shared.StartStopUpdatingLocation(start: true)
        
        //***************************** Google Map Keys *****************************************//
        GMSServices.provideAPIKey("AIzaSyAhJ2jyMQywcUnCOp6_7dYsJ_f_qZsGyf8")
        GMSPlacesClient.provideAPIKey("AIzaSyAhJ2jyMQywcUnCOp6_7dYsJ_f_qZsGyf8")
        //***************************** Location Update *****************************************//
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self

        if USERDEFAULTS.string(forKey: "loggedin") == "YES" {
            authenticateUser()
        } else {
            unAuthenticateUser()
        }

        #if compiler(>=5.1)
            if #available(iOS 13.0, *) {
                window?.overrideUserInterfaceStyle = .light
            }
        #endif
        
        if USERDEFAULTS.integer(forKey: "WaitForNextSelfie") > 0 {
            startSelfiCountDown()
        }
        return true
    }
    
    func GetLocation(currentLocation: CLLocationCoordinate2D) {
        print(currentLocation)
        let lat = currentLocation.latitude
        let long = currentLocation.longitude
        Lat = "\(lat)"
        Long = "\(long)"
    }

    func authenticateUser() {
        let frontViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NavigationControllerHome")
        window?.rootViewController = frontViewController
        window?.makeKeyAndVisible()
    }

    func unAuthenticateUser() {
        let frontViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NavigationControllerLogin")
        window?.rootViewController = frontViewController
        window?.makeKeyAndVisible()
    }

    func ShowAlertController(message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            _ in
            NSLog("OK Pressed")
        }
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }

    func setRootViewController() {
        if let iValue = USERDEFAULTS.value(forKey: UserDefaults.Keys.UserLoginAccessDetails) as? Data {
            appDelegate.userLoginAccessDetails = NSKeyedUnarchiver.unarchiveObject(with: iValue) as? LoginData
            if appDelegate.userLoginAccessDetails?.loginStatus != nil {
                appDelegate.isLogin = true
                //  UIStoryboard.setHomeAsRootView()
            } else {
                appDelegate.isLogin = false
                // UIStoryboard.setLoginAsRootView()
            }
        } else {
            appDelegate.isLogin = false
            // UIStoryboard.setLoginAsRootView()
        }
    }

    func flushUserData() {
        USERDEFAULTS.removeObject(forKey: UserDefaults.Keys.UserLoginAccessDetails)
        USERDEFAULTS.removeObject(forKey: UserDefaults.Keys.ShowFollowingUserStatus)
        USERDEFAULTS.removeObject(forKey: UserDefaults.Keys.ShowProfileVideoStatus)
        USERDEFAULTS.removeObject(forKey: UserDefaults.Keys.SuggestAccountToOthersStatus)
        USERDEFAULTS.removeObject(forKey: UserDefaults.Keys.ShowAccountTypeStatus)
        USERDEFAULTS.removeObject(forKey: "isLogin")
    }

    func applicationWillResignActive(_: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_: UIApplication) { }

    func applicationWillTerminate(_: UIApplication) { }

    func RedirectToLocation() {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GPSLocationVC") as! GPSLocationVC
        vc.modalPresentationStyle = .fullScreen
        let navigationController = window?.rootViewController as! UINavigationController
//        navigationController.pushViewController(viewController: vc, animated: true, completion: nil)
        Functions.pushToViewController(navigationController, toVC: vc)
    }

    func openSettingApp(message: String) {
        let alertController = UIAlertController(title: "Owner App", message: message, preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        let navigationController = window?.rootViewController as! UINavigationController
        navigationController.present(alertController, animated: true, completion: nil)
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func userNotificationCenter(_: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                    -> Void)
    {
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print full message.
//        print(userInfo)
        if USERDEFAULTS.string(forKey: "loggedin") == "YES", let notiData = userInfo["gcm.notification.msg"] as? String {
            let notificationData = jsonStringToDictionary(notiData)
            appDelegate.userLoginAccessDetails?.id = notificationData["user_id"] as? String
            if let notificationType = notificationData["notification_type"] as? Int, (notificationType == 12 || notificationType == 13) {
                self.logoutApp(appDelegate.userLoginAccessDetails?.id ?? "")
            }
        }
        // Change this to your preferred presentation option
        completionHandler(USERDEFAULTS.bool(forKey: "IsUnMuteNotification") ? [[.alert, .badge]] : [[.alert, .sound, .badge]])
    }

    func userNotificationCenter(_: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)

        if USERDEFAULTS.string(forKey: "loggedin") == "YES", let notiData = userInfo["gcm.notification.msg"] as? String {
            redirectedToVC(jsonStringToDictionary(notiData))
        }
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        completionHandler()
    }
    
    func jsonStringToDictionary(_ string: String) -> NSDictionary {
        if let data = string.data(using: .utf8) {
            do {
                if let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    return dictionary
                }
            } catch {
                return NSDictionary()
            }
        }
        return NSDictionary()
    }
    
    private func redirectedToVC(_ data: NSDictionary) {
        // Notification Type: 10 - Added into Vehicle / Visitor gate
        // Notification Type: 12 - Remove from Vehicle / Visitor gate - Logout
        appDelegate.userLoginAccessDetails?.id = data["user_id"] as? String

        if let notificationType = data["notification_type"] as? Int, (notificationType == 12 || notificationType == 13) {
//            Logout
            self.logoutApp(appDelegate.userLoginAccessDetails?.id ?? "")
        } else if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationList") as? NotificationList {
            vc.site_id = data["site_id"] as! String
            appDelegate.userLoginAccessDetails?.id = data["user_id"] as? String
            if let additionalDataStr = data["additional_data"] as? String {
                let additionalData = jsonStringToDictionary(additionalDataStr)
                vc.site_name = additionalData["site_name"] as! String
            }
            if let navController = self.window?.rootViewController as? UINavigationController {
                if let lastVC = navController.children.last, lastVC is NotificationList {
                    navController.viewControllers.removeLast()
                }
                var isMenuList = false
                for cont in navController.children {
                    if cont is MenuVC {
                        isMenuList = true
                        break
                    }
                }
                if !isMenuList {
                    var viewControllers = [UIViewController]()
                    if let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SiteListVC") as? SiteListVC {
                        viewControllers.append(vc1)
                    }
                    if let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as? MenuVC {
                        vc2.k_siteID = vc.site_id
                        vc2.employeeID = data["user_id"] as! String
                        vc2.site_name = vc.site_name
//                        if let uploadReport1 = data["upload_report"] as? Int {
//                            vc2.uploadReport = "\(uploadReport1)"
//                        }
                        viewControllers.append(vc2)
                    }
                    navController.viewControllers = viewControllers
                }
//                Functions.pushToViewController(navController, toVC: vc)
                navController.pushViewController(vc, animated: false)
            } else {
                self.window?.rootViewController?.navigationController?.pushViewController(viewController: vc, animated: false, completion: nil)
//                Functions.pushToViewController((self.window?.rootViewController?.navigationController!)!, toVC: vc)
            }
        }
    }
    
    
    func logoutApp(_ userId: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: (self.window?.rootViewController)!) {
            DispatchQueue.global(qos: .background).async {
                Webservice.Authentication.LogoutApp(parameter: ["user_id": userId] as [String: Any], completion: { [self] _ in
                    let notificationToken = USERDEFAULTS.value(forKey: "device_Token") as? String ?? ""
                    let defaults = UserDefaults.standard
                    let dictionary = defaults.dictionaryRepresentation()
                    dictionary.keys.forEach { key in
                        defaults.removeObject(forKey: key)
                    }

                    let frontViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NavigationControllerLogin")
                    window?.rootViewController = frontViewController
                    window?.makeKeyAndVisible()
                    USERDEFAULTS.set("NO", forKey: "loggedin")
                    USERDEFAULTS.set("YES", forKey: "isfirsttime")
                    USERDEFAULTS.set(notificationToken, forKey: "device_Token")
                })
            }
        }
    }

    func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }

    func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        ServerRequestAPI.device_Token = "\(fcmToken)"
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)

        fcm_Token = fcmToken
        USERDEFAULTS.set(fcm_Token, forKey: "device_Token")
    }

    func messaging(_: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration Refresh Token: \(fcmToken)")
        fcm_Token = fcmToken
        USERDEFAULTS.set(fcmToken, forKey: "device_Token")
    }
    
    func startSelfiCountDown() {
        if self.selfieTimer.isValid {
            self.selfieTimer.invalidate()
        }
        self.selfieTimer = Timer(timeInterval: 1, target: self, selector: #selector(self.selfiTimeCountDown), userInfo: nil, repeats: true)
        RunLoop.main.add(self.selfieTimer, forMode: .default)
        self.selfieTimer.fire()
    }
    
    @objc func selfiTimeCountDown() {
        var secs = USERDEFAULTS.integer(forKey: "WaitForNextSelfie")
        secs = secs - 1
        if secs <= 0 {
            selfieTimer.invalidate()
        }
        USERDEFAULTS.set(secs, forKey: "WaitForNextSelfie")
        USERDEFAULTS.set(Date.timeIntervalBetween1970AndReferenceDate, forKey: "WaitForNextSelfieUnix")
    }
}
