//
//  ProjectUtilities.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import AVFoundation
import AVKit
import MobileCoreServices
import UIKit

class ProjectUtilities: NSObject {
    class func calcAge(birthday: Date) -> Int {
        let birthdayDate = birthday
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate, to: now, options: [])
        let age = calcAge.year
        return age!
    }

    class func checkInternateAvailable(viewController _: UIViewController, isGOback _: Bool = false) -> Bool {
        if !Connectivity.isConnectedToInternet() {
            App_AlertView.shared.SimpleMessage(Text: ValidationMessages.internetMSG)

            return false
        } else {
            return true
        }
    }

    // MARK: - Change DateForamatter

    class func stringFromDate(date: Date, strFormatter strDateFormatter: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormatter

        let convertedDate = dateFormatter.string(from: date)

        return convertedDate
    }

    class func dateFromString(strDate: String, strFormatter strDateFormatter: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormatter

        let convertedDate = dateFormatter.date(from: strDate)

        return convertedDate!
    }

    class func changeDateFormate(strDate: String, strFormatter1 strDateFormatter1: String, strFormatter2 strDateFormatter2: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormatter1

        if let date = dateFormatter.date(from: strDate) {
            dateFormatter.dateFormat = strDateFormatter2
            return dateFormatter.string(from: date)
        }
        return ""
    }

    class func timeStampToStringDate(timestamp: Double, dateFormatter: String) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter
        let strDate = formatter.string(from: date)

        return strDate
    }

    class func timestampToOrdinaryDateFormate(timestamp: Double, formatter strDateFormatter: String) -> String {
        let date = Date(timeIntervalSince1970: timestamp)

        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)

        // Formate
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = strDateFormatter
        let newDate = dateFormate.string(from: date)

        var day = "\(anchorComponents.day!)"
        switch day {
        case "1", "21", "31":
            day.append("st")
        case "2", "22":
            day.append("nd")
        case "3", "23":
            day.append("rd")
        default:
            day.append("th")
        }
        return day + " " + newDate
    }

    class func animatePopupView(viewPopup: UIView) {
        viewPopup.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)

        UIView.animate(withDuration: 0.3 / 1.5, animations: {
            viewPopup.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)

        }) { _ in

            UIView.animate(withDuration: 0.3 / 2, animations: {
                viewPopup.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            }, completion: { _ in

                UIView.animate(withDuration: 0.3 / 2, animations: {
                    viewPopup.transform = CGAffineTransform.identity
                })
            })
        }
    }

    class func loadingShow() {
        // appDelegate.fnForAddLoader()
    }

    class func loadingHide() {
        // appDelegate.fnForRemoveLoader()
    }

    class func showAlert(vc: UIViewController, strTitle _: String, strMessage: String) {
        let alert = UIAlertController(title: "", message: strMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }

    class func isValidEmail(_ strEmail: String) -> Bool {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" + "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: strEmail)
    }

    class func validateMobile(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: value)
        return result
    }

    class func timeAgoSinceDate(_ date: Date, currentDate: Date, numericDates: Bool) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components: DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute, NSCalendar.Unit.hour, NSCalendar.Unit.day, NSCalendar.Unit.weekOfYear, NSCalendar.Unit.month, NSCalendar.Unit.year, NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())

        if (components.year! >= 2) || (components.year! >= 1) {
            return ProjectUtilities.stringFromDate(date: date, strFormatter: "dd MMMM yyyy hh:mm a")

        } else if (components.month! >= 2) || (components.month! >= 1) || (components.weekOfYear! >= 2) || (components.weekOfYear! >= 1) || (components.day! >= 2) {
            return ProjectUtilities.stringFromDate(date: date, strFormatter: "dd MMMM hh:mm a")
        } else if components.day! >= 1 {
            if numericDates {
                return "1 day"
            } else {
                return "Yesterday"
            }
        } else if components.hour! >= 2 {
            return "\(components.hour!) HR"
        } else if components.hour! >= 1 {
            return "1 HR"
        } else if components.minute! >= 2 {
            return "\(components.minute!)MINS"
        } else if components.minute! >= 1 {
            return "1M"
        } else if components.second! >= 3 {
            return "\(components.second!)S"
        } else {
            return "Just now"
        }
    }

    class func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    class func hexToColor(hexString: String, alpha: CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xFF) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }

    class func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }

    class func setShadow(_ view: UIView) {
        let layer = view.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.4
        layer.masksToBounds = false
    }

    enum SCREEN_SIZE {
        static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    }

    class func getSafeAreaTopPadding() -> CGFloat {
        var topPadding: CGFloat = 0
        if #available(iOS 11.0, *) {
            topPadding = (appDelegate.window?.safeAreaInsets.top)!
        }
        return topPadding
    }

    class func getSafeAreaBottomPadding() -> CGFloat {
        var bottomPadding: CGFloat = 0
        if #available(iOS 11.0, *) {
            bottomPadding = (appDelegate.window?.safeAreaInsets.bottom)!
        }
        return bottomPadding
    }

    class func pushFromBottom(_ navigationController: UINavigationController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        navigationController.view.layer.add(transition, forKey: kCATransition)
    }

    class func popWithReveal(_ navigationController: UINavigationController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController.view.layer.add(transition, forKey: kCATransition)
    }

    class func findUniqueSavePath(data: Data) -> String? {
        let mimeType = Swime.mimeType(data: data)
        var path: String
        let df = DateFormatter()
        df.dateFormat = "ddMMyyyhhmmss"
        path = "\(df.string(from: Date())).\(mimeType?.ext ?? "")"
        return path
    }

    class func findUniqueSavePathImage() -> String? {
        var path: String
        let df = DateFormatter()
        df.dateFormat = "ddMMyyyhhmmss"
        path = "\(df.string(from: Date())).jpg"

        return path
    }

    class func findUniqueSavePathVideo() -> String? {
        var path: String
        let df = DateFormatter()
        df.dateFormat = "ddMMyyyhhmmss"
        path = "\(df.string(from: Date())).mp4"

        return path
    }

    class func findUniqueSavePathPDF() -> String? {
        var path: String
        let df = DateFormatter()
        df.dateFormat = "ddMMyyyhhmmss"
        path = "\(df.string(from: Date())).pdf"

        return path
    }

    class func findUniqueSavePathMP3() -> String? {
        var path: String
        let df = DateFormatter()
        df.dateFormat = "ddMMyyyhhmmss"
        path = "\(df.string(from: Date())).mp3"

        return path
    }

    class func verifyUrl(_ urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }

    class func humanReadableByteCount(bytes: Int) -> (Double, String) {
        if bytes < 1000 { return (Double(bytes), "B") }

        let exp = Int(log2(Double(bytes)) / log2(1000.0))
        let unit = ["KB", "MB", "GB", "TB", "PB", "EB"][exp - 1]
        let number = Double(bytes) / pow(1000, Double(exp))

        print("Number = ", number, "Unit = ", unit)

        return (number, unit)
    }

    class func downloadAndSaveMP3(url: URL, name: String, completion: @escaping (URL?, Bool) -> Void) {
        let documentsUrl: URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let destinationFileUrl = documentsUrl.appendingPathComponent(name + ".mp3")

        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)

        let request = URLRequest(url: url)

        let task = session.downloadTask(with: request, completionHandler: { tempLocalUrl, response, error in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }

                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)

                    DispatchQueue.main.async {
                        completion(destinationFileUrl, true)
                    }
                } catch let writeError {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")

                    DispatchQueue.main.async {
                        completion(nil, false)
                    }
                }

            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription ?? "")
                DispatchQueue.main.async {
                    completion(nil, false)
                }
            }
        })

        task.resume()
    }

    class func findMP3FileInDirectory(name: String) -> (Bool, URL?) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(name + ".mp3") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                return (true, pathComponent)
            } else {
                print("FILE NOT AVAILABLE")
                return (false, nil)
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
            return (false, nil)
        }
    }

    class func generateStringFromSecond(totalSecond: Int) -> String {
        let (hours, min, second) = ProjectUtilities.secondsToHoursMinutesSeconds(totalSecond)

        var strStartTime = ""
        if totalSecond / 3600 > 0 {
            strStartTime = String(format: "%02d:%02d:%02d", hours, min, second)
        } else if (totalSecond % 3600) / 60 > 0 {
            strStartTime = String(format: "%02d:%02d", min, second)
        } else {
            strStartTime = String(format: "00:%02d", second)
        }
        return strStartTime
    }

    class func addYearToDate(date: Date, yearsToAdd: NSInteger) -> Date {
        var dateComponent = DateComponents()
        dateComponent.year = yearsToAdd

        let addedDate = Calendar.current.date(byAdding: dateComponent, to: date)
        print(addedDate!)
        return addedDate!
    }

    class func numberFormat(number: Double) -> String? {
        let largeNumber = number
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: largeNumber))
        if formattedNumber != nil {
            return formattedNumber
        } else {
            return nil
        }
    }

    class func delayWithDispatch(interval: TimeInterval, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            closure()
        }
    }
}

extension Notification.Name {
    static var socketNotConnectedNotification: Notification.Name {
        return Notification.Name("SocketServerNotConnectedNotification")
    }

    static var socketDidConnectedNotification: Notification.Name {
        return Notification.Name("socketDidConnectedNotification")
    }
}

extension URL {
    func mimeType() -> String {
        let pathExtension = self.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }

    var containsImage: Bool {
        let mimeType = self.mimeType()
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
            return false
        }
        return UTTypeConformsTo(uti, kUTTypeImage)
    }

    var containsAudio: Bool {
        let mimeType = self.mimeType()
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
            return false
        }
        return UTTypeConformsTo(uti, kUTTypeAudio)
    }

    var containsVideo: Bool {
        let mimeType = self.mimeType()
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
            return false
        }
        return UTTypeConformsTo(uti, kUTTypeMovie)
    }
}
