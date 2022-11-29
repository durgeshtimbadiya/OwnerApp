//
//  Constants.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import UIKit
// import FirebaseDatabase

// MARK: - Constant Objects

let AppName = "Admin App"
let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let devieType = "ios"
let googleMapKey = "AIzaSyDDv5gaJtv1_M0rtrNNbW7wEoBEfaQpDWA"
let googlePlaceKey = "AIzaSyDDv5gaJtv1_M0rtrNNbW7wEoBEfaQpDWA"
let TopHeaderCorner: CGFloat = 50
let APP_LANGUAGE = "app_langauge"
let DeviceId = UIDevice.current.identifierForVendor!.uuidString
let systemVersion = UIDevice.current.systemVersion
let USERDEFAULTS = UserDefaults.standard
let countryCode = "+966 "
let EcommerceAccessToken = "EcommerceAccessToken"
let EcommerceUserQuoteID = "EcommerceUserQuoteID"
let TapDocURL = "/PhotoFIT"
var SearchData = [String: AnyObject]()
var isFacebookLogin: Bool = false
var BaseURL_Img = "https://dev.sitepay.co.in/data/"

// Firestore database
// let firBaseDb = Database.database().reference()

// Database tables
// let orderDb = "id"

enum AppLanguages {
    static let English = "en"
    static let Arabic = "ar"
}

enum LoginStoreKey {
    static let Mobile = "Mobile"
    static let Password = "Password"
    static let isMobile = "isMobile"
    static let Email = "Email"
    static let Code = "Code"
}

enum StoryBoard {
    static let StoryBoardQuickConsultation = "User"
    static let StoryBoardPrescriptionRequest = "PrescriptionRequest"
    static let StoryBoardEcommerce = "E-commerce"
    static let StoryBoardScheduledAppointment = "ScheduledAppointment"
    static let StoryBoardLogin = "Login"
    static let StoryBoardMain = "Main"
    static let StoryBoardHome = "Home"
    static let StoryBoardCreateVideo = "CreateVideo"
}

enum NotificationPayload {
    static let MessageID = "gcm.message_id"
    static let Data = "gcm.notification.data"
    static let UniqueID = "gcm.notification.unique_id"
}

enum WebViewURL {
    static let AboutUs = "https://omninos.life/telecare/aboutUs.php"
    static let Support = "https://omninos.life/telecare/support.php"
    static let TermsCondition = "https://tap.sa/#"
    static let FAQs = "https://tap.sa/faq"
}

enum Assets {
    static let Back = "back"
    static let BurgerMenu = "menu"
    static let redBurgerMenu = "menu_Red"
    static let plusBlank = "plus-blank"
    static var BackWhite1: UIImage { return "BackAerrowWhite".localizedImage! }
    static let BackWhite = "BackAerrowWhite"
    static let ChangePassword = "ChangePassword"
    static let EditProfile = "EditProfile"
    static let SaveProfile = "SaveProfile"
    static let PaymentMasterCard = "PaymentMasterCard"
    static let PaymentVisa = "PaymentVisa"
    static let PaymentMada = "PaymentMada"
    static let CategoryWhite = "CategoryWhite"
    static let ProductCart = "ProductCart"

    static let TabHomeNormal = "Home-normal"
    static let TabHomeActive = "Home-active"
    static let TabCategoryNormal = "Categories-normal"
    static let TabCategoryActive = "Categories-active"
    static let TabCartNormal = "Cart-normal"
    static let TabCartActive = "Cart-active"
    static let TabMoreNormal = "More-normal"
    static let TabMoreActive = "More-active"

    static let ClockUnSelecten = "clock-text-en"
    static let ClockSelecten = "selectClock-en"

    static let ClockUnSelectar = "clock-text-ar"
    static let ClockSelectar = "selectClock-ar"

    static let FavouriteProduct = "favourite"
    static let UnFavouriteProduct = "unfavourite"

