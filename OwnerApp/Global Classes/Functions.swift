//
//  Functions.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import AssetsLibrary
import AVKit
import Foundation
import UIKit
import ProgressHUD

func checkFontAndApply(style: AppFont.Weight, size: CGFloat) -> UIFont {
    if Language.language.rawValue == AppLanguages.Arabic {
        var newWeight = style
        if style == .bold {
            newWeight = .bold
        } else {
            newWeight = style
        }
        let fontFamaily = "Poppins" + "-" + newWeight.rawValue
        if let font = UIFont(name: fontFamaily, size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    } else {
        let fontFamaily = "Poppins" + "-" + style.rawValue
        if let font = UIFont(name: fontFamaily, size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
}

func checkPopinsFontAndApply(style: AppFont.Weight, size: CGFloat) -> UIFont {
    if Language.language.rawValue == AppLanguages.Arabic {
        var newWeight = style
        if style == .medium {
            newWeight = .bold
        } else {
            newWeight = style
        }
        let fontFamaily = "Luma" + "-" + newWeight.rawValue
        if let font = UIFont(name: fontFamaily, size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    } else {
        let fontFamaily = "Poppins" + "-" + style.rawValue
        if let font = UIFont(name: fontFamaily, size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
}

func base64ToImage(_ base64String: String) -> UIImage? {
    guard let imageData = Data(base64Encoded: base64String) else { return nil }
    return UIImage(data: imageData)
}

func imageToBase64(_ image: UIImage) -> String? {
    return image.jpegData(compressionQuality: 1)?.base64EncodedString()
}

/*
 * Convert System image into attribute string for label
 */
func getSysImageString(_ systemName: String) -> NSMutableAttributedString
{
    let attachment:NSTextAttachment = NSTextAttachment()
    attachment.image = UIImage(systemName: systemName)?.maskWithColor(color: UIColor(displayP3Red: 0.0, green: 144.0 / 255.0, blue: 81.0 / 255.0, alpha: 1.0))

    let attachmentString:NSAttributedString = NSAttributedString(attachment: attachment)
    let myString:NSMutableAttributedString = NSMutableAttributedString(string: "")
    myString.append(attachmentString)
    return myString
}

var AppDevice: devType {
    let userInterface = UIDevice.current.userInterfaceIdiom

    if userInterface == .pad {
        // iPads
        return .iPad
    } else if userInterface == .phone {
        // iPhone
        return .iPhone
    } else if userInterface == .carPlay {
        // CarPlay
        return .carPlay
    } else if userInterface == .tv {
        // AppleTV
        return .tv
    }
    return .iPad
}

var IS_IPAD: Bool {
    return AppDevice == .iPad
}

enum devType: String {
    case iPad
    case iPhone
    case carPlay
    case tv = "AppleTV"
}

class Functions: NSObject {}

// MARK: - Colours

extension Functions {
    
    static func pushToViewController(_ vc: UIViewController, toVC: UIViewController){
        vc.navigationController?.pushViewController(toVC, animated: false)
    }
    
    
    class func getDictFromPlist(strFileName: String, strFileType: String) -> [String: AnyObject] {
        var propertyListFormat = PropertyListSerialization.PropertyListFormat.xml
        var plistData: [String: AnyObject] = [:]
        let plistPath: String? = Bundle.main.path(forResource: strFileName, ofType: strFileType)!
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        do {
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String: AnyObject]
            return plistData

        } catch {
            print("Error reading plist: \(error), format: \(propertyListFormat)")
        }

        return plistData
    }

    class func HexStringToUIColor(hex: String) -> UIColor {
        var iCString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if iCString.hasPrefix("#") {
            iCString.remove(at: iCString.startIndex)
        }

        if (iCString.count) != 6 {
            return UIColor.gray
        }

        var iRgbValue: UInt32 = 0
        Scanner(string: iCString).scanHexInt32(&iRgbValue)

        return UIColor(
            red: CGFloat((iRgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((iRgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(iRgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    class func jsonString(from object: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    
    static func createDirectoryForDocs() {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("AuthorizedPerson/")
        if !fileManager.fileExists(atPath: paths) {
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        } else {
            print("Already directory created.")
        }
    }

    static func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    static func saveDocToDirectory(_ sampleURL: String, controller _: UIViewController) -> Bool {
        let fileManager = FileManager.default
        var filePath = ""
        var status = false
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: sampleURL),
               let urlData = NSData(contentsOf: url)
            {
                let galleryPath = self.getDirectoryPath()
                let theFileName = (sampleURL as NSString).lastPathComponent
                filePath = "\(galleryPath)/Employee/\(theFileName)"
                print(filePath)
                if !fileManager.fileExists(atPath: filePath) {
                    DispatchQueue.main.async {
                        urlData.write(toFile: filePath, atomically: true)
                        print("Save successful")
//                        common.showPositiveMessage(message: "Save successfully") {
                        //
                        status = true
                    }
                } else {}
            }
            ProgressHUD.dismiss()
        }
        return status
    }
}

// MARK: - User Details

extension Functions {
    class func deleteUserDocumentAllDownloadedFiles() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        guard let items = try? FileManager.default.contentsOfDirectory(atPath: path) else { return }
        for item in items {
            // This can be made better by using pathComponent
            let completePath = path.appending("/").appending(item)
            try? FileManager.default.removeItem(atPath: completePath)
        }
        print("All Downloaded files have been deleted successfully.")
    }
}

// MARK: - Orientations

extension Functions {
    class func setPortrait() {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        UIApplication.shared.statusBarOrientation = .portrait
    }

    class func setLandScape() {
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        UIApplication.shared.statusBarOrientation = .landscapeRight
    }
}

// MARK: - StoryBoard Controllers

extension Functions {
    class func topController(_ parent: UIViewController? = nil) -> UIViewController {
        if let vc = parent {
            if let tab = vc as? UITabBarController, let selected = tab.selectedViewController {
                return topController(selected)
            } else if let nav = vc as? UINavigationController, let top = nav.topViewController {
                return topController(top)
            } else if let presented = vc.presentedViewController {
                return topController(presented)
            } else {
                return vc
            }
        } else {
            return topController(UIApplication.shared.keyWindow!.rootViewController!)
        }
    }
}

extension Functions {
    class func openImagePicker(delegate: ImagePickerDelegate, viewController: UIViewController) {
        ImagePickerHandler.shared.delegate = delegate
        ImagePickerHandler.shared.isEditingAllow = true
        ImagePickerHandler.shared.showPhotoCaptureOptions(vc: viewController)
    }
}

import ContactsUI
import Foundation

enum ContactsFilter {
    case none
    case mail
    case message
}

func isKeyPresentInUserDefaults(key: String) -> Bool {
    return UserDefaults.standard.object(forKey: key) != nil
}

class PhoneContacts {
    class func getContacts(filter _: ContactsFilter = .none) -> [CNContact] { //  ContactsFilter is Enum find it below
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey,
        ] as [Any]

        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }

        var results: [CNContact] = []

        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching containers")
            }
        }
        return results
    }
}

func mergeVideoAndAudio(videoUrl: URL,
                        audioUrl: URL,
                        shouldFlipHorizontally: Bool = false,
                        completion: @escaping (_ error: Error?, _ url: URL?) -> Void)
{
    let mixComposition = AVMutableComposition()
    var mutableCompositionVideoTrack = [AVMutableCompositionTrack]()
    var mutableCompositionAudioTrack = [AVMutableCompositionTrack]()
    var mutableCompositionAudioOfVideoTrack = [AVMutableCompositionTrack]()

    // start merge

    let aVideoAsset = AVAsset(url: videoUrl)
    let aAudioAsset = AVAsset(url: audioUrl)

    let compositionAddVideo = mixComposition.addMutableTrack(withMediaType: AVMediaType.video,
                                                             preferredTrackID: kCMPersistentTrackID_Invalid)

    let compositionAddAudio = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio,
                                                             preferredTrackID: kCMPersistentTrackID_Invalid)

    let compositionAddAudioOfVideo = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio,
                                                                    preferredTrackID: kCMPersistentTrackID_Invalid)

    let aVideoAssetTrack: AVAssetTrack = aVideoAsset.tracks(withMediaType: AVMediaType.video)[0]
    let aAudioOfVideoAssetTrack: AVAssetTrack? = aVideoAsset.tracks(withMediaType: AVMediaType.audio).first
    let aAudioAssetTrack: AVAssetTrack = aAudioAsset.tracks(withMediaType: AVMediaType.audio)[0]

    // Default must have tranformation
    compositionAddVideo?.preferredTransform = aVideoAssetTrack.preferredTransform

    if shouldFlipHorizontally {
        // Flip video horizontally
        var frontalTransform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        frontalTransform = frontalTransform.translatedBy(x: -aVideoAssetTrack.naturalSize.width, y: 0.0)
        frontalTransform = frontalTransform.translatedBy(x: 0.0, y: -aVideoAssetTrack.naturalSize.width)
        compositionAddVideo?.preferredTransform = frontalTransform
    }

    mutableCompositionVideoTrack.append(compositionAddVideo!)
    mutableCompositionAudioTrack.append(compositionAddAudio!)
    mutableCompositionAudioOfVideoTrack.append(compositionAddAudioOfVideo!)

    do {
        try mutableCompositionVideoTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero,
                                                                            duration: aVideoAssetTrack.timeRange.duration),
                                                            of: aVideoAssetTrack,
                                                            at: CMTime.zero)

        // In my case my audio file is longer then video file so i took videoAsset duration
        // instead of audioAsset duration
        try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero,
                                                                            duration: aVideoAssetTrack.timeRange.duration),
                                                            of: aAudioAssetTrack,
                                                            at: CMTime.zero)

        // adding audio (of the video if exists) asset to the final composition
        if let aAudioOfVideoAssetTrack = aAudioOfVideoAssetTrack {
            try mutableCompositionAudioOfVideoTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero,
                                                                                       duration: aVideoAssetTrack.timeRange.duration),
                                                                       of: aAudioOfVideoAssetTrack,
                                                                       at: CMTime.zero)
        }
    } catch {
        print(error.localizedDescription)
    }

    // Exporting
    let savePathUrl = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/newVideo.mp4")
    do { // delete old video
        try FileManager.default.removeItem(at: savePathUrl)
    } catch {
        print(error.localizedDescription)
    }

    let assetExport = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)!
    assetExport.outputFileType = AVFileType.mp4
    assetExport.outputURL = savePathUrl
    assetExport.shouldOptimizeForNetworkUse = true

    assetExport.exportAsynchronously { () in
        switch assetExport.status {
        case AVAssetExportSession.Status.completed:
            print("success")
            completion(nil, savePathUrl)
        case AVAssetExportSession.Status.failed:
            print("failed \(assetExport.error?.localizedDescription ?? "error nil")")
            completion(assetExport.error, nil)
        case AVAssetExportSession.Status.cancelled:
            print("cancelled \(assetExport.error?.localizedDescription ?? "error nil")")
            completion(assetExport.error, nil)
        default:
            print("complete")
            completion(assetExport.error, nil)
        }
    }
}

func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?) -> Void)) {
    DispatchQueue.global().async { // 1
        let asset = AVAsset(url: url) // 2
        let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) // 3
        avAssetImageGenerator.appliesPreferredTrackTransform = true // 4
        let thumnailTime = CMTimeMake(value: 2, timescale: 1) // 5
        do {
            let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) // 6
            let thumbImage = UIImage(cgImage: cgThumbImage) // 7
            DispatchQueue.main.async { // 8
                completion(thumbImage) // 9
            }
        } catch {
            print(error.localizedDescription) // 10
            DispatchQueue.main.async {
                completion(nil) // 11
            }
        }
    }
}