    static let FavouriteProductBlue = "ProductFavourite"
    static let UnFavouriteProductBlue = "ProductUnfavourite"

    static let MoreMyorders = "moreMyorders"
    static let MoreMyAddress = "moreAddress"
    static let MoreMyAccount = "moreAccount"
    static let MoreWishlists = "moreWishlist"

    static let AppPlaceHolder = "appplaceholder"
    static let BannerPlaceHolder = "bannerPlaceholder"
    static let ProductPlaceHolder = "productPlaceholde"
}

enum PHOTO_OPTION {
    static let CAMERA = "Capture Photo"
    static let LIBRARY = "Choose from Gallery"
}

enum MEDIA_OPTION {
    static let Image = "Image"
    static let PDF_File = "PDF File"
}

enum TblCellIdentifier {
    static let SideMenuHeader = "TblCell_HeaderSidemenu"
    static let NotificationList = "TblCell_NotificationList"
}

enum SegueIdentifier {
    // Customer Segue
    static let NavigateToCustomerLogin = "NavigateToCustomerLogin"
    static let NavigateToCustomerSignup = "NavigateToCustomerSignup"
    static let NavigateToCustomerForgotPassword = "NavigateToCustomerForgotPassword"
    static let NavigateToCustomerHome = "NavigateToCustomerHome"
}

enum PhotoOption {
    static let Camera = "Capture Photo"
    static let Library = "Choose from Gallery"
}

enum MediaOption {
    static let Image = "Image"
    static let PDF_File = "PDF File"
}

enum Title {
    static let Mr = "Mr."
    static let Mrs = "Mrs."
    static let Miss = "Miss."
}

enum PaymentOptions {
    static let MasterCard = "MasterCard"
    static let Visa = "Visa"
    static let Mada = "MADA"
}

// MARK: - Constants

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let ArrayGender = ["Male".localized, "Female".localized]
let ArrayPaymentOptions = [PaymentOptions.Visa, PaymentOptions.MasterCard, PaymentOptions.Mada]

let arrStateList = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY", "PR", "VI"]

// https://developer.deepar.ai/projects
// vinaytiwarij88@gmail.com / 123456789
let deeparAIAppKey = "7b9cedd7e8fb91d48930f813a603c8e371f9f725f5d3941efd97464a0678cf32c9976819cfa7acd0"

var globleStaffNameList = [StaffNameModel]()

var isMyProfile = true
var profileUserID = ""
var isFromDashOrTrending = ""
var isFromDasTabORProfileTabBar = ""
// var playerItemSelectedSound:CachingPlayerItem?
// var dictSelectedSoundTrack : SoundsDetail?
// var dictSelectedSoundTrack : SoundsDetail?
var isDownloadDone = false {
    didSet {
        print("isDownloadDone updated")
    }
}

// var dictSelectedSoundTrack : SoundsDetail? {
//    didSet {
//        print("Selected URL : \(dictSelectedSoundTrack?.sound ?? "")")
//        playerItemSelectedSound = CachingPlayerItem(url: URL(string: dictSelectedSoundTrack?.sound ?? "")!)
//        playerItemSelectedSound!.download()
//    }
// }

var urlRecoredVideo: URL?
var arrPrivacySettings = [["title": "Allow Comments", "desc": "1"], ["title": "Allow Duet and React", "desc": "1"], ["title": "Allow Downloads", "desc": "1"]]

enum OTP_FOR: String {
    case email
    case phone
    case account
}

class Constant {
    static func getThisMonth() -> (String, String) {
        let firstdate = "\(Date().startOfMonth())"
//        let lastdate = "\(Date().endOfMonth())"
//        let lastdate = "\(Date.yesterday)"
        let lastdate = "\(Date())"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        let date1 = dateFormatter.date(from: firstdate)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let date2 = dateFormatter.date(from: lastdate)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return (dateFormatter.string(from: date1!), dateFormatter.string(from: date2!))
    }
}
